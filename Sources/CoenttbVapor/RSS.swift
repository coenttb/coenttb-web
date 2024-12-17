//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 17/12/2024.
//

import Foundation
@_exported import CoenttbWebSyndication

extension RSS.Feed {
    public struct Response: AsyncResponseEncodable {

        let feed: RSS.Feed
        
        public init(feed: RSS.Feed) {
            self.feed = feed
        }
        
        public func encodeResponse(for request: Vapor.Request) async throws -> Vapor.Response {
            Vapor.Response(
                status: .ok,
                headers: ["Content-Type": "application/rss+xml; charset=utf-8"],
                body: .init(string: XML(feed: feed).description)
            )
        }
    }
}
