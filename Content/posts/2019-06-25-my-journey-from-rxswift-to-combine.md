---
date: 2019-06-25 16:35
tags: Combine, iOS
excerpt: Some days Ago I decided it was the perfect time to start trying Combine by introducing it into my latest project [(The app I made for my father)](https://blog.bitomule.com/kitchenorder/) and this is the story on what issues I’ve found, what I have learned and what I had to fix myself.
---
# My Journey from RxSwift to Combine

Some days Ago I decided it was the perfect time to start trying Combine by introducing it into my latest project [(The app I made for my father)](https://blog.bitomule.com/kitchenorder/) and this is the story on what issues I’ve found, what I have learned and what I had to fix myself.

## iOS 13

The latest Apple release was the biggest change since Swift and I think it could be even bigger.

Keep in mind that Combine is only available for >= iOS 13, it’ll grow in the future and right now feels like it’s far from finished. For [KitchenOrder](https://kitchenorder.app) it’s ok to make iOS 13 a requirement, but we’ll have to wait years before we can introduce it in other projects.

## Realm

The first bump in the road I found trying to introduce Combine was the usage of [RxRealm](https://github.com/RxSwiftCommunity/RxRealm): an amazing library that adds reactivity to Realm using RxSwift.

The problem was replacing the amazing job by RxSwift contributors with a Combine based approach. There wasn’t a library doing this task for me so I decided to build my own: “there’s no much difference between RxSwift and Combine, it should be an easy task”, I (wrongly) thought.

Realm has a nice notification based way to get changes from Realm itself, queries (Results) and single objects and I already had experience with it because I built the same thing for [ReactiveCocoa](https://medium.com/@Bitomule/creating-reactiveswiftrealm-part-1-248ac5c721af) some years ago. It works like this:

    let token = collection.observe { changeset in ... }
    

If you know a bit about RxSwift it’ll be trivial to transform this into an Observable and there’s only one tricky part you’ll have to consider: **the token**. You have to store that token while the observable is alive and invalidate it once the observable is finished. If you get this wrong, you’ll get no changes because notification is dead before you even receive the first change or it will stay alive forever.

In RxSwift they used the **Disposable.create** callback that gets called when your observer gets disposed. That’s perfect: your notification life is attached to your observer.

The problem is that Combine does not work in the same way: you don’t return a Disposable, in fact, when building a Publisher you don’t return anything. There’s not an onDisposed or deinit callback. So... How did I fix it?

Welcome to handleEvents:

    public func handleEvents(receiveSubscription: ((Subscription) -> Void)? = nil, receiveOutput: ((Self.Output) -> Void)? = nil, receiveCompletion: ((Subscribers.Completion<Self.Failure>) -> Void)? = nil, receiveCancel: (() -> Void)? = nil, receiveRequest: ((Subscribers.Demand) -> Void)? = nil) -> Publishers.HandleEvents<Self>
    

Nice, isn’t it? (Generics can melt your brain)

It’s like the do operator on RxSwift. It allows us to execute code when specific events happen. In this case, the events we are interested in are **receiveCompletion** and **receiveCancel**. Those are the 2 cases where we need to invalidate the token so I added the code to my publisher init call:

    .handleEvents(receiveCompletion: { _ in
        token?.invalidate()
    }, receiveCancel: {
        token?.invalidate()
    })
    

But this doesn’t compile. The return type of handleEvents is not AnyPublisher, it’s a completely different type that conforms to Publisher protocol. To get the proper type back we’ve to use **eraseToAnyPublisher()**. Note this method down: if you start using Combine you’ll use it a lot, or at least that was my experience (I hope I’m wrong and there’s a better way to skip it).

    .handleEvents(receiveCompletion: { _ in
        token?.invalidate()
    }, receiveCancel: {
        token?.invalidate()
    })
    .eraseToAnyPublisher()
    

Once I had this solved I started to add new methods to my pod to observe realm, observe a collection, observe a changeset... And I found myself writing the same code again and again, so I extracted it and made it a bit more generic.

    extension Publisher {
        func onDispose(_ onDispose: @escaping () -> Void) -> AnyPublisher<Output, Failure> {
            return self.handleEvents(receiveCompletion: { _ in
                onDispose()
            }, receiveCancel: {
                onDispose()
            }).eraseToAnyPublisher()
        }
    }
    

Now the code was a bit nicer:

    .onDispose {
        token?.invalidate()
    }
    

So far I had found 2 issues adding Combine to my RxSwift project. One a bit specific of the use case, but I’ve found myself using reaseToAnyPublisher() **A LOT**.

## DisposeBag

This problem may be specific to how you use Combine. In this case it´s replacing RxSwift without any UI binding.

First, let me tell you how the UI layer works in my app:

- Presenter calls and subscribes to a Publisher
- With each event, it tells the UI to update with x changes

It’s not exactly the MVVM that seems to fit Combine and SwiftUI better.

With RxSwift this is not a problem because when you subscribe you can add the returned disposable to a dispose bag. This DisposeBag basically attaches the life of your observable to the DisposeBag instance. If the presenter is released, DisposeBag gets released and all your observers get disposed and released. An amazing job from RxSwift developers but... There’s no equivalent in Combine.

In Combine, when you execute sink (equivalent to subscribe) you get back a cancellable and is your responsibility to manage it and remember to call cancel on it when you need to cancel that Publisher.

Now, image the presenter consumes 2 publishers. I have to keep 2 references to the cancellables of those publishers and call cancel on them when my presenter gets released (deinit). If you do the same in all your presenters, It’ll become a mess difficult to keep updated. It’s really easy to forget calling cancel on one of this cancellables and keep an observable alive forever.

So, another issue, another fix. I created [another public repo](https://github.com/bitomule/CombineDisposeBag) with a DisposeBag for Combine. It’s exactly the same behavior you get from RxSwift. You have to create DisposeBag and tell each subscription to get disposed by that DisposeBag you created. It’s really easy to use and makes migrating from RxSwift to Combine a lot easier. Of course, I’ve filled feedback to Apple because It’ll be a lot better if they fixed this kind of rough edges in Combine.

That’s all so far, please feel free to ask me on twitter [@bitomule](https://twitter.com/Bitomule) and create issues or PRs (better) on both repositories [CombineRealm](https://github.com/bitomule/CombineRealm) and [CombineDisposeBag](https://github.com/bitomule/CombineDisposeBag). I’ll keep learning and trying to share what I’ve learned.
