//
//  File.swift
//  tenthijeboonkkamp-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 10/09/2024.
//

import Foundation
@preconcurrency import StripeKit
import Dependencies
import DependenciesMacros
import Vapor
import HTML
import MemberwiseInit

public var stripeJsScript: some HTML { script().src("https://js.stripe.com/v3/") }

@DependencyClient
@MemberwiseInit(.public)
public struct Client: Sendable {
    public var client: StripeClient
    public var prices: Client.Prices
    public var customers: Client.Customers
    public var subscriptions: Client.Subscriptions
    public var invoices: Client.Invoices
    public var paymentIntents: Client.PaymentIntents
    public var portalSession: Client.PortalSession
}

extension Client {
    @MemberwiseInit(.public)
    public struct EnvVars: Codable {
        public var endpointSecret: String
        public var publishableKey: String
        public var secretKey: String
    }
}

extension Client {
    @DependencyClient
    public struct PortalSession: @unchecked Sendable {
        @DependencyEndpoint
        public var create: (
            _ customer: String,
            _ returnUrl: String
        ) async throws -> StripeKit.PortalSession
    }
}


extension Client {
    @DependencyClient
    public struct PaymentIntents: @unchecked Sendable {
        
        @DependencyEndpoint
        public var create: (
            _ amount: Int,
            _ currency: Currency,
            _ automaticPaymentMethods: [String: Any]?
//            _ confirm: Bool? = nil,
//            _ customer: String? = nil,
//            _ description: String? = nil,
//            _ metadata: [String: String]? = nil,
//            _ offSession: Bool? = nil,
//            _ paymentMethod: String? = nil,
//            _ receiptEmail: String? = nil,
//            _ setupFutureUsage: StripeKit.PaymentIntentSetupFutureUsage? = nil,
//            _ shipping: [String: Any]? = nil,
//            _ statementDescriptor: String? = nil,
//            _ statementDescriptorSuffix: String? = nil,
//            _ applicationFeeAmount: Int? = nil,
//            _ captureMethod: StripeKit.PaymentIntentCaptureMethod? = nil,
//            _ confirmationMethod: StripeKit.PaymentIntentConfirmationMethod? = nil,
//            _ errorOnRequiresAction: Bool? = nil,
//            _ mandate: String? = nil,
//            _ mandateData: [String: Any]? = nil,
//            _ onBehalfOf: String? = nil,
//            _ paymentMethodData: [String: Any]? = nil,
//            _ paymentMethodOptions: [String: Any]? = nil,
//            _ paymentMethodTypes: [String]? = nil,
//            _ radarOptions: [String: Any]? = nil,
//            _ returnUrl: String? = nil,
//            _ transferData: [String: Any]? = nil,
//            _ transferGroup: String? = nil,
//            _ useStripeSDK: Bool? = nil,
//            _ expand: [String]? = nil
        ) async throws -> StripeKit.PaymentIntent
        
        @DependencyEndpoint
        public var retrieve: (
            _ intent: String,
            _ clientSecret: String?
        ) async throws -> StripeKit.PaymentIntent
    }
}

extension Client {
    @DependencyClient
    public struct Invoices: @unchecked Sendable {
        
        
        @DependencyEndpoint
        public var retrieveUpcomingInvoice: (
            _ filter: [String: Any]?
        ) async throws -> StripeKit.Invoice
    }
}


extension Client {
    @DependencyClient
    public struct Subscriptions: @unchecked Sendable {
        @DependencyEndpoint
        public var create: (
            _ customer: String,
            _ items: [[String: Any]],
            _ cancelAtPeriodEnd: Bool?,
//            _ currency: Currency?,
//            _ defaultPaymentMethod: String?,
//            _ description: String?,
//            _ metadata: [String: String]?,
            _ paymentBehavior: SubscriptionPaymentBehavior?
//            _ addInvoiceItems: [[String: Any]]?,
//            _ applicationFeePercent: Decimal?,
//            _ automaticTax: [String: Any]?,
//            _ backdateStartDate: Date?,
//            _ billingCycleAnchor: Date?,
//            _ billingThresholds: [String: Any]?,
//            _ cancelAt: Date?,
//            _ collectionMethod: SubscriptionCollectionMethod?,
//            _ coupon: String?,
//            _ daysUntilDue: Int?,
//            _ defaultSource: String?,
//            _ defaultTaxRates: [String]?,
//            _ offSession: Bool?,
//            _ onBehalfOf: String?,
//            _ paymentSettings: [String: Any]?,
//            _ pendingInvoiceItemInterval: [String: Any]?,
//            _ promotionCode: String?,
//            _ prorationBehavior: SubscriptionProrationBehavior?,
//            _ transferData: [String: Any]?,
//            _ trialEnd: Any?,
//            _ trialFromPlan: Bool?,
//            _ trialPeriodDays: Int?,
//            _ trialSettings: [String: Any]?,
//            _ expand: [String]?
        ) async throws -> StripeKit.Subscription
        
        @DependencyEndpoint
        public var retrieve: (
            _ id: String
        ) async throws -> StripeKit.Subscription
        
        @DependencyEndpoint
        public var listAll: (_ filter: [String: Any]?) async throws -> StripeKit.SubscriptionList
        
        @DependencyEndpoint(method: "update")
        public var updateItems: (
            _ subscription: String,
//            _ cancelAtPeriodEnd: Bool?,
//            _ defaultPaymentMethod: String?,
//            _ description: String?,
            _ items: [[String: Any]]?
//            _ metadata: [String: String]?,
//            _ paymentBehavior: StripeKit.SubscriptionPaymentBehavior?,
//            _ prorationBehavior: StripeKit.SubscriptionProrationBehavior?,
//            _ addInvoiceItems: [[String: Any]]?,
//            _ applicationFeePercent: Decimal?,
//            _ billingCycleAnchor: String?,
//            _ billingThresholds: [String: Any]?,
//            _ cancelAt: Date?,
//            _ collectionMethod: StripeKit.SubscriptionCollectionMethod?,
//            _ coupon: String?,
//            _ daysUntilDue: Int?,
//            _ defaultSource: String?,
//            _ defaultTaxRates: [String]?,
//            _ offSession: Bool?,
//            _ onBehalfOf: String?,
//            _ pauseCollection: [String: Any]?,
//            _ paymentSettings: [String: Any]?,
//            _ pendingInvoiceItemInterval: [String: Any]?,
//            _ promotionCode: String?,
//            _ prorationDate: Date?,
//            _ transferData: [String: Any]?,
//            _ trialEnd: Any?,
//            _ trialFromPlan: Bool?,
//            _ trialSettings: [String: Any]?,
//            _ expand: [String]?
        ) async throws -> StripeKit.Subscription
        
        @DependencyEndpoint(method: "update")
        public var updateDefaultPayment: (
            _ subscription: String,
//            _ cancelAtPeriodEnd: Bool?,
            _ defaultPaymentMethod: String?
//            _ description: String?,
//            _ items: [[String: Any]]?
//            _ metadata: [String: String]?,
//            _ paymentBehavior: StripeKit.SubscriptionPaymentBehavior?,
//            _ prorationBehavior: StripeKit.SubscriptionProrationBehavior?,
//            _ addInvoiceItems: [[String: Any]]?,
//            _ applicationFeePercent: Decimal?,
//            _ billingCycleAnchor: String?,
//            _ billingThresholds: [String: Any]?,
//            _ cancelAt: Date?,
//            _ collectionMethod: StripeKit.SubscriptionCollectionMethod?,
//            _ coupon: String?,
//            _ daysUntilDue: Int?,
//            _ defaultSource: String?,
//            _ defaultTaxRates: [String]?,
//            _ offSession: Bool?,
//            _ onBehalfOf: String?,
//            _ pauseCollection: [String: Any]?,
//            _ paymentSettings: [String: Any]?,
//            _ pendingInvoiceItemInterval: [String: Any]?,
//            _ promotionCode: String?,
//            _ prorationDate: Date?,
//            _ transferData: [String: Any]?,
//            _ trialEnd: Any?,
//            _ trialFromPlan: Bool?,
//            _ trialSettings: [String: Any]?,
//            _ expand: [String]?
        ) async throws -> StripeKit.Subscription
        
        @DependencyEndpoint
        public var cancel: (
            _ subscription: String
        ) async throws -> Subscription
    }
}

extension Client {
    @DependencyClient
    public struct Prices: @unchecked Sendable {
        @DependencyEndpoint
        public var listAll: (_ filter: [String: Any]?) async throws -> StripeKit.PriceList
        
        @DependencyEndpoint
        public var retrieve: (_ price: String) async throws -> StripeKit.Price
    }
}

extension Client {
    @DependencyClient
    public struct Customers: @unchecked Sendable {
        @DependencyEndpoint
        public var create: (
//            _ address: [String: Any]?,
//            _ description: String?,
            _ email: String?,
//            _ metadata: [String: String]?,
            _ name: String?
//            _ paymentMethod: String?,
//            _ phone: String?,
//            _ shipping: [String: Any]?,
//            _ balance: Int?,
//            _ cashBalance: [String: Any]?,
//            _ coupon: String?,
//            _ invoicePrefix: String?,
//            _ invoiceSettings: [String: Any]?,
//            _ nextInvoiceSequence: Int?,
//            _ preferredLocales: [String]?,
//            _ promotionCode: String?,
//            _ source: Any?,
//            _ tax: [String: Any]?,
//            _ taxExempt: StripeKit.CustomerTaxExempt?,
//            _ taxIdData: [[String: Any]]?,
//            _ testClock: String?,
//            _ expand: [String]?
        ) async throws -> StripeKit.Customer
        
        @DependencyEndpoint
        public var update: (
            _ customer: String,
            _ email: String
        ) async throws -> StripeKit.Customer

        @DependencyEndpoint
        public var retrieve: (
            _ customer: String,
            _ expand: [String]?
        ) async throws -> StripeKit.Customer
    }
}
