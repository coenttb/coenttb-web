//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 19/08/2024.
//

import Foundation
import CoenttbHTML

public struct Blog {
    public var featured: (Blog.Post?, Blog.Post?, Blog.Post?) {
        let featuredPosts = Array(posts.sorted(by: { $0.publishedAt < $1.publishedAt }).prefix(3))
        return (featuredPosts[safe: 0], featuredPosts[safe: 1], featuredPosts[safe: 2])
    }
    public let posts: [Blog.Post]
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
