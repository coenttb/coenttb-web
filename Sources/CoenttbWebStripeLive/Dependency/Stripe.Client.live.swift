//
//  File.swift
//  tenthijeboonkkamp-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 20/09/2024.
//

import Dependencies
import Foundation
@preconcurrency import StripeKit
import Vapor
import CoenttbWebStripe


extension CoenttbWebStripe.Client {
    public static func live(
        stripeSecretKey: String,
        httpClient: HTTPClient
    ) -> Self {

        let stripeKitClient = StripeClient(httpClient: httpClient, apiKey: stripeSecretKey)

        return .init(
            client: stripeKitClient,
            prices: .init(
                listAll: { filter in
                    try await stripeKitClient.prices.listAll(filter: filter)
                },
                retrieve: { price in
                    try await stripeKitClient.prices.retrieve(price: price, expand: nil)
                }
            ),
            customers: .init(
                create: { email, name in
                    try await stripeKitClient.customers.create(
                        address: nil,
                        description: nil,
                        email: email,
                        metadata: nil,
                        name: name,
                        paymentMethod: nil,
                        phone: nil,
                        shipping: nil,
                        balance: nil,
                        cashBalance: nil,
                        coupon: nil,
                        invoicePrefix: nil,
                        invoiceSettings: nil,
                        nextInvoiceSequence: nil,
                        preferredLocales: nil,
                        promotionCode: nil,
                        source: nil,
                        tax: nil,
                        taxExempt: nil,
                        taxIdData: nil,
                        testClock: nil,
                        expand: nil
                    )
                },
                update: { customer, email in
                    try await stripeKitClient.customers.update(
                        customer: customer,
                        address: nil,
                        description: nil,
                        email: email,
                        metadata: nil,
                        name: nil,
                        phone: nil,
                        shipping: nil,
                        balance: nil,
                        cashBalance: nil,
                        coupon: nil,
                        defaultSource: nil,
                        invoicePrefix: nil,
                        invoiceSettings: nil,
                        nextInvoiceSequence: nil,
                        preferredLocales: nil,
                        promotionCode: nil,
                        source: nil,
                        tax: nil,
                        taxExempt: nil,
                        expand: nil
                    )
                },
                retrieve: { customer, expand in
                    try await stripeKitClient.customers.retrieve(customer: customer, expand: expand)
                }
            ),
            subscriptions: .init(
                create: { customer, items, cancelAtPeriodEnd, paymentBehavior in
                    try await stripeKitClient.subscriptions.create(
                        customer: customer,
                        items: items,
                        cancelAtPeriodEnd: cancelAtPeriodEnd,
                        currency: nil,
                        defaultPaymentMethod: nil,
                        description: nil,
                        metadata: nil,
                        paymentBehavior: paymentBehavior,
                        addInvoiceItems: nil,
                        applicationFeePercent: nil,
                        automaticTax: nil,
                        backdateStartDate: nil,
                        billingCycleAnchor: nil,
                        billingThresholds: nil,
                        cancelAt: nil,
                        collectionMethod: nil,
                        coupon: nil,
                        daysUntilDue: nil,
                        defaultSource: nil,
                        defaultTaxRates: nil,
                        offSession: nil,
                        onBehalfOf: nil,
                        paymentSettings: nil,
                        pendingInvoiceItemInterval: nil,
                        promotionCode: nil,
                        prorationBehavior: nil,
                        transferData: nil,
                        trialEnd: nil,
                        trialFromPlan: nil,
                        trialPeriodDays: nil,
                        trialSettings: nil,
                        expand: ["latest_invoice.payment_intent"]
                    )
                },
                retrieve: { id in
                    try await stripeKitClient.subscriptions.retrieve(id: id, expand: nil)
                },
                listAll: { filter in
                    try await stripeKitClient.subscriptions.listAll(filter: filter)
                },
                updateItems: { subscription, items in
                    try await stripeKitClient.subscriptions.update(
                        subscription: subscription,
                        cancelAtPeriodEnd: nil,
                        defaultPaymentMethod: nil,
                        description: nil,
                        items: items,
                        metadata: nil,
                        paymentBehavior: nil,
                        prorationBehavior: nil,
                        addInvoiceItems: nil,
                        applicationFeePercent: nil,
                        billingCycleAnchor: nil,
                        billingThresholds: nil,
                        cancelAt: nil,
                        collectionMethod: nil,
                        coupon: nil,
                        daysUntilDue: nil,
                        defaultSource: nil,
                        defaultTaxRates: nil,
                        offSession: nil,
                        onBehalfOf: nil,
                        pauseCollection: nil,
                        paymentSettings: nil,
                        pendingInvoiceItemInterval: nil,
                        promotionCode: nil,
                        prorationDate: nil,
                        transferData: nil,
                        trialEnd: nil,
                        trialFromPlan: nil,
                        trialSettings: nil,
                        expand: nil
                    )
                },
                updateDefaultPayment: { subscription, defaultPaymentMethod in
                    try await stripeKitClient.subscriptions.update(
                        subscription: subscription,
                        cancelAtPeriodEnd: nil,
                        defaultPaymentMethod: defaultPaymentMethod,
                        description: nil,
                        items: nil,
                        metadata: nil,
                        paymentBehavior: nil,
                        prorationBehavior: nil,
                        addInvoiceItems: nil,
                        applicationFeePercent: nil,
                        billingCycleAnchor: nil,
                        billingThresholds: nil,
                        cancelAt: nil,
                        collectionMethod: nil,
                        coupon: nil,
                        daysUntilDue: nil,
                        defaultSource: nil,
                        defaultTaxRates: nil,
                        offSession: nil,
                        onBehalfOf: nil,
                        pauseCollection: nil,
                        paymentSettings: nil,
                        pendingInvoiceItemInterval: nil,
                        promotionCode: nil,
                        prorationDate: nil,
                        transferData: nil,
                        trialEnd: nil,
                        trialFromPlan: nil,
                        trialSettings: nil,
                        expand: nil
                    )
                },
                cancel: { id in
                    try await stripeKitClient.subscriptions.cancel(subscription: id, cancellationDetails: nil, invoiceNow: nil, prorate: nil, expand: nil)
                }
            ),
            invoices: .init(
                retrieveUpcomingInvoice: { filter in
                    try await stripeKitClient.invoices.retrieveUpcomingInvoice(filter: filter)
                }
            ),
            paymentIntents: .init(
                create: { amount, currency, automaticPaymentMethods in
                    try await stripeKitClient.paymentIntents.create(
                        amount: amount,
                        currency: currency,
                        automaticPaymentMethods: automaticPaymentMethods,
                        confirm: nil,
                        customer: nil,
                        description: nil,
                        metadata: nil,
                        offSession: nil,
                        paymentMethod: nil,
                        receiptEmail: nil,
                        setupFutureUsage: nil,
                        shipping: nil,
                        statementDescriptor: nil,
                        statementDescriptorSuffix: nil,
                        applicationFeeAmount: nil,
                        captureMethod: nil,
                        confirmationMethod: nil,
                        errorOnRequiresAction: nil,
                        mandate: nil,
                        mandateData: nil,
                        onBehalfOf: nil,
                        paymentMethodData: nil,
                        paymentMethodOptions: nil,
                        paymentMethodTypes: nil,
                        radarOptions: nil,
                        returnUrl: nil,
                        transferData: nil,
                        transferGroup: nil,
                        useStripeSDK: nil,
                        expand: nil
                    )
                },
                retrieve: { intent, clientSecret in
                    try await stripeKitClient.paymentIntents.retrieve(intent: intent, clientSecret: clientSecret)
                }
            ),
            portalSession: .init(
                create: {
                    customer,
                    returnUrl in
                    try await stripeKitClient.portalSession.create(
                        customer: customer,
                        configuration: nil,
                        flowData: nil,
                        locale: nil,
                        onBehalfOf: nil,
                        returnUrl: returnUrl,
                        expand: nil
                    )
                }
            )
        )
    }
}
