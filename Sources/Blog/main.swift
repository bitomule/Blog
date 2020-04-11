import Foundation
import Publish
import SplashPublishPlugin
import Plot

// This type acts as the configuration for your website.
struct Blog: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case posts
    }
    
    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }
    
    // Update these properties to configure your website:
    var url = URL(string: "https://blog.bitomule.com")!
    var name = "Bitomule's learning shack"
    var description = "My thoughts about iOS, technology or any other thing that comes to my mind."
    var language: Language { .english }
    var imagePath: Path? { nil }
}

// This will generate your website using the built-in Foundation theme:
try Blog().publish(using: [
    .installPlugin(.splash(withClassPrefix: "splashcode")),
    .generateHTML(withTheme: .foundation),
    .deploy(using: .gitHub("bitomule/Blog", useSSH: true))
])
