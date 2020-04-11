---
date: 2016-04-3 16:35
tags:  iOS
excerpt: Calculating size of texts is one of the most common questions when you start working on iOS. Soon you need to calculate the size of some UI element and frequently that includes text. I explored some of the ways to do it and here I give some insights from that exploration.
---
# Getting text size on iOS

I'm currently working on an iPhone app that uses a 3rd party chat software and adding some custom message types to it requires that collection cell height is precalculated. I don't remember all the iOS APIs on my head but a quick search on google just showed a UIFont extension that calculates a text box (UILabel or TextView) size.  It was something like:

	extension UIFont {
	func sizeOfString (string: String, constrainedToWidth width: Double) -> CGSize {
	return NSString(string: string).boundingRectWithSize(CGSize(width: width, height: DBL_MAX),
	options: NSStringDrawingOptions.UsesLineFragmentOrigin,
	attributes: [NSFontAttributeName: self],
	context: nil).size
	}
	}

It was easy and fast. I also needed it in another place to get width with a defined height so I changed it to allow it and done! Just using a font reference I can get the size of a text box. I added some tests just to be sure that it returns the same size I get in interface builder for my view (including margins and other views) and it worked perfect.

I continued developing other parts of the app but after a few days I saw a weird bug, one of us sent a message with a whole line composed only from emoji characters and then height calculation failed, that whole line was removed from view, my quick and easy method to calculate height was ignoring emoji. WTF!!

Back to google, searching for a bug report or something that could tell me why something so simple didn't work with emoji. I found some posts asking the same and one pointing on a direction I already know, using UILabel sizeToFit method. Ok, creating a UILabel each time I need a cell height isn't perfect but this collection view caches heights so it's something I can live with. Changed my method to use sizeToFit instead of boundingRectWithSize and... FAIL

Using sizeToFit returned the same size as boundingRectWithSize, I can't believe that both methods ignored emoji. That was a moment to stop and think: "there should be a way to do this but maybe not so easy". That made me start searching not so easy ways of getting text size in iOS. My first search was related to CoreText and I got a result that pointed me in the right direction: CTFramesetter

It was something I've never used but the only option I had so I went to official API docs and changed again my extension method to use it. The result? It worked!!

I'm not sure how fast it is but fixed the big issue I had. If you find the same issue hope you find this post and can just copy paste this code to your app:

	func sizeOfString (string: String, constrainedToWidth width: Double) -> CGSize {
	let attributes = [NSFontAttributeName:self,]
	let attString = NSAttributedString(string: string,attributes: attributes)
	let framesetter = CTFramesetterCreateWithAttributedString(attString)
	return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0,length: 0), nil, CGSize(width: width, height: DBL_MAX), nil)
	}
