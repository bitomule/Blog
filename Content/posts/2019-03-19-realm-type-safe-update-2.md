---
date: 2019-03-19 16:23
excerpt: A few days ago, at work, my colleague [@amartinezmes](https://twitter.com/amartinezmes) informed me about an issue we were about to solve. He had to update a Realm object property as easy and as fast as possible because that process will happen tons of times. To do it he was about to use Realm Key-value coding and also the partial update option.
---
# Realm Type-Safe update

A few days ago, at work, my colleague [@amartinezmes](https://twitter.com/amartinezmes) informed me about an issue we were about to solve. He had to update a Realm object property as easy and as fast as possible because that process will happen tons of times. To do it he was about to use Realm Key-value coding and also the partial update option. The first approach was something like this:

    func update(id: Any, keyToUpdate: String, value: Any) {
        guard let idKey = OrderDataModel.primaryKey() else { return }
        let realm = try! Realm()
        try! realm.write {
            realm.create(OrderDataModel.self, value: [idKey: id, keyToUpdate: value], update: true)
        }
    }
    

Of course, we don't create Realm there and we use a generic data model but it's ok as an example.

This was fine, at least it was fast, but not good, it was 0 type safe and there's where the pair programming morning started. We had a lot of complexities to fight against due to generics, protocols, type erasure that we already have and require in our codebase that I'll ignore for this post.

Let's see what issues we can have with this approach:

- Id value could not match the data model id type
- keyToUpdate could be wrong, is just a String
- value can be of an unexpected type for that property. We can use a String for a boolean property and it'll crash on runtime

Here's when the magic of Keypath came into action. I had read a post about keypaths some time ago but had never used them and this felt like the perfect chance.

We were sure we could change this:

    func update(id: Any, keyToUpdate: String, value: Any)
    

into this:

    func update<T:Any>(id: Any, keyToUpdate: KeyPath<OrderDataModel, T>, value: T)
    

That will make the function almost 100% type-safe (let's ignore the id). Using this function won't allow us to use an invalid property and the value should always match the type from keypath so there can't be a type mismatch between both.

![Magic gif](https://media.giphy.com/media/NmerZ36iBkmKk/giphy.gif)

Now... there´s a small problem, Realm does not support keypaths, it requires a String and Keypaths doesn't have a way to be mapped into Strings.

We spend a bit more time finding the right solution to this and the best approach we could find was this:

1. 
Create a protocol to represent DataModels that could provide a String from a key path

    protocol KeypathStringConvertible {
        static func stringValue(keyPath: AnyKeyPath) -> String
    }
    

2. 
Give it a default implementation

    extension KeypathStringConvertible {
        static public func stringValue(keyPath: AnyKeyPath) -> String {
            fatalError("stringValue has not been implemented")
        }
    }
    

3. 
Extend PartialKeyPath to support stringValue when Root type matches the protocol

    extension PartialKeyPath where Root: KeypathStringConvertible {
        var stringValue: String {
            return Root.stringValue(keyPath: self)
        }
    }
    

4. 
Make our data models implement the protocol

    extension OrderDataModel: KeypathStringConvertible {
        static func stringValue(keyPath: AnyKeyPath) -> String {
            switch keyPath {
            case \OrderDataModel.completed:
                return "completed"
            default:
                fatalError("Unexpected keyPath")
            }
        }
    }
    

This is the weakest part, the one where we still have much to improve because it's manual and far from type-safe, any typo here will crash on runtime. We plan to fix this in the next step but at least is better to have string property names next to properties.

Now we can go back to our update function and make the magic happen:

    func update<T:Any>(id: Any, keyToUpdate: KeyPath<OrderDataModel, T>, value: T) {
        guard let idKey = OrderDataModel.primaryKey() else { return }
        let realm = try! Realm()
        try! realm.write {
            realm.create(OrderDataModel.self, value: [idKey: id, keyToUpdate.stringValue: value], update: true)
        }
    }
    

Now our update function is type safe. Of course, this was only the first iteration, now we can expand Keypath to queries and fix that weak strings we´ve moved closer to the type definition.
