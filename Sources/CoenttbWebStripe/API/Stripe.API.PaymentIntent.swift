//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 15/09/2024.
//


import Dependencies
import EmailAddress
import Foundation
import Languages
import MemberwiseInit
import URLRouting
import MacroCodableKit



extension CoenttbWebStripe.API {
    public enum PaymentIntent: Equatable, Sendable {
        //        case cancel
        case create(CoenttbWebStripe.API.PaymentIntent.Create)
        //        case delete_discount
        //        case list
        //        case resume
        //        case retrieve
        //        case search
        //        case update
    }
}

extension CoenttbWebStripe.API.PaymentIntent {
    @MemberwiseInit(.public)
    @Codable
    public struct Create: Hashable, Sendable {
        @CodingKey(.amount)
        @Init(default: 0)
        public let amount: Int
    }
}



extension String {
    static let amount:Self = "amount"
}

extension CoenttbWebStripe.API.PaymentIntent {
    struct Router: ParserPrinter, Sendable {
        var body: some URLRouting.Router<API.PaymentIntent> {
            OneOf {
                URLRouting.Route(.case(API.PaymentIntent.create)) {
                    Path { "create" }
                    Parse(.memberwise(CoenttbWebStripe.API.PaymentIntent.Create.init)) {
                        Query {
                            Field(CoenttbWebStripe.API.PaymentIntent.Create.CodingKeys.amount.rawValue, default: 0) { Digits() }
                        }
                    }
                }
            }
        }
    }
}


//
//extension API.PaymentIntent {
//    public enum Create: Equatable {
//        case customer(API.PaymentIntent.Create.Customer)
//    }
//}
//
//extension API.PaymentIntent.Create {
//    struct Router: ParserPrinter, Sendable {
//        var body: some URLRouting.Router<API.PaymentIntent.Create> {
//            OneOf {
//                URLRouting.Route(.case(API.PaymentIntent.Create.customer)) {
//                    Method.post
//                    Path { "customer" }
//                    Body(.form(API.PaymentIntent.Create.Customer.self, decoder: .default))
//                }
//            }
//        }
//    }
//}
//
//extension API.PaymentIntent.Create {
//    @MemberwiseInit(.public)
//    @Codable
//    @CodingKeys(.kebab－case)
//    public struct Customer: Hashable {
//       @CodingKey("email")
//        @Init(default: "")
//        public let value: String
//    }
//}
//
//extension UrlFormDecoder {
//    fileprivate static let `default`: UrlFormDecoder = {
//        let decoder = UrlFormDecoder()
//        decoder.parsingStrategy = .bracketsWithIndices
//        return decoder
//    }()
//}
