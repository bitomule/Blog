---
date: 2020-04-13 17:52
tags: Blog, Publish
excerpt: I’ve moved my blog again after just a few months with a good reason.
---

# Moving blog again

I like to play, and I like to play with new things that force me into the unknown (Just a bit). In this case that interested was powered by my old hosting getting into constants problems. I don’t use this blog much but each time I wanted to share a link to explain something the docker running in my home NAS failed.

It was failing for many reasons, all related to how difficult it is to host something at home using a home network. Last months were better, I was able to fix a huge issue related with the NAS network and it was working 99.99% of the time but I still had to keep docker running always and eating resources from my not so big NAS.

So, I decided to give [John Sundell Publish](https://github.com/JohnSundell/Publish) a chance following [this post](https://www.staskus.io/posts/2020-01-26-publish/). It was really easy because Povilas also has all the blog code on GitHub so he solved one of my big issues: HTML & CSS. Based on his amazing work I was able to get the blog up and running.

Some changes from my previous blog:

- **New design** (still really simple)
- **100% static**. For me, that means hosting in GitHub for free
- **Fast**: Because it’s just plain HTML + CSS, served from GitHub and using Cloudflare blog is now crazy fast (As it should be, is just text)

What hasn’t changed:

- **No tracking**: I hate websites tracking so I’m not going to add one to my blog. The only metrics I get are from Cloudflare and that’s just the number of visits.
- **https**: It was just a toggle in Cloudflare so...

That’s all for today, please let me know on twitter if you’ll like to read a post explaining all the blog migration process including Publish usage, GitHub pages, and Cloudflare.