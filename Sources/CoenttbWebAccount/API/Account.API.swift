//
//  File.swift
//  tenthijeboonkkamp-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 10/09/2024.
//

import Dependencies
import EmailAddress
import Foundation
import Languages
import MemberwiseInit
import URLRouting
import MacroCodableKit
import UrlFormCoding
import CoenttbWebTranslations

public enum API: Equatable, Sendable {
    case create(CoenttbWebAccount.API.Create)
    case login(CoenttbWebAccount.API.Login)
    case logout
    case update(CoenttbWebAccount.API.Update)
    case delete(CoenttbWebAccount.API.Delete)
    case password(CoenttbWebAccount.API.Password)
    case emailChange(CoenttbWebAccount.API.EmailChange)
}

extension CoenttbWebAccount.API {
    public struct Router: ParserPrinter, Sendable {
        
        public init(){}
        
        public var body: some URLRouting.Router<CoenttbWebAccount.API> {
            OneOf {
                
                URLRouting.Route(.case(CoenttbWebAccount.API.create)) {
                    Path { "create" }
                    CoenttbWebAccount.API.Create.Router()
                }
                
                URLRouting.Route(.case(CoenttbWebAccount.API.update)) {
                    Method.post
                    Path { "update" }
                    Body(.form(CoenttbWebAccount.API.Update.self, decoder: .default))
                }
                
                URLRouting.Route(.case(CoenttbWebAccount.API.delete)) {
                    Path { "delete" }
                    CoenttbWebAccount.API.Delete.Router()
                }
                
                URLRouting.Route(.case(CoenttbWebAccount.API.login)) {
                    Method.post
                    Path { "login" }
                    Body(.form(CoenttbWebAccount.API.Login.self, decoder: .default))
                }
                
                URLRouting.Route(.case(CoenttbWebAccount.API.logout)) {
                    Method.post
                    Path { "logout" }
                }
                
                URLRouting.Route(.case(CoenttbWebAccount.API.password)) {
                    Path { "password" }
                    CoenttbWebAccount.API.Password.Router()
                }
                
                URLRouting.Route(.case(CoenttbWebAccount.API.emailChange)) {
                    Path { "email-change" }
                    CoenttbWebAccount.API.EmailChange.Router()
                }
            }
        }
    }
}

extension CoenttbWebAccount.API {
    @MemberwiseInit(.public)
    @Codable
    public struct Search: Hashable, Sendable {
        @CodingKey("value")
        @Init(default: "")
        public let value: String
    }
}

extension CoenttbWebAccount.API {
    @MemberwiseInit(.public)
    @Codable
    public struct Update: Hashable, Sendable {
       @CodingKey("name")
        @Init(default: "")
        public let name: String?
    }
}



extension CoenttbWebAccount.API {
    @MemberwiseInit(.public)
    @Codable
    public struct Login: Hashable, Sendable {
        @CodingKey(.email)
        @Init(default: "")
        public let email: String
        
        @CodingKey(.password)
        @Init(default: "")
        public let password: String
    }
}

extension CoenttbWebAccount.API {
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

extension UrlFormDecoder {
    fileprivate static var `default`: UrlFormDecoder {
        let decoder = UrlFormDecoder()
        decoder.parsingStrategy = .bracketsWithIndices
        return decoder
    }
}


