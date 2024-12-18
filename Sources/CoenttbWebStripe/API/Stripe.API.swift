//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 20/09/2024.
//

import Dependencies
import Foundation
import Languages
import URLRouting
import MacroCodableKit

public enum API: Equatable, Sendable {
    case payment_intent(CoenttbWebStripe.API.PaymentIntent)
    case subscription(CoenttbWebStripe.API.Subscription)
    case publishableKey
}

extension CoenttbWebStripe.API {
    public struct Router: ParserPrinter, Sendable {
        
        public init(){}
        
        public var body: some URLRouting.Router<CoenttbWebStripe.API> {
            OneOf {
                URLRouting.Route(.case(CoenttbWebStripe.API.publishableKey)) {
                    Path { "publishable-key" }
                }
                
                URLRouting.Route(.case(CoenttbWebStripe.API.payment_intent)) {
                    Path { "payment-intent" }
                    CoenttbWebStripe.API.PaymentIntent.Router()
                }
                                
                URLRouting.Route(.case(CoenttbWebStripe.API.subscription)) {
                    Path { "subscription" }
                    CoenttbWebStripe.API.Subscription.Router()
                }
            }
        }
    }
}
