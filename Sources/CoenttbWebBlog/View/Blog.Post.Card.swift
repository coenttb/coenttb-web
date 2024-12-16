//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 10/12/2024.
//

import CoenttbMarkdown
import CoenttbWebHTML
import Date
import Dependencies
import Foundation
import Languages

extension Blog.Post {
    public struct Card: HTML {
        @Dependency(\.date.now) var now
        @Dependency(\.language) var language
        @Dependency(\.blog) var blogClient
        
        let post: Blog.Post
        
        var href: URL? {
            blogClient.postToRoute(post)
        }
        
        
        public init(
            _ post: Blog.Post
        ) {
            self.post = post
        }
        
        public var body: some HTML {
            CoenttbWebHTML.Card {
                VStack {
                    
                    VStack(spacing: 0.5.rem) {
                        div {
                            "Blog \(post.index)"
                        }
                        .color(.tertiary)
                        .fontStyle(.body(.small))
                        
                        div {
                            Header(4) {
                                Link(href: href?.absoluteString) {
                                    HTMLText(post.title)
                                    if let subtitle = post.subtitle {
                                        ":"
                                        br()
                                        HTMLText(subtitle)
                                    }
                                }
                                .linkColor(.primary)
                            }
                        }
                    }
                    
                    HTMLMarkdown(post.blurb)
                        .color(.primary)
                        .linkStyle(
                            LinkStyle(
                                color: .gray400.withDarkColor(.gray650), underline: true))
                }
            }
            header: {
                Link(href: href?.absoluteString) {
                    div {
                        div {
                            AnyHTML(post.image)
                                .width(100.percent)
                                .height(100.percent)
                                .objectFit(.cover)
                        }
                        .position(.absolute, top: 0, left: 0)
                        .size(width: 100.percent, height: 100.percent)
                    }
                    .position(.relative)
                    .size(width: 100.percent, height: .px(300))
                    .overflow(.hidden)
                }
            }
            footer: {
                Blog.Post.Card.Footer {
                    switch post.permission {
                    case .free:
                        Label(fa: "lock-open") {
                            String.free
                        }
                    case .subscriberOnly:
                        Label(fa: "lock") {
                            String.subscriber_only
                            
                        }
                    }
                    
                    Label(fa: "clock") {
                        TranslatedString(self.post.estimatedTimeToComplete)
                        
                    }
                }
                .fontSize(.secondary)
            }
            .backgroundColor(.cardBackground)
        }
    }
}

extension Blog.Post.Card {
    private struct Footer<Content: HTML>: HTML {
        @HTMLBuilder let content: Content
        var body: some HTML {
            HStack(alignment: .center) {
                content
            }
            .color(.gray650.withDarkColor(.gray400))
            .linkColor(.gray650.withDarkColor(.gray400))
        }
    }
}




extension Blog.Post {
    static let preview: Self = .init(
        id: .init(),
        index: 1,
        publishedAt: .init(timeIntervalSince1970: 1_523_872_623),
        image: HTMLEmpty(),
        title: "Mock Blog post",
        hidden: .no,
        blurb: """
        This is the blurb to a mock blog post. This should just be short and to the point, using \
        only plain text, no markdown.
        """,
        estimatedTimeToComplete: 10.minutes,
        permission: .free
    )
}

#if canImport(SwiftUI)
import SwiftUI

@MainActor let card: some HTML = Blog.Post.Card(.preview)

#Preview {
    HTMLPreview.modern {
        card
    }
}

#endif
