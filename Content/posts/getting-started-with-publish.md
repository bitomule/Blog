---
title: Getting started with publish
date: 2020-04-17 19:00
tags:  Blog, Publish
excerpt: I just moved my blog to github pages using Publish and the first steps were consusing and difficult. John Sundell built an amazing tool, but a one man effort can't solve and document everything. I will write a series of posts about Publish trying to explain all the details to get a website up and running using Publish.
---
As you may have seen [I’ve moved my blog again](https://blog.bitomule.com/posts/moving-blog-again/) and I’m using. [Publish](https://github.com/JohnSundell/Publish)) ,an static website builder.  But, what does static mean?

## Static website
Static means that the website does not change while it’s deployed. There is no backend logic deciding what to render. It also means:

* Cheaper hosting as is just serving HTML + CSS
* Free hosting using Github pages
* Speed
* Some features are not possible

My old blog was already working like an static blog in terms of features but I had to host it on my own NAS. The speed was not bad due to my blog not having much traffic but any traffic increase would have made it crazy slow.

## Publish
Now that we know what Publish offers, let me say that it’s far from being the first option in the market and it’s also far from being the most used or the one with the biggest community. You have tons of alternatives to build an static website and it’s not so difficult to do a custom one just for your site.

So, why did I use Publish then? 

There is one big difference, something that makes Publish different: it is written in Swift. Not only the website generation is Swift, even the HTML is written using Swift because it uses [Plot](https://github.com/johnsundell/plot). This made me think that at least I should give it a try.

The exploring Publish task stayed in my “someday list” for months until my NAS hosted blog went down (I deleted the wrong docker and I had to restore it again which took me hours). That was the trigger that made me try Publish and I will try to explain it all in a series of posts; let’s get started:

## Getting started
The first thing you need to do is cloning and building Publish using:

```
$ git clone https://github.com/JohnSundell/Publish.git
$ cd Publish
$ make
```

And then adding just create the folder where you want your blog to live and run publish new:

```
$ mkdir MyWebsite
$ cd MyWebsite
$ publish new
```

Now you can open the generated Package.swift and that will open your Website project.

## Basic project

The first thing you will see once you open the Package is that it will fetch all the dependencies Publish uses including Ink, Plot…

It will look something like this:

![](/images/getting-started-with-publish-1.png)

**Content** is the folder where your markdown files should live grouped by section (Publish groups by section). You can also include an index file although that was one of the first things I removed.

**Resources** is the place where assets should live: CSS, custom fonts, images… It will get copied to your generated website.

**Sources** Here you will find all the Swift code. Inside MyWebsite folder you will find main.swift. This is the entry point of the swift tool. I suggest keeping it just to trigger the publish command.

## Creating a template

By default Publish uses an empty template called Foundation but it is really easy to create new a one. 

1. Inside Sources/MyWebsite (this will be the name of your own website) create a new folder using the name that will describe your Theme. In my case just BlogTheme.
2. Create a new swift file that will contain the theme factory
3. Inside create a struct that will implement  HTMLFactory method

```swift
struct BlogHTMLFactory: HTMLFactory {
```

This will tell you to implement all the missing methods. Each of this methods represents different parts of your website and you just have to return HTML from it. 

For example, makeIndexHTML in my case looks like:

```swift
func makeIndexHTML(for index: Index, context: PublishingContext<Blog>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: context.site),
            .body(
                .grid(
                    .sidebar(for: context.site),
                    .posts(
                        for: context.allItems(
                            sortedBy: \.date,
                            order: .descending
                        ),
                        on: context.site
                    ),
                    .footer(for: context.site)
                )
            )
        )
    }
```

If you try to copy paste this into your own blog it will fail. Why? I am already using some of the swift power to create new HTML components. Grid, for example, is a reusable component that takes any amount of nodes and displays them in a grid using pure css.

How can you create your own custom node?

Just create a new Nodes folder inside your theme folder and create an extension of Node type. Node+Grid.swift for example.

Inside this file extend Node where Context == HTML.BodyContext because there is where you want this component to work. Then inside create your static function taking a variadic parameter of Node type and returning also a Node. Like this:

```swift
extension Node where Context == HTML.BodyContext {
    static func grid(_ nodes: Node…) -> Node {
        .div(
            .id(“layout”),
            .class(“pure-g”),
            .group(nodes)
        )
    }
}
```

For my blog I used the already amazing work done by [@PovilasStaskus](https://twitter.com/PovilasStaskus) and just changed some details to fit what I wanted for my own blog.

Following this approach of small and reusable components you will compose each of the screens needed for your blog.

Remember that each of the functions will give you all the information you need to create your HTML.

## Using your custom theme
Ok, you have finished your theme but your site is still using default Foundation theme.

In order to use the new theme you have created, you have to extend Theme type where Site == YourSiteType like:

```swift
extension Theme where Site == MyWebsite {
    static var blog: Self {
        Theme(htmlFactory: MyWebsiteHTMLFactory())
    }
}
```

Now you can use this new blog variable inside main on the publish method. Change .Foundation with .blog or the name you defined and you’re ready.

## Running your site
Now you have multiple options to see your blog. We will see in future posts how to deploy to remote, but right now you can run in Xcode to generate the HTML files in output folder or go to terminal and run:

```
publish run
``` 

This will start a python web server so you can see your website running locally and do all the changes you need to do without pushing to a remote server.

In the next blog post I will explain how you can publish your blog for free in GitHub pages.
