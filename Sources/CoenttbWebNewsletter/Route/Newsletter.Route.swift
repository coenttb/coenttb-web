//
//  File.swift
//  tenthijeboonkkamp-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 05/09/2024.
//


import Dependencies
import Foundation
import Languages
import URLRouting

public enum Route: Codable, Hashable, Sendable {
    case subscribe
    case unsubscribe
}

extension Route {
    public enum Subscribe {}
}

extension Route {
    public enum Unsubscribe {}
}

extension CoenttbWebNewsletter.Route {
    public struct Router: ParserPrinter {
        
        public init(){}
        
        public var body: some URLRouting.Router<CoenttbWebNewsletter.Route> {
            OneOf {
                URLRouting.Route(.case(CoenttbWebNewsletter.Route.subscribe)) {
                    Path { String.subscribe.description }
                }
                
                URLRouting.Route(.case(CoenttbWebNewsletter.Route.unsubscribe)) {
                    Path { String.unsubscribe.description }
                }
            }
        }
    }
}


