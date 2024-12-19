//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 16/12/2024.
//

import Vapor
import CoenttbWebNewsletter
import CoenttbWebHTML
import CoenttbHTML
import Dependencies
import Foundation
import Languages

extension CoenttbWebBlog.Route {
    public static func response(
        route: CoenttbWebBlog.Route,
        blurb: TranslatedString,
        companyXComHandle: String?,
        getCurrentUser: () -> (newsletterSubscribed: Bool, accessToBlog: Bool)?,
        coenttbWebNewsletter: (() -> CoenttbWebNewsletter.Route.Subscribe.Overlay)?,
        defaultDocument: @escaping (() -> any HTML) -> any AsyncResponseEncodable,
        posts: [Blog.Post]
    ) async throws -> any AsyncResponseEncodable {
        switch route {
        case .index:
            
            let header = {
                PageHeader(
                    title: .blog.capitalizingFirstLetter().description,
                    blurb: {
                        blurb
                    }
                ) {
                    HTMLGroup {
                        HTMLText(String.curious_what_is_next.description.capitalizingFirstLetter().questionmark.description)
                        
                        if let companyXComHandle {
                            Link(String.follow_me_on_Twitter.capitalizingFirstLetter().period.description, href: "https://x.com/\(companyXComHandle)")
                                .linkUnderline(true)
                        }
                    }
                    .color(.gray300.withDarkColor(.gray800))
                }
            }

            switch posts.count {
            case 0:
                return defaultDocument {
                    header()
                }
            case 1:
                return try await response(
                    route: .post(.left(posts[0].slug)),
                    blurb: blurb,
                    companyXComHandle: companyXComHandle,
                    getCurrentUser: getCurrentUser,
                    coenttbWebNewsletter: coenttbWebNewsletter,
                    defaultDocument: defaultDocument,
                    posts: posts
                )
            default:
                return defaultDocument {
                    HTMLGroup {
                        header()
                        
                        CoenttbWebBlog.Blog.AllPostsModule(
                            posts: posts
                        )
                    }
                }
            }

        case .post(let identifier):
            
            let currentUser = getCurrentUser()

            guard let post = posts.lazy.first(where: {
                switch identifier {
                case .left(let string):
                    $0.slug == string
                case .right(let int):
                    $0.index == int
                }
            }) else {
                return try await response(
                    route: .index,
                    blurb: blurb,
                    companyXComHandle: companyXComHandle,
                    getCurrentUser: getCurrentUser,
                    coenttbWebNewsletter: coenttbWebNewsletter,
                    defaultDocument: defaultDocument,
                    posts: posts
                )
            }

            guard !(post.permission == .subscriberOnly && currentUser?.accessToBlog != true)
            else {
                return defaultDocument {
                    Header(1) {
                        TranslatedString(
                            dutch: "Alleen voor subscribers",
                            english: "Subscriber only"
                        )
                    }
                }
            }

            return defaultDocument {
                HTMLGroup {
                    Blog.Post.View(post: post)

                    if let coenttbWebNewsletter {
                        coenttbWebNewsletter()
                    }
                }
            }
        }
    }
}
