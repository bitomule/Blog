---
title:Introducing SwiftyPods: generate your podfile using Swift 
date: 2020-04-22 19:36
tags: SPM,CommandLine,Project,Swift
excerpt: I wanted to create a Swift command line tool for months and finally I found the need.

I just published it as an open source package available in homebrew and mint , a tool to generate using a Swift DSL your CocoaPods podfiles. 

I’ve learned a lot and I’ll try to share some of the details of the development process.
---
I’ve been working on this for weeks and today I am happy to finally share it with you.

SwiftyPods started with me exploring options to improve how we create feature modules at Wallapop. You can see my talk at NSSpain [here](https://vimeo.com/showcase/6319394/video/362160599) about our approach to modules.

One of the first issues I saw is that our project had one single podfile including dependencies from main app and modules. We think that the long term solution will be getting our modules closer to Swift package manager but we are not there yet (hopefully SPM 5.3 with binaries support and assets will get us closer). 

I have been interested in building a command line tool using Swift for long time, so it looked like the perfect opportunity to solve the problem using one.

I am not sure yet if it will be useful for us or if just and experiment. What I know is that I had a lot of fun building it.

Keep reading if you want some details about the implementation; if you just want to use it go to the repo at [github](https://github.com/bitomule/SwiftyPods/blob/master/README.md) (I think I made it easy to use).

## DSL

The domain specific language built for SwiftyPods is the first thing I created as a proof of concept and is one of the last things I finished. Right now I like the result although it is missing a lot of features.

I built it trying to be as close to Swift Package Manager and also trying to make it easier to grow in the future without breaking changes.

The result is:

```swift
let podfile = Podfile(
    targets: [
        .target(
            name: "Target",
            project: "Project",
            dependencies: [
                .dependency(name: "Dependency1"),
                .dependency(name: "Dependency2",
                            version: "1.2.3"),
                .dependency(name: "Dependency3",
                            .git(url: "repo"),
                            .branch(name: "master"))
            ],
            childTargets: [
                .target(name: "ChildTarget", project: "Project2")
            ]
        )
    ]
)
```

There are some interesting details about it:

* Autocomplete does not work in 5.1, but as soon as I changed to 5.2 it started to work
* It is crazy easy to add new options to dependency as the parameter is a variadic taking any amount of dependency configurations. Soon I will add better and safer versioning support without breaking changes
* A child target is not the same as a target. This way it is impossible to set options like inheriting search paths in a target but it is possible in a child target.
* I explored using function builders, but I did not see many improvements and I wanted to stay closer to SPM

The first experiment was hardcoding a template inside the package and running the first command, generate. After some fixes is worked as expected so I moved on to the next feature.

## Editing

Once I had a basic DSL, I noticed that in order to get the advantages from it I needed to build a way to edit those files. 

I explored other tools, like Tuist, searching for options that solved similar problems. 

I could not find an easy solution, but it turned up thanks to my good friend (and better engineer) [Hector](https://github.com/hectr): he suggested generating a package.swift and using it to edit files.

It worked and it was really easy, but it had two main issues:

- I wanted my solution to support having podfiles in multiple folders and this solution only allowed files in the same folder or at least in the same folder as the package.swift I was generating
- Autocomplete was not working as expected and a Swift DSL without autocomplete was a half baked solution 

In order to solve the first problem and after talking with Hector again (yes, he helped me a lot during the development), he suggested using symbolic links to those files so Xcode will recognize them when the package.swift was opened. 

That solved the issue excepting Xcode hates symbolic links; you can read them, but when you want to save changes the file is just not there for Xcode.

The way I solved it is not very elegant, but it works: 

1. When user runs the edit command I create a package.swift
2. Copy all the podfile.swift files to sources folder
3. Open the package.swift. 
4. Wait for use finish editing confirmation in terminal
5. Copy files back to original paths and delete generated stuff

That solved the issue with template files, but in order to solve the autocomplete issue I just had to go one step deeper with SPM: instead of generating a package.swift I had to use it to create a real Xcode project (yes, SPM can do that).

## Dependencies

When you are building an app including or not a dependency has some implications, but user experience is not the main concern. In this case it was, either with a simple package.swift or a full Xcode project, editing meant downloading all the dependencies before you can compile your podfiles. Even worse, with a generated Xcode project you had to wait before even the project was open and you could start editing the file. 

In order to improve the issue, I tried to reduce the number of dependencies by removing Stencil. I added it when I started working because the initial idea was more template focused than DSL, but the usage I was doing now was just replacing some text. I developed that small feature directly in my project and removed the dependency.

Just doing that reduced the time required to editing by a 60%.

## I know nothing

During this development I have learnt more than expected as I got to dig a bit deeper in shell scripting and also I explored a lot of open source projects searching for ideas. I learnt that I knew nothing about command line scripting and now I know a bit more.

Thank you for reading and feel free to ask me through Twitter.
