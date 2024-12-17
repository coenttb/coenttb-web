//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 17/12/2024.
//

import Foundation
import Date

public struct RSS: Codable, Hashable, Sendable {
    
}

extension RSS {
    public enum Version: String, Codable, Hashable, Sendable {
        case atom
        case rss2_0
    }
}

extension RSS {
    public struct Feed: Codable, Hashable, Sendable {
        let metadata: Metadata
        let items: [Item]
        let version: RSS.Version
        
        public init(
            metadata: Metadata,
            items: [Item],
            version: RSS.Version = .rss2_0
        ) {
            self.metadata = metadata
            self.items = items
            self.version = version
        }
    }
}

extension RSS.Feed {
    public struct Item: Codable, Hashable, Sendable {
        let title: String
        let link: URL
        let image: RSS.Image?
        let creator: String
        let publicationDate: Date
        let description: String
        
        public init(
            title: String,
            link: URL,
            image: RSS.Image?,
            creator: String,
            publicationDate: Date,
            description: String
        ) {
            self.title = title
            self.link = link
            self.image = image
            self.creator = creator
            self.publicationDate = publicationDate
            self.description = description
        }
    }
}

extension RSS {
    public struct Image: Codable, Hashable, Sendable {
        let url: URL
        let variant: Image.Variant
        
        public init(url: URL, variant: Image.Variant) {
            self.url = url
            self.variant = variant
        }
        
        public enum Variant: String, Codable, Hashable, Sendable {
            case jpeg
            case png
            case webp
        }
    }
}
extension RSS.Feed {
    public struct Metadata: Codable, Hashable, Sendable {
        let title: String
        let link: URL
        let description: String
        let language: String
        let imageURL: URL?
        
        public init(
            title: String,
            link: URL,
            description: String,
            language: String = "en-US",
            imageURL: URL? = nil
        ) {
            self.title = title
            self.link = link
            self.description = description
            self.language = language
            self.imageURL = imageURL
        }
    }
}

extension RSS.Feed {
    public struct XML: CustomStringConvertible, Sendable {
        private let feed: RSS.Feed
        
        public init(feed: RSS.Feed) {
            self.feed = feed
            
            func generateItems(
                sortBy: @escaping (RSS.Feed.Item, RSS.Feed.Item) -> Bool = { $0.publicationDate > $1.publicationDate },
                limit: Int = 20
            ) -> String {
                feed.items
                    .sorted(by: sortBy)
                    .prefix(limit)
                    .map(generateItem)
                    .joined(separator: "\n")
            }
            
            func generateItem(_ item: RSS.Feed.Item) -> String {
                """
                <item>
                    <title>\(item.title)</title>
                    <link>\(item.link.absoluteString)</link>
                    <dc:creator><![CDATA[\(item.creator)]]></dc:creator>
                    <pubDate>\(item.publicationDate.formatted(.rfc822))</pubDate>
                    <description><![CDATA[\(item.description)]]></description>
                    \(item.image.map { """
                    <enclosure url="\($0.url.absoluteString)" type="image/\($0.variant)" />
                    """ } ?? "")
                </item>
                """
            }
            
            self.description =
            """
            <?xml version="1.0" encoding="UTF-8"?>
            <rss version="2.0" xmlns:content="http://purl.org/rss/1.0/modules/content/" xmlns:dc="http://purl.org/dc/elements/1.1/">
                <channel>
                    <title>\(feed.metadata.title)</title>
                    <link>\(feed.metadata.link.absoluteString)</link>
                    <description>\(feed.metadata.description)</description>
                    <language>\(feed.metadata.language)</language>
                    <lastBuildDate>\(Date().formatted(.rfc822))</lastBuildDate>
                    \(feed.metadata.imageURL.map { imageURL in
                    """
                    <image>
                        <url>\(imageURL.absoluteString)</url>
                        <title>\(feed.metadata.title)</title>
                        <link>\(feed.metadata.link.absoluteString)</link>
                    </image>
                    """
                    } ?? "")
                    \(generateItems())
                </channel>
            </rss>
            """
            
        }
        
        public let description: String
        
        
    }
}

