//
//  File.swift
//  tenthijeboonkkamp-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 10/09/2024.
//

import CoenttbWebHTML
import CoenttbWebStripe
import Dependencies
import Fluent
import Foundation
import Languages
import Vapor

extension CoenttbWebStripe.API {
    public static func response(
        stripe: CoenttbWebStripe.API,
        publishableKey: String,
        productLookupKeys: String,
        currentUserStripeCustomerId: @escaping () -> String?,
        subscriber_email: @escaping () -> String?,
        subscriber_name: @escaping () -> String?,
        updateUser: (_ stripeCustomerId: String) async throws -> Void,
        checkIfStripeCustomerIdAlreadyExists: () async throws -> String?
    ) async throws -> any AsyncResponseEncodable {
        switch stripe {
        case let .subscription(subscription):
            return try await CoenttbWebStripe.API.Subscription.response(
                publishableKey: publishableKey,
                productLookupKeys: [productLookupKeys],
                currentUserStripeCustomerId: currentUserStripeCustomerId,
                subscriber_email: subscriber_email,
                subscriber_name: subscriber_name,
                updateUser: updateUser,
                checkIfStripeCustomerIdAlreadyExists: checkIfStripeCustomerIdAlreadyExists,
                subscription: subscription
            )
            
        case .publishableKey:
            return ["publishableKey": publishableKey]

        case let .payment_intent(payment_intent):
            return try await CoenttbWebStripe.API.PaymentIntent.response(payment_intent: payment_intent)
        }
    }
}
