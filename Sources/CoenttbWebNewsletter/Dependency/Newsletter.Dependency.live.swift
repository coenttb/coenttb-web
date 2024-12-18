//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 16/10/2024.
//

import EmailAddress
import Foundation
import Mailgun
import CoenttbWebHTML
import Fluent
import CoenttbVapor

extension Client {
    public static func live(
        database: Fluent.Database,
        logger: Logger,
        notifyOfNewSubscriptionEmail: ((_ addres: String) -> Email)?,
        sendEmail: ( @Sendable (Email) async throws -> SendEmailResponse)?,
        verificationTimeout: TimeInterval = 24 * 60 * 60
    ) -> Self {
        return .init(
            subscribe: .init(
                request: { emailAddress in
                    do {
                        let subscription = try Newsletter(email: emailAddress.rawValue)
                        try await subscription.save(on: database)
                        logger.log(.info, "subscription successfully saved")
                        
                        if
                            let sendEmail,
                            let notifyOfNewSubscriptionEmail
                        {
                            let emailResponse = try await sendEmail(notifyOfNewSubscriptionEmail(emailAddress.rawValue))
                            logger.info("sent email: \(emailResponse.message)")
                        }
                        
                    } catch let error as DatabaseError where error.isConstraintFailure {
                        return
                    } catch {
                        throw error
                    }
                },
                verify: { token, email in
                    do {
                        // Find the subscription
                        guard let subscription = try await Newsletter.query(on: database)
                            .filter(\.$email == email)
                            .first() else {
                            throw VerificationError.subscriptionNotFound
                        }
                        
                        // Check if subscription is in pending state
                        guard subscription.emailVerificationStatus == .pending else {
                            throw VerificationError.invalidVerificationStatus
                        }
                        
                        // Verify token (you'll need to implement your token verification logic)
                        guard isValidToken(token, for: email) else {
                            subscription.emailVerificationStatus = .failed
                            try await subscription.save(on: database)
                            throw VerificationError.invalidToken
                        }
                        
                        // Check if verification hasn't timed out
                        if let createdAt = subscription.createdAt,
                           Date().timeIntervalSince(createdAt) > verificationTimeout {
                            subscription.emailVerificationStatus = .failed
                            try await subscription.save(on: database)
                            throw VerificationError.verificationTimeout
                        }
                        
                        // Update verification status
                        subscription.emailVerificationStatus = .verified
                        try await subscription.save(on: database)
                        
                        logger.info("Email verification successful for: \(email)")
                        
                    } catch {
                        logger.error("Email verification failed: \(error)")
                        throw error
                    }
                }
            ),
            unsubscribe: { emailAddress in
                try await Newsletter.query(on: database)
                    .filter(\.$email == emailAddress.rawValue)
                    .delete()
            }
        )
    }
}

extension Client {
    private static func isValidToken(_ token: String, for email: String) -> Bool {
        // Implement your token validation logic here
        // This could involve checking against a stored token, validating a JWT, etc.
        fatalError("Token validation not implemented")
    }
}

// Add verification-related errors
enum VerificationError: Error {
    case subscriptionNotFound
    case invalidToken
    case verificationTimeout
    case invalidVerificationStatus
}
