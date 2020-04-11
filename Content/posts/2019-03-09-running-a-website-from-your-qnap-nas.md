---
date: 2019-03-09 08:44
tags: Web, NAS
excerpt: The first proper post of the blog is something I don't do frequently: playing with the web.
In this post, I'll explain how after some hours I got the blog running with a custom domain and SSL using docker in a qnap NAS.
The process should work on any NAS (with Synology it could be even easier) but I'll explain it using the Qnap process. 
---

# Running a website from your Qnap NAS

The first proper post of the blog is something I don't do frequently: playing with the web.
In this post, I'll explain how after some hours I got the blog running with a custom domain and SSL using docker in a qnap NAS.
The process should work on any NAS (with Synology it could be even easier) but I'll explain it using the Qnap process.

## You'll need:

- A Qnap NAS able to run docker
- Static website you want to host (I used Publii for this part)
- DDNS
- Domain

## Container Station

The first thing you have to install (if you don't have it yet) is Container Station. Just install it from the app center.

## Folders

You'll need 3 different folders on your NAS. Place them where you want to. In my case I created this shared folders with inner subfolders:

- Container Data
- Caddy
- conf
- WebServer

ContainerData is just for configuration and storage for the docker image and WebServer will be the root of the Caddy server, anything we place there will be server from Caddy.

## Caddy

[Caddy](https://caddyserver.com/) is the key part of the process. It's a really simple web server and reverse proxy that creates certificates from let's encrypt automatically. The first step will be installing Caddy docker image on Container Station. If you are running the setup process for the first time it's possible you won't get the configuration loaded. In that case: create a container, delete and start the container creation again.

You'll have to setup:

- Environment: Here ACME_AGREE should be changed to true.
- Network: Choose 3 free ports to make the redirection. You'll need to redirect these ports on the router so take your time to decide what ports are you going to use. The 2015 port is only for development, you don't need to open it on your router.
- Shared folders: In the volume from the host section, you'll have to create 3 volumes. There's a trick. We need to map the configuration file but qnap doesn't allow us to map a file, just folders. To fix this just create a folder called Caddyfile inside conf and delete it once you finish the setup.

![Volumes configuration](/content/images/2019/03/Captura-de-pantalla-2019-03-04-a-las-23.02.08-1.png)
### Configuration file

We almost have Caddy ready, now we just need to create a new file named Caddyfile without extension inside the conf folder. The content, for example, could be:

    yourowndomain.com {
     tls youremail
    
     root /srv
     browse
    
     log stdout
     errors stdout
    }

Save it and restart your container. Caddy should start and it will register a new SSL certificate for your domain. Magic!
![](/content/images/2019/03/giphy-1.gif)
## Ports

You'll have to redirect the ports you set up when creating the container. You have to redirect the external 80 port to the port you mapped to the docker 80 port and the same with 443. Your NAS will use custom ports but both external and docker internal ports should match.

## Domain

There's only one missing part: the domain. You'll need to configure your domain to point to your DDNS host. If you have a fixed external IP just use that IP. In my case, I'm using name.com and the qnap DDNS.

At this point, you have everything ready. Your NAS is serving a static site with SSL. Serving dynamic content either from another service on your NAS on from another docker you'll have to use the IP. Don't use localhost, use the IP instead. For example:

    yourcustomdomain.com {   
    	tls youremail@here.com   
    	proxy / https://192.168.1.57:4433 {     
    		insecure_skip_verify     
    		transparent   
    	}
    }

This will allow you to proxy your domain to a different IP while keeping the SSL. Magic, again.
