//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 06/07/2023.
//


import Dependencies
import Foundation
import Languages
import URLRouting
@preconcurrency import Either

public enum Route: Codable, Hashable, Sendable {
    case index
    case post(Either<String, Int>)
}

extension Either: @retroactive Hashable where L: Hashable, R: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .left(let l):
            hasher.combine(0)
            hasher.combine(l)
        case .right(let r):
            hasher.combine(1)
            hasher.combine(r)
        }
    }
}


extension Route {
    public static func post(slug: String) -> Route { .post(.left(slug)) }
    public static func post(_ slug: String) -> Route { .post(.left(slug)) }
    public static func post(id: Int) -> Route { .post(.right(id)) }
    public static func post(_ id: Int) -> Route { .post(.right(id)) }
    public static func post(_ post: Blog.Post) -> Route { .post(slug: post.slug) }
}

extension CoenttbWebBlog.Route {
    public struct Router: ParserPrinter {
        
        public init(){}
        
        public var body: some URLRouting.Router<CoenttbWebBlog.Route> {
            OneOf {
                
                URLRouting.Route(.case(CoenttbWebBlog.Route.post)) {
                    Path {
                        OneOf {
                            Parse {
                                Digits()
                                    .map(.case(Either<String, Int>.right))
                                End()
                            }
                            Parse(.string.map(.case(Either<String, Int>.left)))
                        }
                    }
                }

                URLRouting.Route(.case(CoenttbWebBlog.Route.index))
            }
        }
    }
}
