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
    public enum EmailChange: Equatable, Sendable {
        case reauthorization(CoenttbWebAccount.API.EmailChange.Reauthorization)
        case request(CoenttbWebAccount.API.EmailChange.Request)
        case confirm(CoenttbWebAccount.API.EmailChange.Confirm)
    }
}

extension CoenttbWebAccount.API.EmailChange {
    @MemberwiseInit(.public)
    @Codable
    public struct Reauthorization: Hashable, Sendable {
        @CodingKey(.password)
        @Init(default: "")
        public let password: String
    }
    
    @MemberwiseInit(.public)
    @Codable
    public struct Request: Hashable, Sendable {
        @CodingKey(.newEmail)
        @Init(default: "")
        public let newEmail: String
    }
    
    @MemberwiseInit(.public)
    @Codable
    public struct Confirm: Hashable, Sendable {
        @CodingKey(.token)
        @Init(default: "")
        public let token: String
        
        @CodingKey(.newEmail)
        @Init(default: "")
        public let newEmail: String
    }
}

extension CoenttbWebAccount.API.EmailChange {
    public struct Router: ParserPrinter, Sendable {
        
        public init(){}
        
        public var body: some URLRouting.Router<CoenttbWebAccount.API.EmailChange> {
            OneOf {
                URLRouting.Route(.case(CoenttbWebAccount.API.EmailChange.reauthorization)) {
                    Path { "reauthorization" }
                    Method.post
                    Body(.form(CoenttbWebAccount.API.EmailChange.Reauthorization.self, decoder: .default))
                }
                
                URLRouting.Route(.case(CoenttbWebAccount.API.EmailChange.request)) {
                    Path { "request" }
                    Method.post
                    Body(.form(CoenttbWebAccount.API.EmailChange.Request.self, decoder: .default))
                }
                
                URLRouting.Route(.case(CoenttbWebAccount.API.EmailChange.confirm)) {
                    Path { "confirm" }
                    Method.post
                    Body(.form(CoenttbWebAccount.API.EmailChange.Confirm.self, decoder: .default))
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
