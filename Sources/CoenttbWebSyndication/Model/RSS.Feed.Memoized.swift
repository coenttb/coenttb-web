//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 17/12/2024.
//

import Foundation

extension RSS.Feed {
    public actor Memoized {
        private struct CachedFeed {
            let feed: RSS.Feed
            let generatedAt: Date
            
            var isValid: Bool {
                Date().timeIntervalSince(generatedAt) < Self.cacheValidityDuration
            }
            
            static let cacheValidityDuration: TimeInterval = 3600
        }
        
        private var cachedFeed: CachedFeed?
    }
}

extension RSS.Feed {
    public static let memoized = RSS.Feed.Memoized()
}

extension RSS.Feed.Memoized {
    public func getFeed(
        generate: () -> RSS.Feed
    ) -> RSS.Feed {
        if let cached = cachedFeed, cached.isValid {
            return cached.feed
        }
        
        let feed = generate()
        cachedFeed = CachedFeed(feed: feed, generatedAt: Date())
        return feed
    }
}

extension RSS.Feed.Memoized {
    public func callAsFunction(
        generate: () -> RSS.Feed
    ) -> RSS.Feed {
        self.getFeed(generate: generate)
    }
}
