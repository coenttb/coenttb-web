//
//  File 2.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 20/09/2024.
//

import Foundation
import StripeKit
import Dependencies

public enum StripeClientKey {
    
}

extension StripeClientKey: TestDependencyKey {
    public static let testValue: CoenttbWebStripe.Client? = .init(
        client: .init(httpClient: .testValue, apiKey: "test"),
        prices: .init(),
        customers: .init(),
        subscriptions: .init(),
        invoices: .init(),
        paymentIntents: .init(),
        portalSession: .init()
    )
}

extension DependencyValues {
    public var stripe: CoenttbWebStripe.Client? {
        get { self[StripeClientKey.self] }
        set { self[StripeClientKey.self] = newValue }
    }
}
