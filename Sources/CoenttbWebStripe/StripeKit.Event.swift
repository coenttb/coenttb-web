//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 20/09/2024.
//

import Foundation
import Dependencies
@preconcurrency import StripeKit
@_exported import struct StripeKit.Event
import Vapor

extension StripeKit.Event {
    enum WebhookError: Error {
        case unableToParseHeader
        case noMatchingSignatureFound
        case invalidPayload
    }
    
    public init(from request: Request, endpointSecret: String) throws {
        guard let signature = request.headers.first(name: "Stripe-Signature") else {
            throw WebhookError.unableToParseHeader
        }
        
        guard let payload = request.body.data else {
            throw WebhookError.noMatchingSignatureFound
        }
        
        try StripeClient.verifySignature(
            payload: Data(payload.readableBytesView),
            header: signature,
            secret: endpointSecret
        )

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let eventData = request.body.data else {
            throw WebhookError.invalidPayload
        }
        
        self = try decoder.decode(StripeKit.Event.self, from: eventData)
    }
}
