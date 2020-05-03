---
date: 2020-05-01 10:05
tags: Publish, Swift, Github, Web
excerpt: I have already shared how to get started with Publish. Today I’ll share how I’m automating the deploy process using Github Actions and how it enabled editing from my iPad.
title: Automating deploy of your publish site to github pages
---
This is the second post about Publish, the static website building tool by John Sundell.

I have already shared how to [get started](https://blog.bitomule.com/posts/getting-started-with-publish/) and today we will focus on publishing the website.

As today Publish does not include an official method to deploy to [github pages](https://pages.github.com/) but a [PR is already open](https://github.com/JohnSundell/Publish/pull/74). Although we don’t have that support we can publish just using the github deploy method.

## Creating the repo

In order to deploy your blog in Github Pages you have to create a new repository where only the published blog will live. This means that if you already have a repo with your site source code, you will have to create a new one to host the static files.

Just create an empty Github repository and you are good to go.

## Deploy

On the previous post we created our own theme, but we didn’t focus much in the publish method. It may look like this right now:

```swift
try Blog().publish(
    withTheme: .blog
)
```

This is just enough to generate a site that you can manually upload to whatever hosting you choose. If you want publish to deploy the site for you, you need to add the deployUsing argument. In our case we want to deploy using github so it will look like:

```
try Blog().publish(
    withTheme: .blog,
    deployedUsing: .gitHub("yourusername/yourrepo"),
)
```

Use the repo you have just created as the target repository and now you can just run:

```bash
publish deploy
```

Then Publish will deploy the generated files to your empty repo. You can use this command each time you want to deploy your site.

## Enabling github pages

In order to activate your site, you have to enable Github Pages for the repository with your static files. To do that just go to your repository settings, scroll down to GitHub Pages and configure it. You can use a custom domain if you want to and choose master as the source (that is why you have a repo with site content only).

This will create a CNAME file in your repository telling GitHub the domains it can handle. Also keep in mind you will have to change your domain DNS CNAME registry to your Github page url.

If you prefer to use https with a custom domain you will have to use [Cloudflare](https://www.cloudflare.com/) (A free CDN service) that will also improve your site speed. Please [let me know](https://twitter.com/bitomule) if you are interested in a blog post about the Cloudflare setup.

## Automating

Right now you should have your website running, available to the public and deployed using a one line command.

This is good enough for most people, but we can go one step further and make it automatic so a new website version will be deployed each time we commit changes to our blog repository.

We can do this for free using [Github Actions](https://github.com/features/actions). We will create a new Github Action workflow in the repo that hosts our blog source that will:

- Launch a macOS virtual machine
- Checkout our repo
- Generate static files
- Publish to your Github Pages repository
- Commit changes to source repo (you can skip this one and ignore output folder in your source repo)

In order to create your first Github Action, go to the Actions tab in your source repo and tap New Workflow. You may choose the getting started Workflow and delete all the content.

Here you have the YAML file I use in my own repo:

```
name: Publish

on:
  push:
    branches: [ master ]

jobs:
  build:
    runs-on: macOS-latest

    steps:
    - uses: actions/checkout@v2
  
    - name: Generate blog
      run: swift run Blog
    - name: Publish in github pages repo
      uses: crazy-max/ghaction-github-pages@v1.4.0
      with:
        repo: youruser/yourrepository
        target_branch: master
        keep_history: true
        allow_empty_commit: false
        build_dir: Output
        committer_name: yourname 
        commit_message: Update blog content
      env:
        GITHUB_PAT: ${{ secrets.REPO_TOKEN }}
        
    - name: Add & Commit changes
      uses: EndBug/add-and-commit@v4.0.1
      with:
        author_name: yourname
        message: Commit new output
```

The last step to get this working is [creating a Github token](https://help.github.com/en/enterprise/2.17/user/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line) with access to your Github Page repository and adding it inside your source repository Secrets as REPO_TOKEN (you can find secrets inside your repository settings).

Now each time you commit to the master branch of your source repository Github will publish the content for you. Isn’t it awesome?

## Drafts

Automation feels like magic as you no longer have to go through Publish, but it also means that each time you commit your blogpost it will get published and all your readers can see it. To avoid this I created a drafts folder next to my blogposts. It is still possible to read them if people gets into the repository, but they are not available in the published website.

You can also use branches and even create pull requests if that makes sense to you.

## iPad blogging

I’m not going to lie, I added all this automation because I wanted to write my blogposts using my iPad and running publish deploy from the iPad is just not possible (as today 😛).

My setup is quite easy but works really well:

- I use **Working copy** to manage the repository. It is not a cheap application, but it does an amazing job if you want to have a git repository on your iOS device. The best feature of Working copy is that it shares you repository as a resource inside Files app and that means you can open and edit files from your repo inside other apps.
- That other app, in my case, is **iA Writer**. I’ve been trying multiple markdown editing applications, but iA Writer has the support to open folders from Files sources and that is just what I need. I just have 2 folder references inside iA Writer: posts and drafts. 
- I have a custom shortcut to create metadata for each blog


So the process when I want to start a new blog post is:
1. Run a shortcut from my iPad home screen
2. Type tile and tags (I want to improve this step using Data Jar to have some already defined tags)
3. The shortcut opens iA Writer for me so I just have to create a new draft, paste metadata and start Writing.

Once the draft is ready to be published I just move it to the posts folder, push my repository to remote and Github Actions takes care of publishing it.

I hope you have enjoyed reading this and it helps you improve your blogging flow so you can share more interesting content with all your readers. Please let me know if you want to know more about something or there is something you missed 🙂.


