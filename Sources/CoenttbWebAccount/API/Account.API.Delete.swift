//
//  File.swift
//  coenttb-web
//
//  Deleted by Coen ten Thije Boonkkamp on 17/10/2024.
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
    
    public enum Delete: Codable, Hashable, Sendable {
        case request(Delete.Request)
        case cancel(Delete.Cancel)
        
        @MemberwiseInit(.public)
        @Codable
        public struct Request: Hashable, Sendable {
            @CodingKey(.userId)
            @Init(default: "")
            public let userId: String
            
            @CodingKey(.reauthToken)
            @Init(default: "")
            public let reauthToken: String
        }
        
        @MemberwiseInit(.public)
        @Codable
        public struct Cancel: Hashable, Sendable {
            @CodingKey(.userId)
            @Init(default: "")
            public let userId: String
        }
    }
}

extension CoenttbWebAccount.API.Delete {
    public struct Router: ParserPrinter, Sendable {
        
        public init(){}
        
        public var body: some URLRouting.Router<CoenttbWebAccount.API.Delete> {
            OneOf {
                URLRouting.Route(.case(CoenttbWebAccount.API.Delete.request)) {
                    Path { "request" }
                    Method.post
                    Body(.form(CoenttbWebAccount.API.Delete.Request.self, decoder: .default))
                }
                
                URLRouting.Route(.case(CoenttbWebAccount.API.Delete.cancel)) {
                    Path { "cancel" }
                    Method.post
                    Body(.form(CoenttbWebAccount.API.Delete.Cancel.self, decoder: .default))
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
