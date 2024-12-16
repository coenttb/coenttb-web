//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 19/08/2024.
//

import CoenttbMarkdown
import CoenttbWebHTML
import Date
import Dependencies
import Foundation
import Languages
import CoenttbWebTranslations

extension Blog {
    public struct FeaturedModule: HTML {

        let posts: [Blog.Post]
        let seeAllURL: URL
        
        public init(
            posts: [Blog.Post],
            seeAllURL: URL
        ) {
            self.posts = posts
            self.seeAllURL = seeAllURL
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
//                title: .all_posts.capitalizingFirstLetter().description,
//                seeAllURL: serverRouter.href(for: .blog(.index)),
                theme: .content
            ) {
                VStack {
                    LazyVGrid(
                        columns: [.desktop: columns],
                        horizontalSpacing: 1.rem,
                        verticalSpacing: 1.rem
                    ) {

                        for post in posts.suffix(3).reversed() {
                            Blog.Post.Card(post)
                                .maxWidth(24.rem, media: .desktop)
                                .margin(top: 1.rem, right: 0, bottom: 2.rem, left: 0)
                        }
                    }
                }
            } title: {
                PageModuleSeeAllTitle(title: String.all_posts.capitalizingFirstLetter().description, seeAllURL: seeAllURL.absoluteString)
                    .padding(bottom: 2.rem)
            }
        }
    }
}


#if canImport(SwiftUI)

import SwiftUI


#Preview {

    let posts: [Blog.Post] = {
        @Dependency(\.blog) var blogClient
        return blogClient.getAll()
    }()
        
    let card: some HTML = Blog.FeaturedModule(posts: posts, seeAllURL: .applicationDirectory)
    
    HTMLPreview.modern {
        card
    }
}

#endif
