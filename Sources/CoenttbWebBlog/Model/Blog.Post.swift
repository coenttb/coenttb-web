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

extension Blog {
    public struct Post: @unchecked Sendable {
        public let id: UUID
        public let index: Int
        public var publishedAt: Date
        public var image: any HTML
        public var title: String
        public var hidden: Hidden
        public var subtitle: String?
        public var alternateSlug: String?
        public var blurb: String
        public var estimatedTimeToComplete: DateComponents
        public var permission: Permission
        
        
        public init(
            id: UUID,
            index: Int,
            publishedAt: Date,
            image: any HTML,
            title: String,
            hidden: Blog.Post.Hidden,
            subtitle: String? = nil,
            alternateSlug: String? = nil,
            blurb: String,
            estimatedTimeToComplete: DateComponents,
            permission: Permission
        ) {
            self.id = id
            self.index = index
            self.publishedAt = publishedAt
            self.image = image
            self.title = title
            self.hidden = hidden
            self.subtitle = subtitle
            self.alternateSlug = alternateSlug
            self.blurb = blurb
            self.estimatedTimeToComplete = estimatedTimeToComplete
            self.permission = permission
        }
    }
}

extension Blog.Post {
    public var slug: String {
        let sanitizedTitle = self.title
            .lowercased()
            .replacingOccurrences(of: #"[^a-z0-9]+"#, with: "-", options: .regularExpression)
            .trimmingCharacters(in: CharacterSet(charactersIn: "-"))
            .replacingOccurrences(of: "-{2,}", with: "-", options: .regularExpression)

        return "\(self.index)-\(sanitizedTitle)"
    }
}

extension Blog.Post {
    public enum Hidden: Equatable {
        case no
        case preview
        case noUntil(Date)
        case yes
        public func isCurrentlyHidden(date currentDate: Date) -> Bool {
            switch self {
            case .no:
                false
            case let .noUntil(date):
                currentDate >= date
            case .yes:
                true
            case .preview:
                true
            }
        }
    }
}

extension Blog.Post {
    public var content: String? {
        @Dependency(\.blog) var blogClient
        @Dependency(\.language) var language

        let baseNames = [
            "Blog-\(index)",
            "Blog-\(index)-en"
        ]

        let previewBaseNames = [
            "Preview-Blog-\(index)",
            "Preview-Blog-\(index)-en"
        ]

        let fileNames = (self.hidden == .preview ? previewBaseNames : baseNames)
            .flatMap {
                [
                    $0 + "-\(language.rawValue)",
                    $0
                ]
            }

        return fileNames
            .lazy
            .compactMap { fileName in
                blogClient.filenameToResourceUrl(fileName)
                    .flatMap { try? Data(contentsOf: $0) }
                    .flatMap { String(data: $0, encoding: .utf8) }
            }
            .first
    }
}

extension Blog.Post {
    public enum Permission: Equatable {
      case free
//      case freeDuring(Range<Date>)
      case subscriberOnly
    }
}



