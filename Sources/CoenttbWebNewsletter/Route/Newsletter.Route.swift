//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 05/09/2024.
//


import Dependencies
import Foundation
import Languages
import URLRouting
import MemberwiseInit
import MacroCodableKit

public enum Route: Codable, Hashable, Sendable {
    case subscribe(CoenttbWebNewsletter.Route.Subscribe)
    case unsubscribe
}


extension CoenttbWebNewsletter.Route {
    public enum Subscribe: Codable, Hashable, Sendable {
        case request
        case verify(CoenttbWebNewsletter.Route.Subscribe.Verify)
    }
}

extension CoenttbWebNewsletter.Route.Subscribe {
    @MemberwiseInit(.public)
    @Codable
    public struct Verify: Hashable, Sendable {
       @CodingKey("token")
        @Init(default: "")
        public let token: String
        
       @CodingKey("email")
        @Init(default: "")
        public let email: String
    }
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
                    Path { "subscribe" }
                    OneOf {
                        URLRouting.Route(.case(CoenttbWebNewsletter.Route.Subscribe.request)) {
                            Path { "request" }
                        }
                        
                        URLRouting.Route(.case(CoenttbWebNewsletter.Route.Subscribe.verify)) {
                            Path { "email-verification" }
                            Parse(.memberwise(CoenttbWebNewsletter.Route.Subscribe.Verify.init)) {
                                Query {
                                    Field(CoenttbWebNewsletter.Route.Subscribe.Verify.CodingKeys.token.rawValue, .string)
                                    Field(CoenttbWebNewsletter.Route.Subscribe.Verify.CodingKeys.email.rawValue, .string)
                                }
                            }
                        }
                    }
                }
                
                URLRouting.Route(.case(CoenttbWebNewsletter.Route.unsubscribe)) {
                    Path { String.unsubscribe.description }
                }
            }
        }
    }
}


