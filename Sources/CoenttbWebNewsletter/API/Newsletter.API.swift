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

public enum API: Equatable, Sendable {
    case subscribe(Post.Email)
    case unsubscribe(Post.Email)
}

extension CoenttbWebNewsletter.API {
    public struct Router: ParserPrinter, Sendable {
        
        public init(){}
        
        public var body: some URLRouting.Router<CoenttbWebNewsletter.API> {
            OneOf {
                URLRouting.Route(.case(CoenttbWebNewsletter.API.subscribe)) {
                    Method.post
                    Path { "subscribe" }
                    Body(.form(Post.Email.self, decoder: .default))
                }
                
                URLRouting.Route(.case(CoenttbWebNewsletter.API.unsubscribe)) {
                    Method.get
                    Path { "unsubscribe" }
                    Body(.form(Post.Email.self, decoder: .default))
                }
            }
        }
    }
}

public enum Post: Codable, Hashable {
    case email(Post.Email = .init())
    
    @MemberwiseInit(.public)
    @Codable
    public struct Email: Hashable, Sendable {
       @CodingKey("email")
        @Init(default: "")
        public let value: String
    }
}

extension UrlFormDecoder {
    fileprivate static var `default`: UrlFormDecoder {
        let decoder = UrlFormDecoder()
        decoder.parsingStrategy = .bracketsWithIndices
        return decoder
    }
}
