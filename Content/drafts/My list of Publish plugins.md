---
date: 2020-06-01 11:06
tags: Publish, Web, Swift
excerpt:
title: My list of Publish plugins
---

If you have already read my posts about getting started with publish and automatic your deploy, you may also be interested in what plugins I use to make my life easier. This is my list of Publish plugins:

## Splash

This is the more obvious one. If you’re using Publish to deploy your site, is quite possible you are interested in showing code snippets in your posts. Splash is also created by John Sundell and it creates a nice HTML formatted snipped from Swift code. You have other options for other languages, but if you’re just interested in Swift Splash is the best option.

### How to add it

You can add Splash to your project using:

```swift
.package(url: "https://github.com/johnsundell/splashpublishplugin", from: "0.1.0")
```


## Generate CNAME

This one is interesting if you’re publishing using Github Pages. It allows you to declare the custom domain urls that can access your blog using a CNAME registry in your domain DNS. If you like to have everything under source control this is the best option.

### How to add it

You can add Splash to your project using:

```swift
.package(url: "https://github.com/SwiftyGuerrero/CNAMEPublishPlugin", from: "0.1.0")
```


## Verify Resources Exists

I’m not using many images on my blog posts but this plugin ensures that when I do the image is there. With an automated site deploy this becomes more interesting as I don’t preview the site before pushing to remote. If some file is missing the deploy will fail and I’ll now before a broken blog gets published.

### How to add it

You can add Splash to your project using:

```swift
.package(url: "https://github.com/wacumov/VerifyResourcesExistPublishPlugin", from: "0.1.0")
```

## Custom 404 page

This one is just a custom plugin I added to my blog. When I moved to Publish I didn’t care much about my previous blog urls so all the links and SEO I had got lost. Each time someone used one of those links they will just get a Github 404 page.

I fixed this by adding my own 404 page that does a redirection using JavaScript and a simple url replacement. This is far from good for SEO but to be honest I just wanted old links to work for humans.

The plugin code is:

```swift
.init(name: "Include 404", installer: { context in
            try context.copyFileToOutput(from: "Content/404.html")
        })
```

You can check my custom 404 file in my blog repository. Feel free to copy or suggest improvements. 