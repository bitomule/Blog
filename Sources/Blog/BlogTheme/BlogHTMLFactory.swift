import Publish
import Plot

struct BlogHTMLFactory: HTMLFactory {
    func makeIndexHTML(for index: Index, context: PublishingContext<Blog>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: context.site),
            .body(
                .grid(
                    .sidebar(for: context.site),
                    .posts(
                        for: context.allItems(
                            sortedBy: \.date,
                            order: .descending
                        ),
                        on: context.site
                    ),
                    .footer(for: context.site)
                )
            )
        )
    }
    
    func makeSectionHTML(for section: Section<Blog>, context: PublishingContext<Blog>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: context.site),
            .body(
                .grid(
                    .sidebar(for: context.site),
                    .pageContent(.h1(.text(section.title))),
                    .footer(for: context.site)
                )
            )
        )
    }
    
    func makeItemHTML(for item: Item<Blog>, context: PublishingContext<Blog>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .itemHead(for: context.site, itemTitle: item.title),
            .body(
                .grid(
                    .sidebar(for: context.site),
                    .post(for: item, on: context.site),
                    .footer(for: context.site)
                )
                
            )
        )
    }
    
    func makePageHTML(for page: Page, context: PublishingContext<Blog>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: context.site),
            .body(
                .grid(
                    .sidebar(for: context.site),
                    .page(for: page, on: context.site),
                    .footer(for: context.site)
                )
            )
        )
    }
    
    func makeTagListHTML(for page: TagListPage, context: PublishingContext<Blog>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: context.site),
            .body(
                .grid(
                    .sidebar(for: context.site),
                    .pageContent(
                        .tagList(for: page, on: context.site)
                    ),
                    .footer(for: context.site)
                )
            )
        )
    }
    
    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<Blog>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: context.site),
            .body(
                .grid(
                    .sidebar(for: context.site),
                    .posts(
                        for: context.items(
                            taggedWith: page.tag,
                            sortedBy: \.date,
                            order: .descending
                        ),
                        on: context.site
                    ),
                    .footer(for: context.site)
                )
            )
        )
    }
}
