---
title:Introducing KitchenOrder
date: 2019-04-11 17:06
tags: Apps
excerpt: Today is a great day. After some days of talking with Apple review team, I got my next app approved, KitchenOrder.
When I work on apps after work I use to work on apps I want to use. I use my knowledge to help with the problems I have but this time I’m releasing something different, in this case, the app was planned to solve a problem for my father.
---
Today is a great day. After some days of talking with Apple review team, I got my next app approved, [KitchenOrder](https://kitchenorder.app).

When I work on apps after work I use to work on apps I want to use, use my knowledge to help with the problems I have. [My first app](https://itunes.apple.com/es/app/tripplan/id1241258595?mt=8) was developed to help me plan my trips and it was super useful (although I don’t use it that much these days) but this one I’m releasing today is different, in this case, the app was planned to solve a problem to my father.

## Why

My father has always been a reference to me. He’s far from being a developer, but I’m sure he’s one of the best chefs in Spain and I find many related things between our jobs. Of course, I’m a terrible chef, because I learned many things from him but never got his love and passion for cooking.

This Christmas I decided my next app would be to help him because we’ve been discussing different approaches to different app models but never got anything done. This time I was decided. It had to be a simple app, of course, and focused on one single task: managing kitchen orders.

Managing a professional kitchen is absolute chaos because you have a lot of professionals working really hard and fast, but only one managing it: calling providers to get the products needed for the kitchen to work every day, avoiding conflicts and also developing new and interesting products. In this case I wanted to solve the part about ordering products.

This is usually done with a mastermind like my father does and notes, lots of papers, tickets, and more notes. Remember to call x this afternoon, when did we order olive oil the last time, it’s impossible we ran out of pears... Times have changed a bit and now it’s possible to order some products through WhatsApp but most of the time the process is done calling directly the provider.

Here’s where KitchenOrder will help my father and I hope someone else out there. KitchenOrder allows you to store providers, products, and orders in the easiest way possible and requiring just the basic information to work. Once you have providers and products stored you can create new orders, schedule them to be reminded in the future and even complete them like a todo list.

## Tech

From a technical point of view I followed the architecture I feel more comfortable with (MVP + Clean), used modules with cocoapods splitting the app into horizontal layers and tried to kept the code as clean as possible, something difficult in personal projects where it’s easy to prioritize building fast to building good.  Some technical details:

- All the cells you see are dynamic height
- The app supports dynamic fonts
- Lot’s of stack views
- [RevenueCat](https://www.revenuecat.com)
- iPad support
- Realm as database layer

### Biggest challenges were:

- **Working with my father as a customer**: I love helping my father but I hate working with clients because you have to help them getting their ideas out and putting that into real features. In this case, it was really interesting and of course, my father was always trying to help and with a good attitude, a “good customer”
- **Subscriptions**: Adding subscriptions was really easy, I used [RevenueCat](https://www.revenuecat.com) and the integration was less than a day (including the subscribe screen) but the problems started with Apple review. I spend a whole week sending the app for review, getting rejected, updating and that, even after having checked all the requirements (privacy, use terms, legal information... omg)

### Why subscriptions?

This was a difficult decision although it was in my mind since the beginning. As I said this app is mainly for my father so if I sell it in the App Store I need to get enough income to allow me to keep the updates coming. I don’t expect to get anything but in case there’s someone else out there interested in the app I think $5 is a fair price if it solves a professional problem to you.

### CloudKit

On [Tripplan](https://itunes.apple.com/es/app/tripplan/id1241258595?mt=8) I was already using CloudKit so I wanted to add it here too. I had it in mind since the beginning so I created plain data models in realm, added [IceCream](https://github.com/caiyue1993/IceCream) pod and in a few minutes, the whole app database was being synced with CloudKit.

### Questions?

I know this app won’t be interesting for many of you, but you can download it for free and if you find issues or anything interesting feel free to ask me on [twitter](https://twitter.com/Bitomule).
