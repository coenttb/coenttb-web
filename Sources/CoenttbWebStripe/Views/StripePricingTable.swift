//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 11/09/2024.
//

import CoenttbWebHTML

public struct PricingTable: HTML {
    
    let pricingTableId: String
    let publishableKey: String
    
    public init(pricingTableId: String, publishableKey: String) {
        self.pricingTableId = pricingTableId
        self.publishableKey = publishableKey
    }
    
    let stripe_pricing_table: HTMLTag = .init(stringLiteral: "stripe-pricing-table")
    
    public var body: some HTML {
        script()
            .attribute("async")
            .src("https://js.stripe.com/v3/pricing-table.js")
        
        stripe_pricing_table()
            .attribute("pricing-table-id", pricingTableId)
            .attribute("publishable-key", publishableKey)
    }
}
