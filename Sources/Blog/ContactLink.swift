import Foundation

struct ContactLink {
    let title: String
    let url: String
    let icon: String
}

extension ContactLink {
    static var linkedIn: ContactLink {
        return ContactLink(
            title: "LinkedIn",
            url: "https://www.linkedin.com/in/davidcolladosela/",
            icon: "fab fa-linkedin"
        )
    }
    
    static var email: ContactLink {
        return ContactLink(
            title: "Email",
            url: "mailto:bitomule+blog@gmail.com",
            icon: "fas fa-envelope-open-text"
        )
    }
    
    static var github: ContactLink {
        return ContactLink(
            title: "GitHub",
            url: "https://github.com/bitomule",
            icon: "fab fa-github-square"
        )
    }
    
    static var twitter: ContactLink {
        return ContactLink(
            title: "Twitter",
            url: "https://twitter.com/Bitomule",
            icon: "fab fa-twitter-square"
        )
    }
}
