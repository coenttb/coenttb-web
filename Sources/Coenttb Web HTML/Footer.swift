import Dependencies
import Foundation
import CoenttbHTML

public struct Footer<
    TaglineContent: HTML,
    CopyrightSection: HTML
>: HTML {
    
    let tagline: Tagline
    let copyrightSection: CopyrightSection
    let columns: [(title: String, links: [(label: String, href: Href)])]
    
    public init(
        tagline: Tagline,
        copyrightSection: CopyrightSection,
        columns: [(title: String, links: [(label: String, href: Href)])]
    ) {
        self.tagline = tagline
        self.copyrightSection = copyrightSection
        self.columns = columns
    }
    
    private var columnsGrid: [Int] {
        switch columns.count {
        case 1: [1]
        case 2: [1, 2]
        case 3: [1, 1, 1]
        case 4: [1, 2]
        default: [1, 1, 1]
        }
    }
    
    public var body: some HTML {
        footer {
            LazyVGrid(columns: [
                .desktop: [1, 1]
            ]) {
                
                div {
                    h4 {
                        Link(tagline.title, href: tagline.href)
                            .color(.text.primary)
                    }
//                    .fontScale(.h4)
                    .margin(bottom: 0, media: .mobile)
                    .fontSize(.rem(1.25))
                    .fontSize(.rem(1.5), media: .desktop)
                    .lineHeight(1.45)
                    
                    tagline.content
                        .color(.text.primary)
                        .font(.body(.regular))
                }
                .padding(right: .rem(4), media: .desktop)
                .padding(bottom: .rem(2), media: .mobile)
                
                LazyVGrid(columns: columnsGrid) {
                    HTMLForEach(self.columns) { column in
                        div {
                            h5 { HTMLText(column.title) }
                                .color(.text.primary)
                                .fontSize(.rem(0.75))
                                .fontSize(.rem(0.875), media: .desktop)
                                .inlineStyle("letter-spacing", "0.54pt")
                                .lineHeight(1.25)
                                .inlineStyle("text-transform", "uppercase")
                            
                            ol {
                                HTMLForEach(column.links) { link in
                                    li {
                                        Link(href: link.href) {
                                            HTMLText(link.label)
                                        }
                                        .linkColor(.text.primary)
                                    }
                                }
                                
                            }
                            .listStyle(.reset)
                        }
                    }
                }
                
                copyrightSection
            }
            .alignItems(.firstBaseline)
        }
        .backgroundColor(.background.primary)
        .padding(.rem(2), media: .mobile)
        .padding(.rem(4), media: .desktop)
    }
}

public struct AllRightsReserved: HTML {
    let copyrightHolder: (name: String, color: HTMLColor?)
    
    public var body: some HTML {
        p {
            let year = Calendar(identifier: .gregorian).component(
                .year, from: Date.now)
                """
                © \(year)\(" " + copyrightHolder.name). \(String.all_rights_reserved.capitalizingFirstLetter()).
                """
            
        }
        .color(copyrightHolder.color ?? .white.withDarkColor(.black))
        .font(.body(.small))
        .padding(top: .rem(2), media: .mobile)
    }
}


extension Footer {
    public struct Tagline {
        let title: String
        let href: Href
        let content: TaglineContent
        
        public init(
            title: String,
            href: Href,
            content: TaglineContent
        ) {
            self.title = title
            self.href = href
            self.content = content
        }
    }
    
    public struct Links {
        let content: [(label: String, href: Href)]
        let more: [(label: String, href: Href)]
        
        public init(
            content: [(label: String, href: Href)],
            more: [(label: String, href: Href)]
        ) {
            self.content = content
            self.more = more
        }
    }
}

#if canImport(SwiftUI)
import SwiftUI

@MainActor let footer2: some HTML = Footer.init(
    tagline: .init(
        title: "Coenttb",
        href: "/",
        content: p {
            "A blog exploring business code using the Swift programming language. Hosted by Coen ten Thije Boonkkamp."
        }
    ),
    copyrightSection: AllRightsReserved(
        copyrightHolder: (
            name: "Coen ten Thije Boonkkamp",
            color: nil
        )
    ),
    columns: [
        (
            title: "Content",
            links: [
                (label: "Pricing", href: "/"),
                (label: "Gifts", href: "/"),
                (label: "Services", href: "/"),
                (label: "Blog", href: "/"),
            ]
        ),
        (
            title: "More",
            links: [
                (label: "About us", href: "/"),
                (label: "Twitter", href: "/"),
                (label: "Github", href: "/"),
                (label: "Contact us", href: "/"),
                (label: "Privacy statement", href: "/"),
                (label: "General terms and conditions", href: "/"),
                (label: "User terms", href: "/"),
            ]
        )
    ]
    
)

#Preview {
    HTMLDocument.modern {
        footer2
    }
    
}

#endif
