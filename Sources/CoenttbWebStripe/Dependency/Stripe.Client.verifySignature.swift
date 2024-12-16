//
//  File.swift
//  tenthijeboonkkamp-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 10/09/2024.
//

import Foundation
import Dependencies
@preconcurrency import StripeKit
import Vapor

extension CoenttbWebStripe.Client {
    /// Verifies a Stripe signature for a given `Request`. This automatically looks for the header in the headers of the request and the body.
    /// - Parameters:
    ///     - req: The `Request` object to check header and body for
    ///     - secret: The webhook secret used to verify the signature
    ///     - tolerance: In seconds the time difference tolerance to prevent replay attacks: Default 300 seconds
    /// - Throws: `StripeSignatureError`
    public static func verifySignature(for request: Request, secret: String, tolerance: Double = 300) throws {
        guard let header = request.headers.first(name: "Stripe-Signature") else {
            throw StripeSignatureError.unableToParseHeader
        }
        
        guard let data = request.body.data else {
            throw StripeSignatureError.noMatchingSignatureFound
        }
        
        try StripeClient.verifySignature(payload: Data(data.readableBytesView), header: header, secret: secret, tolerance: tolerance)
    }
}

extension CoenttbWebStripe.Client {
    public func verifySignature(for request: Request, secret: String, tolerance: Double = 300) throws {
        try CoenttbWebStripe.Client.verifySignature(for: request, secret: secret, tolerance: tolerance)
    }
}

extension Vapor.Request {
    public func verifySignature(secret: String, tolerance: Double = 300) throws {
        try CoenttbWebStripe.Client.verifySignature(for: self, secret: secret, tolerance: tolerance)
    }
}

extension StripeSignatureError: @retroactive AbortError {
    public var reason: String {
        switch self {
        case .noMatchingSignatureFound:
            return "No matching signature was found"
        case .timestampNotTolerated:
            return "Timestamp was not tolerated"
        case .unableToParseHeader:
            return "Unable to parse Stripe-Signature header"
        }
    }
    
    public var status: HTTPResponseStatus {
        .badRequest
    }
}


