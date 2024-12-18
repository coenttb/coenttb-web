//
//  File.swift
//  tenthijeboonkkamp-nl-server
//
//  Subscribed by Coen ten Thije Boonkkamp on 10/09/2024.
//


import Dependencies
import EmailAddress
import Foundation
import Languages
import MemberwiseInit
import URLRouting
import MacroCodableKit
import UrlFormCoding

public enum API: Equatable, Sendable {
    case subscribe(CoenttbWebNewsletter.API.Subscribe)
    case unsubscribe(CoenttbWebNewsletter.API.Unsubscribe)
}

extension CoenttbWebNewsletter.API {
    public struct Router: ParserPrinter, Sendable {
        
        public init(){}
        
        public var body: some URLRouting.Router<CoenttbWebNewsletter.API> {
            OneOf {
                URLRouting.Route(.case(CoenttbWebNewsletter.API.subscribe)) {
                    Path { "subscribe" }
                    CoenttbWebNewsletter.API.Subscribe.Router()
                }
                
                URLRouting.Route(.case(CoenttbWebNewsletter.API.unsubscribe)) {
                    Method.get
                    Path { "unsubscribe" }
                    Body(.form(CoenttbWebNewsletter.API.Unsubscribe.self, decoder: .default))
                }
            }
        }
    }
}

extension CoenttbWebNewsletter.API {
    @MemberwiseInit(.public)
    @Codable
    public struct Unsubscribe: Hashable, Sendable {
       @CodingKey("email")
        @Init(default: "")
        public let value: String
    }
}

extension CoenttbWebNewsletter.API {
    public enum Subscribe: Equatable, Sendable {
        case request(CoenttbWebNewsletter.API.Subscribe.Request)
        case verify(CoenttbWebNewsletter.API.Subscribe.Verify)
    }
}

extension CoenttbWebNewsletter.API.Subscribe {
    @MemberwiseInit(.public)
    @Codable
    public struct Request: Hashable, Sendable {
        @CodingKey("email")
        @Init(default: "")
        public let email: String
    }

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

extension CoenttbWebNewsletter.API.Subscribe {
    public struct Router: ParserPrinter, Sendable {
        
        public init(){}
        
        public var body: some URLRouting.Router<CoenttbWebNewsletter.API.Subscribe> {
            OneOf {
                URLRouting.Route(.case(CoenttbWebNewsletter.API.Subscribe.request)) {
                    Method.post
                    Path { "request" }
                    Body(.form(CoenttbWebNewsletter.API.Subscribe.Request.self, decoder: .default))
                }
                URLRouting.Route(.case(CoenttbWebNewsletter.API.Subscribe.verify)) {
                    Method.post
                    Path { "verify" }
                    Parse(.memberwise(CoenttbWebNewsletter.API.Subscribe.Verify.init)) {
                        Query {
                            Field(CoenttbWebNewsletter.API.Subscribe.Verify.CodingKeys.token.rawValue, .string)
                            Field(CoenttbWebNewsletter.API.Subscribe.Verify.CodingKeys.email.rawValue, .string)
                        }
                    }
                }
            }

        }
    }
}

extension UrlFormDecoder {
    fileprivate static var `default`: UrlFormDecoder {
        let decoder = UrlFormDecoder()
        decoder.parsingStrategy = .bracketsWithIndices
        return decoder
    }
}
