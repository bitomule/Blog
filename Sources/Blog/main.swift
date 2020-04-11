import Foundation
import Publish
import SplashPublishPlugin
import Plot
import CNAMEPublishPlugin

// This type acts as the configuration for your website.
struct Blog: Website {
    enum SectionID: String, WebsiteSectionID {
        case posts
        case about
    }
    
    struct ItemMetadata: WebsiteItemMetadata {
        var excerpt: String
    }
    
    // Update these properties to configure your website:
    var url = URL(string: "https://testblog.bitomule.com")!
    var name = "Bitomule's learning shack"
    var description = "My thoughts about iOS, technology or any other thing that comes to my mind."
    var language: Language { .english }
    var imagePath: Path? { nil }
    var socialMediaLinks: [ContactLink] { [.email, .linkedIn, .github, .twitter] }
}

// This will generate your website using the built-in Foundation theme:

try Blog().publish(
    withTheme: .blog,
//    deployedUsing: .gitHub("bitomule/Blog", useSSH: true),
    plugins: [
        .splash(withClassPrefix: ""),
        .generateCNAME(with: ["blog.bitomule.com","www.blog.bitomule.com"])
    ]
)
