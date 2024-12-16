//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 13/12/2024.
//

import CoenttbMarkdown
import CoenttbWebHTML
import Date
import Dependencies
import Foundation
import Languages

extension Blog {
    public struct AllPostsModule: HTML {

        let posts: [Blog.Post]
        
        public init(posts: [Blog.Post]) {
            self.posts = posts
        }
        
        var columns: [Int] {
            switch posts.count {
            case ...1: [1]
            case 2: [1, 1]
            default: [1, 1, 1]
            }
        }
        
        @Dependency(\.language) var language

        public var body: some HTML {
            PageModule(
                theme: .content
            ) {
                VStack {
                    LazyVGrid(
                        columns: [.desktop: columns],
                        horizontalSpacing: 1.rem,
                        verticalSpacing: 1.rem
                    ) {
                        for post in posts {
                            Blog.Post.Card(post)
                                .maxWidth(24.rem, media: .desktop)
                                .margin(top: 1.rem, right: 0, bottom: 2.rem, left: 0)
                        }
                    }
                }
            } title: {
                PageModuleTitle(title: String.all_posts.capitalizingFirstLetter().description)
                    .padding(bottom: 2.rem)
            }
        }
    }
}


public struct PageModuleTitle<Title: HTML>: HTML {

    let title: Title

    public init(
        @HTMLBuilder title: () -> Title
    ) {
        self.title = title()
    }

    public init(title: String) where Title == Header<HTMLText> {
        self.title = Header(3) { HTMLText(title) }
    }

    public var body: some HTML {
        div {
            title
        }
        .width(100.percent)
        .flexContainer(
            direction: .row,
            wrap: .nowrap,
            justification: .center,
            itemAlignment: .center
        )
        .flexItem(basis: .length(100.percent))
    }
}
