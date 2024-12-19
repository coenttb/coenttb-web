//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import Foundation

public struct GeoLocation: Sendable, Hashable {
    public let country: String?
    public let region: String?
    public let city: String?
    
    public init(
        country: String? = nil,
        region: String? = nil,
        city: String? = nil
    ) {
        self.country = country
        self.region = region
        self.city = city
    }
}
