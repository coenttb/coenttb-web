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
    public enum Password: Equatable, Sendable {
        case reset(CoenttbWebAccount.API.Password.Reset)
        case change(CoenttbWebAccount.API.Password.Change)
    }
}

extension CoenttbWebAccount.API.Password {
    public enum Reset: Equatable, Sendable {
        case request(CoenttbWebAccount.API.Password.Reset.Request)
        case confirm(CoenttbWebAccount.API.Password.Reset.Confirm)
    }
}

extension CoenttbWebAccount.API.Password.Reset {
    @MemberwiseInit(.public)
    @Codable
    public struct Request: Hashable, Sendable {
        @CodingKey(.email)
        @Init(default: "")
        public let email: String
    }
    
    @MemberwiseInit(.public)
    @Codable
    public struct Confirm: Hashable, Sendable {
        @CodingKey(.token)
        @Init(default: "")
        public let token: String
        
        @CodingKey(.newPassword)
        @Init(default: "")
        public let newPassword: String
    }
}

extension CoenttbWebAccount.API.Password {
    public enum Change: Equatable, Sendable {
        case reauthorization(CoenttbWebAccount.API.Password.Change.Reauthorization)
        case request(change: CoenttbWebAccount.API.Password.Change.Request)
    }
}

extension CoenttbWebAccount.API.Password.Change {
    @MemberwiseInit(.public)
    @Codable
    public struct Reauthorization: Hashable, Sendable {
        @CodingKey(.currentPassword)
        @Init(default: "")
        public let password: String
        
    }
    
    @MemberwiseInit(.public)
    @Codable
    public struct Request: Hashable, Sendable {
        @CodingKey(.currentPassword)
        @Init(default: "")
        public let currentPassword: String
        
        @CodingKey(.newPassword)
        @Init(default: "")
        public let newPassword: String
        
    }
}

extension CoenttbWebAccount.API.Password {
    public struct Router: ParserPrinter, Sendable {
        
        public init(){}
        
        public var body: some URLRouting.Router<CoenttbWebAccount.API.Password> {
            OneOf {
                URLRouting.Route(.case(CoenttbWebAccount.API.Password.reset)) {
                    Path { "reset" }
                    OneOf {
                        URLRouting.Route(.case(CoenttbWebAccount.API.Password.Reset.request)) {
                            Path { "request" }
                            Method.post
                            Body(.form(CoenttbWebAccount.API.Password.Reset.Request.self, decoder: .default))
                        }
                        
                        URLRouting.Route(.case(CoenttbWebAccount.API.Password.Reset.confirm)) {
                            Method.post
                            Path { "confirm" }
                            Body(.form(CoenttbWebAccount.API.Password.Reset.Confirm.self, decoder: .default))
                        }
                    }
                }
                
                URLRouting.Route(.case(CoenttbWebAccount.API.Password.change)) {
                    Path { "change" }
                    OneOf {
                        URLRouting.Route(.case(CoenttbWebAccount.API.Password.Change.reauthorization)) {
                            Method.post
                            Path { "reauthorization" }
                            Body(.form(CoenttbWebAccount.API.Password.Change.Reauthorization.self, decoder: .default))
                        }
                        
                        URLRouting.Route(.case(CoenttbWebAccount.API.Password.Change.request)) {
                            Method.post
                            Path { "request" }
                            Body(.form(CoenttbWebAccount.API.Password.Change.Request.self, decoder: .default))
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
