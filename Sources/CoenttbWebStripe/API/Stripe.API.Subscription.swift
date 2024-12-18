//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 17/09/2024.
//


import CasePaths
import Dependencies
import EmailAddress
import Foundation
import Languages
import MemberwiseInit
import URLRouting
import MacroCodableKit
import UrlFormCoding


extension API {
    public enum Subscription: Equatable, Sendable {
        case config
        case invoicePreview(InvoicePreview)
        case update(Update)
        case subscriptions
        case cancel(Cancel)
        case create(Create)
    }
}

extension API.Subscription {
    @MemberwiseInit(.public)
    @Codable
    public struct InvoicePreview: Hashable, Sendable {
        @CodingKey(.subscriptionId)
        @Init(default: "")
        public let subscriptionId: String
        
        @CodingKey(.newPriceId)
        @Init(default: "")
        public let newPriceId: String
    }
}

extension API.Subscription {
    @MemberwiseInit(.public)
    @Codable
    public struct Update: Hashable, Sendable {
        @CodingKey(.subscriptionId)
        @Init(default: "")
        public let subscriptionId: String
        
        @CodingKey(.newPriceId)
        @Init(default: "")
        public let newPriceId: String
    }
}

extension API.Subscription {
    @MemberwiseInit(.public)
    @Codable
    public struct Create: Hashable, Sendable {
        @CodingKey(.priceId)
        @Init(default: "")
        public let priceId: String
        
        @CodingKey(.name)
        @Init(default: "")
        public let name: String
    }
}

extension API.Subscription {
    @MemberwiseInit(.public)
    @Codable
    public struct Cancel: Hashable, Sendable {
        @CodingKey(.subscriptionId)
        @Init(default: "")
        public let subscriptionId: String
    }
}

extension API.Subscription {
    public struct Router: ParserPrinter {
        public init(){}
        
        public var body: some URLRouting.Router<API.Subscription> {
            OneOf {
                URLRouting.Route(.case(API.Subscription.config)) {
                    Path { "config" }
                }
                
                URLRouting.Route(.case(API.Subscription.invoicePreview)) {
                    Method.get
                    Path { "invoice-preview" }
                    Parse(.memberwise(API.Subscription.InvoicePreview.init)) {
                        Query {
                            Field(API.Subscription.InvoicePreview.CodingKeys.subscriptionId.rawValue, .string)
                            Field(API.Subscription.InvoicePreview.CodingKeys.newPriceId.rawValue, .string)
                        }
                    }
                }
                
                URLRouting.Route(.case(API.Subscription.update)) {
                    Method.post
                    Path { "update-subscription" }
                    Parse(.memberwise(API.Subscription.Update.init)) {
                        Query {
                            Field(API.Subscription.Update.CodingKeys.subscriptionId.rawValue, .string)
                            Field(API.Subscription.Update.CodingKeys.newPriceId.rawValue, .string)
                        }
                    }
                }
                
                URLRouting.Route(.case(API.Subscription.cancel)) {
                    Method.post
                    Path { "cancel-subscription" }
                    Parse(.memberwise(API.Subscription.Cancel.init)) {
                        Query {
                            Field(API.Subscription.Cancel.CodingKeys.subscriptionId.rawValue, .string)
                        }
                    }
                }
                
                URLRouting.Route(.case(API.Subscription.subscriptions)) {
                    Path { "subscriptions" }
                }
                
                URLRouting.Route(.case(API.Subscription.create)) {
                    Method.post
                    Path { "create-subscription" }
                    Body(.form(API.Subscription.Create.self, decoder: .default))
                }
            }
        }
    }
}


extension UrlFormDecoder {
    fileprivate static var `default`: UrlFormDecoder  {
        let decoder = UrlFormDecoder()
        decoder.parsingStrategy = .bracketsWithIndices
        return decoder
    }
}

extension String {
    static let priceId:Self = "priceId"
    static let subscriptionId:Self = "subscriptionId"
    static let name:Self = "name"
    static let newPriceId:Self = "newPriceId"
}
