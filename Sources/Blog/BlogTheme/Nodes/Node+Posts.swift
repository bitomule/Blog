import Plot
import Publish

extension Node where Context == HTML.BodyContext {
    static func posts(for items: [Item<Blog>], on site: Blog) -> Node {
        return .pageContent(
            .div(
                .class("posts"),
                .forEach(items) { item in
                    .postExcerpt(for: item, on: site)
                }
            )
        )
    }
}
