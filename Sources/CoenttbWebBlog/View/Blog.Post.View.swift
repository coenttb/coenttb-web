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

extension Blog.Post {
    public struct View: HTML {
        
        let post: Blog.Post
        
        public init(post: Blog.Post) {
            self.post = post
        }
        
        public var body: some HTML {
            div {
                div {
                    AnyHTML(post.image.loading(.lazy))
                        .position(.absolute, top: 0, right: 0, bottom: 0, left: 0)
                }
                .clipPath(.circle(50.percent))
                .position(.relative)
                .size(10.rem)
            }
            .padding(top: .large)
            .flexContainer(
                justification: .center,
                itemAlignment: .center
            )

            if let content = post.content {
                PageModule(theme: .content) {
                    TextArticle {
                        HTMLMarkdown {
                            content
                        }
                    }
                    .width(.percent(100))
                }
            }
        }
    }
}
