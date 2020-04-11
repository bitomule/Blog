---
date: 2019-03-09 16:05
tags: Web, NAS
excerpt: Today I want to share another experience with my NAS, in this case, I'll talk about how to replace container station with a better alternative called Portainer. 
---
# Using portainer to manage container station

Today I want to share another experience with my NAS, in this case, I'll talk about how to replace container station with a better alternative called Portainer.

As you may know, I've played with docker on my Qnap NAS. This has to lead me to hate container station software. It has too many limits and issues so as one of my experiments I wanted to find a replacement to it.

The best replacement I've found is portainer and as always, when you know what you want the steps to do it are a lot easier.

In this case, installing portainer was as easy as going to the community qnap store and installing [Portainer](https://forum.qnap.com/viewtopic.php?t=133975). After that, you'll have portainer up and running but it'll be useless. You have to connect it to your container station docker, and you can do it 4 easy steps:

1. Open container station, go to preferences, docker certificate tab and copy the command you'll see in the "Set environment" field.
2. Open an SSH connection with your NAS (I'm assuming you already know how to do this, otherwise It'll be easy to find it on Google), paste the command you copied and execute it.
3. Go back to container station, same preferences screen and now click download. This will download the certificates required to connect to the local docker installation.
4. Open portainer, navigate to endpoints and create a new one filling:

- **Name** (The name you want to use)
- **Endpoint Url**: Your NAS IP with the port you saw on container station settings command
- **Public IP**: Your public IP / DDNS (if you want to)
- **TLS**: enabled
- **Certificates and key** (upload the ones you downloaded from container station preferences)

Now you're ready to use portainer as a replacement to container station. You can download images, create containers, reboot... Just avoid using container station and portainer at the same time (some configurations don't work) and playing with network interfaces. 

I've been using portainer for some days and It's working really well. For example, you can use the Caddy app template and follow my post to [run your own site on your NAS.](https://blog.bitomule.com/running-a-website-from-your-qnap-nas/)

If you have any question feel free to ask me on [twitter](https://twitter.com/bitomule) or [mastodon](https://mastodon.social/@bitomule).
