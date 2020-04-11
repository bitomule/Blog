---
date: 2019-03-12 08:10
tags: Web
excerpt: After having my blog up and running there was one piece missing, I didn't have any kind of tracking so it was impossible to know if people were reading me and what were they reading.

Looks impossible, doesn't it?
---
# Tracking your site metrics without sacrificing​ user privacy

After having my blog up and running there was one piece missing, I didn't have any kind of tracking so it was impossible to know if people were reading me and what were they reading.

That's how I started to look for a solution that matched the next requirements:

- Respect users privacy
- Self-hosted
- Free
- Easy to run with my current docker setup

Looks impossible, doesn't it?

That's what I thought after some research. I saw lot's of options, the most commonly used was Google Analytics but that was far from what I wanted. When I was about to lose hope I found [Fathom](https://usefathom.com) and suddenly all the checks were marked:

- **Respects user privacy?** Yep, that's one of their core values. (You can read more about this [here](https://usefathom.com/data/))
- **Self-hosted?** Yep, It's open source and you can host it yourself.
- **Free?** Hell yes
- **Easy to run with my current docker setup?** Well, they have an official docker image, so it should be

> Spoiler: Using their official docker image wasn't easy.

I went to my beautiful [portainer](https://blog.bitomule.com/using-portainer-to-manage-container-station/) client ready to install Fathom from the official image and after a few seconds, it was running. It was running but how do I configure it? Is there any shared volume I can use? Nothing... I couldn't make the official image work.
![](/content/images/2019/03/200.gif)
 I went back to docker hub and I found another image, not official in this case but it had the missing part I needed: a volume.

This image was **[geerlingguy/fathom](https://hub.docker.com/r/geerlingguy/fathom)** and again, in a few seconds, I had it working in portainer. I created a new shared volume ([check my post about portainer to read about that](https://blog.bitomule.com/using-portainer-to-manage-container-station/)) and there started those tricky parts you spend hours searching on google because you don't know how to fix. But don't worry, I have all of them ready for you:

- You have to create and .env file in your shared volume with the content

    FATHOM_SERVER_ADDR=9000
    FATHOM_GZIP=true
    FATHOM_DEBUG=true
    FATHOM_DATABASE_DRIVER="sqlite3"
    FATHOM_DATABASE_NAME="fathom.db"
    FATHOM_SECRET="create-a-random-key-and-paste-it-here"
    

- In order to protect your Fathom with user and password you should run in your docker terminal (connecting with portainer is really easy) :

fathom user add [--email="youremail@blabla.com](--email="youremail@blabla.com)" --password="strong-password"

- Map the port to want to use to the container port 9000
- Reboot your container

Once you have done this things your fathom instance should be up, running and accessible. You'll need the service to be accessible from the outside, I recommend using [Caddy](https://blog.bitomule.com/running-a-website-from-your-qnap-nas/) so you get the proxy and the SSL for free.

The last part is adding the code snippet Fathom requires. You'll find it on your Fathom configuration (from the web UI).

Once you have set up the snipper you'll start receiving metrics on your dashboard free and without compromising your users' privacy.
