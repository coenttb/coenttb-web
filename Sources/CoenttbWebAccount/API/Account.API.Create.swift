//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 17/10/2024.
//

import Dependencies
import EmailAddress
import Foundation
import Languages
import MemberwiseInit
import URLRouting
import MacroCodableKit
import UrlFormCoding

extension CoenttbWebAccount.API {
    public enum Create: Equatable, Sendable {
        case request(CoenttbWebAccount.API.Create.Request)
        case verify(CoenttbWebAccount.API.Create.Verify)
    }
}

extension CoenttbWebAccount.API.Create {
    @MemberwiseInit(.public)
    @Codable
    public struct Request: Hashable, Sendable {
        @CodingKey(.email)
        @Init(default: "")
        public let email: String
        
        @CodingKey(.password)
        @Init(default: "")
        public let password: String
    }

    @MemberwiseInit(.public)
    @Codable
    public struct Verify: Hashable, Sendable {
        @CodingKey(.token)
        @Init(default: "")
        public let token: String
        
        @CodingKey(.email)
        @Init(default: "")
        public let email: String
    }
}

extension CoenttbWebAccount.API.Create {
    public struct Router: ParserPrinter, Sendable {
        
        public init(){}
        
        public var body: some URLRouting.Router<CoenttbWebAccount.API.Create> {
            OneOf {
                URLRouting.Route(.case(CoenttbWebAccount.API.Create.request)) {
                    Method.post
                    Path { "request" }
                    Body(.form(CoenttbWebAccount.API.Create.Request.self, decoder: .default))
                }
                URLRouting.Route(.case(CoenttbWebAccount.API.Create.verify)) {
                    Method.post
                    Path { "verify" }
                    Parse(.memberwise(CoenttbWebAccount.API.Create.Verify.init)) {
                        Query {
                            Field(CoenttbWebAccount.API.Verify.CodingKeys.token.rawValue, .string)
                            Field(CoenttbWebAccount.API.Verify.CodingKeys.email.rawValue, .string)
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
