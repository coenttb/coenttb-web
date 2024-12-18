//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 20/09/2024.
//

import Foundation

actor SubscriptionRateLimiter {  // renamed from SubscriptionManager
    private struct AttemptInfo {
        let timestamp: Date
        var attempts: Int
    }
    
    private var attemptsByEmail: [String: AttemptInfo] = [:]
    private let maxAttempts: Int = 5
    private let windowDuration: TimeInterval = 3600 // 1 hour
    
    func subscribe(_ email: String) throws {  // changed to throw instead of return bool
        let now = Date()
        
        // Clean up old entries
        attemptsByEmail = attemptsByEmail.filter {
            now.timeIntervalSince($0.value.timestamp) < windowDuration
        }
        
        // Get or create attempt info
        let attemptInfo = attemptsByEmail[email, default: AttemptInfo(timestamp: now, attempts: 0)]
        
        // Check if within rate limit
        if attemptInfo.attempts >= maxAttempts {
            throw ValidationError.tooManyAttempts("Too many subscription attempts")
        }
        
        // Update attempts
        attemptsByEmail[email] = AttemptInfo(timestamp: attemptInfo.timestamp, attempts: attemptInfo.attempts + 1)
    }
    
    func reset(_ email: String) {
        attemptsByEmail.removeValue(forKey: email)
    }
}
