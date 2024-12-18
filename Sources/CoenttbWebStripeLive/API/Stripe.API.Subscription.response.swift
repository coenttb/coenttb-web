//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 17/09/2024.
//

import CoenttbWebHTML
import CoenttbWebStripe
import Dependencies
import Fluent
import Foundation
import Languages
import Mailgun
import Vapor

extension CoenttbWebStripe.API.Subscription {
    static func response(
        publishableKey: String,
        productLookupKeys: [String],
        currentUserStripeCustomerId: @escaping () -> String?,
        subscriber_email: @escaping () -> String?,
        subscriber_name: @escaping () -> String?,
        updateUser: (_ stripeCustomerId: String) async throws -> Void,
        checkIfStripeCustomerIdAlreadyExists: () async throws -> String?,
        subscription: API.Subscription
    ) async throws -> any AsyncResponseEncodable {
        
        @Dependency(\.stripe) var stripe
        guard let stripe
        else { throw Abort(.internalServerError) }
        
        switch subscription {

        case .config:
            let filter: [String: Any] = [
                "lookup_keys": productLookupKeys,
                "expand": ["data.product"]
            ]

            do {
                guard let prices = try await stripe.prices.listAll(filter: filter).data else {
                    throw Abort(.internalServerError, reason: "No prices")
                }
                let serializablePrices = prices.map { price -> [String: Any] in
                    var priceDict: [String: Any] = [
                        "id": price.id,
                        "currency": "\(price.currency ?? .usd)",
                        "unit_amount": "\(price.unitAmount ?? 0)",
                        "type": price.type?.rawValue ?? ""
                    ]

                    if let recurring = price.recurring {
                        priceDict["recurring"] = [
                            "interval": recurring.interval?.rawValue ?? "",
                            "interval_count": "\(recurring.intervalCount ?? 0)"
                        ]
                    }

                    if let product = price.$product {
                        priceDict["product"] = [
                            "id": product.id,
                            "name": product.name
                        ]
                    }

                    return priceDict
                }

                let responseData: [String: Any] = [
                    "publishableKey": publishableKey,
                    "prices": serializablePrices
                ]
                return Response(status: .ok, body: .init(data: try JSONSerialization.data(withJSONObject: responseData)))
            } catch let error as StripeKit.StripeError {
                print("Stripe Error: \(error)")
                print("Error Message: \(error.localizedDescription)")
                print("Error Type: \(error.error.debugDescription)")
                throw Abort(.internalServerError, reason: "Stripe Error: \(error.localizedDescription)")
            } catch {
                print("Unexpected error: \(error)")
                throw Abort(.internalServerError, reason: "Unexpected error: \(error.localizedDescription)")
            }

        case let .create(subscription):
            func createCustomer() async throws -> Customer {
                return try await stripe.customers.create(
                    email: subscriber_email(),
                    name: subscriber_name()
                )
            }

            func getOrCreateStripeCustomer() async throws -> String {
                if let existingId = try await checkIfStripeCustomerIdAlreadyExists() {
                    do {
                        _ = try await stripe.customers.retrieve(customer: existingId, expand: nil)
                        return existingId
                    } catch {
                        let customer = try await createCustomer()
                        try await updateUser(customer.id)
                        return customer.id
                    }
                }

                let customer = try await createCustomer()
                try await updateUser(customer.id)
                return customer.id
            }

            let stripeCustomerId: String = try await getOrCreateStripeCustomer()

            do {
                let subscription = try await stripe.subscriptions.create(
                    customer: stripeCustomerId,
                    items: [ ["price": subscription.priceId] ],
                    cancelAtPeriodEnd: false,
                    paymentBehavior: .defaultIncomplete
                )


                guard let clientSecret = subscription.$latestInvoice?.$paymentIntent?.clientSecret else {
                    throw Abort(.badRequest, reason: "Client secret not found")
                }
                let responseData: [String: Any] = [
                    "subscriptionId": publishableKey,
                    "clientSecret": clientSecret
                ]

                return Response(status: .ok, body: .init(data: try JSONSerialization.data(withJSONObject: responseData)))
            } catch let error as StripeKit.StripeError {
                print("Stripe Error: \(error)")
                print("Error Message: \(error.localizedDescription)")
                print("Error Type: \(error.error.debugDescription)")
                throw Abort(.internalServerError, reason: "Stripe Error: \("Unknown error")")
            } catch {
                print("Unexpected error: \(error)")
                throw Abort(.internalServerError, reason: "Unexpected error: \(error.localizedDescription)")
            }
        case let .invoicePreview(invoicePreview):
            
            guard let stripeCustomerId = currentUserStripeCustomerId()
            else { throw Abort(.badRequest, reason: "Customer ID not found") }

            let newPriceId = try await stripe.prices.retrieve(price: invoicePreview.newPriceId)

            let subscription = try await stripe.subscriptions.retrieve(id: invoicePreview.subscriptionId)

            guard let currentItemId = subscription.items?.data?.first?.id
            else { throw Abort(.internalServerError, reason: "Current subscription item not found") }

            let invoice = try await stripe.invoices.retrieveUpcomingInvoice(
                filter: [
                    "customer": stripeCustomerId,
                    "subscription": invoicePreview.subscriptionId,
                    "subscriptionItems": [
                        [
                            "id": currentItemId,
                            "price": newPriceId
                        ]
                    ]
                ]
            )

            let responseData: [String: Any] = [
                "invoice": invoice
            ]

            return Response(status: .ok, body: .init(data: try JSONSerialization.data(withJSONObject: responseData)))
        case let .cancel(subscription):

            do {
                let canceledSubscription = try await stripe.subscriptions.cancel(
                    subscription: subscription.subscriptionId
                )

                let responseData: [String: CoenttbWebStripe.Subscription] = [
                    "subscription": canceledSubscription
                ]

                let encodedData = try JSONEncoder().encode(responseData)

                return Response(status: .ok, body: .init(data: encodedData))
            } catch {
                throw Abort(.internalServerError, reason: "Failed to cancel subscription: \(error.localizedDescription)")
            }
        case let .update(subscription):
            do {
                let currentSubscription = try await stripe.subscriptions.retrieve(
                    id: subscription.subscriptionId
                )

                guard let itemId = currentSubscription.items?.data?.first?.id else {
                    throw Abort(.internalServerError, reason: "Subscription item not found")
                }

                let updatedSubscription = try await stripe.subscriptions.update(
                    subscription: subscription.subscriptionId,
                    items: [
                        [
                            "id": itemId,
                            "price": subscription.newPriceId
                        ]
                    ]
                )

                let responseData: [String: Any] = [
                    "subscription": updatedSubscription
                ]

                return Response(status: .ok, body: .init(data: try JSONSerialization.data(withJSONObject: responseData)))
            } catch {
                throw Abort(.internalServerError, reason: "Failed to update subscription: \(error.localizedDescription)")
            }

        case .subscriptions:
            guard let stripeCustomerId = currentUserStripeCustomerId()
            else { throw Abort(.badRequest, reason: "Customer ID not found") }

            let filter: [String: Any] = [
                "customer": stripeCustomerId,
                "status": "all",
                "expand": ["data.default_payment_method"]
            ]

            do {
                let subscriptions = try await stripe.subscriptions.listAll(filter: filter)
                let encodedData = try JSONEncoder().encode(subscriptions)

                return Response(
                    status: .ok,
                    body: .init(data: encodedData)
                )

            } catch {
                throw Abort(.internalServerError, reason: "Failed to list subscriptions: \(error.localizedDescription)")
            }
        }
    }
}
