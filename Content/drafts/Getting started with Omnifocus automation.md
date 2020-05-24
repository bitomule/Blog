---
date: 2020-22-24 20:22
tags: OmniFocus, Automation
excerpt:
title: Getting started with Omnifocus automation
---

## What´s omnifocus automation

Omnifocus automation is the new automation framework by Omni group and it´s planned to work across all their apps.

It uses Javascript as the language where you can build almost anything.

## History

The Omni group has been always close to automation. For years it was possible to automate macOS apps like Omnifocus using the macOS standard automation language: AppleScript

Automation scene has been changing as users move more into iOS and request automation features there also. There’s no AppleScript support on iOS and the replacement is still far from being as powerful (Shortcuts).

Now the Omni group is setting the gold standard with automation support across all the platforms they support. We can finally automate using the same code for iOS and macOS.

## Action

So let´s get started. The first thing you need to know is what´s an Action. 

An Action is is the smallest script you can build and it´s all you need to get started.

It´s composed by 2 parts:

- Metadata
- Script

The first part is created as a comment when creating a single action. It will look like:

```
/*{
	"type": "action",
	"targets": ["omnigraffle","omnioutliner","omniplan","omnifocus"],
	"author": "Your Name or Company",
	"identifier": "com.youOrCompany.appInitials.actionName",
	"version": "1.0",
	"description": "Description of this action.",
	"label": "The menu item text",
	"shortLabel": "Palette Text"
}*/
```

The second part is the function that will describe the action. It has two main parts: the action itself and the validation, that allows you to define when this action will be available (Only when a task is selected for example).

This part looks like:

```JavaScript
(() => {
	
	var action = new PlugIn.Action(function(selection, sender){
		// action code
	});

	action.validate = function(selection, sender){
		// validation code
		return true
	};
	
	return action;
})();
```

You can learn more about this simple actions [here](https://omni-automation.com/actions/action-01.html)

## Your first basic action

We’re going to build our first action for Omnifocus . It’ll be an action that will append “Hello” to the name of the current selected task.

You can start by using the [OmniFocus template generator](https://omni-automation.com/ofac/index.html). It will help you get your first omnijs file. You can choose any option for input as we’ll change it later.

Once the template is generated copy and paste it in a new file with .omnijs file extension.

The template will look like:

```JavaScript
/*{
	"type": "action",
	"targets": ["omnifocus"],
	"author": "bitomule",
	"identifier": "com.bitomule.test",
	"version": "1.0",
	"description": "This is a test",
	"label": "Test",
	"shortLabel": "Test"
}*/
(() => {
	var action = new PlugIn.Action(function(selection, sender){
		// action code
		// selection options: tasks, projects, folders, tags
		task = selection.tasks[0]
		<# PUT YOUR PROCESSING CODE HERE #>
	});

	action.validate = function(selection, sender){
		// validation code
		// selection options: tasks, projects, folders, tags
		return true
	};
	
	return action;
})();
```

### Validate

We’ll focus first on validation. This function will tell OmniFocus when this action is available. In our case we want it to be available when a task is selected to we can just template the code inside {} with:

```javascript
return selection.tasks.length === 1
```

### Action

The next step is the action code itself. We want this action to change the name of the selected task.

First we need to get into selected tasks:

```javascript
selection.tasks
```

This will give us a reference to all the selected tasks.

Next we’ll grab the first (and only) selected task.

```javascript
selection.tasks[0]
```

And finally we’ll set the name:

```javascript
selection.tasks[0].name = selection.tasks[0].name + “Hello”
```

This is probably the top useless action you can build but it works to get the basics.

## Adding an action

We’ve created the action but we need to add it so it can be used with OmniFocus.

Omni group made this process really easy and flexible so you can continue editing your action when it’s already added to the app.

### macOS

I’ll start with the process to add the action to your macOS OmniFocus app.

1. Go to the Automation menu (You need the latest update of OmniFocus)
2. Tap Modules 
3. Tap add
4. Find the folder where you want your scripts to live. I recommend using a folder you can synchronize with your iOS devices (It you want to use automation on iOS)
5. All the omni.js files of that folder will now be available and you can even add them to your toolbar


## iOS

For iOS the process is similar.

1. Tap on the terminal like icon

/images/omnifocus-automation-ios-menu.png

2. Tap on configure modules
3. Tap on Add linked folder
4. Select the folder that will host your scripts
5. All the omni.js files of that folder will now be available from the terminal like button and you can also set a keyboard shortcut for it from configure modules


## What´s next

There’s a lot of options you can explore with Omni automation. You can start exploring the API and creating your own actions although I suggest reading first Omni docs about [plugins](https://omni-automation.com/plugins/index.html).

I may write more posts about automation with OmniFocus if there’s anyone interested. Please just let me know. Some ideas I have are:

- Explaining libraries or how to bundle common actions into shared libraries
- Explain creation of multiple scripts like:
	- Opening the linked url in selected task or project note
	- Transforming a task into a project in an specific folder
	- Creating a project based on a template