//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 31/10/2024.
//

import Foundation
import CoenttbWebDependencies

extension InMemoryStore {

    private static func combinedKey(idempotencyKey: String, eventId: String) -> String {
        "\(idempotencyKey)_\(eventId)"
    }

    public func hasProcessedEvent(idempotencyKey: String, eventId: String) -> Bool {

        return get(Self.combinedKey(idempotencyKey: idempotencyKey, eventId: eventId)) != nil
    }

    public func markEventAsProcessed(idempotencyKey: String, eventId: String) {
        set(Self.combinedKey(idempotencyKey: idempotencyKey, eventId: eventId), value: eventId, expiresIn: 24 * 60 * 60) // 24 hours expiration
    }
}
