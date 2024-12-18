//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 10/09/2024.
//

import CoenttbWebHTML
import Dependencies
import Fluent
import Foundation
import Languages
import CoenttbVapor
import Mailgun

extension CoenttbWebNewsletter.API {

    private static let subscriptionRateLimiter = SubscriptionRateLimiter()
    
    public static func response(
        database: Fluent.Database,
        client: CoenttbWebNewsletter.Client,
        logger: Logger,
        cookieId: String,
        newsletter: CoenttbWebNewsletter.API
    ) async throws -> any AsyncResponseEncodable {
        switch newsletter {
        case .subscribe(let subscribe):
            switch subscribe {
            case .request(let request):
                let email = request.email
                
                logger.info("Received subscription request for email: \(email)")
                
                @Dependency(\.envVars.appEnv) var appEnv
                
                let cookieValue = HTTPCookies.Value(
                    string: "true",
                    expires: .distantFuture,
                    maxAge: nil,
                    isSecure: appEnv == .production ? true : false,
                    isHTTPOnly: false,
                    sameSite: .strict
                )
                
                do {
                    // First check rate limiting
                    try await subscriptionRateLimiter.subscribe(email)
                    
                    // Then check if subscription exists and its state
                    if let existingSubscription = try await Newsletter.query(on: database)
                        .filter(\.$email == email)
                        .first() {
                        
                        switch existingSubscription.emailVerificationStatus {
                        case .verified:
                            let response = Response.json(success: true, message: "Already subscribed")
                            response.cookies[cookieId] = cookieValue
                            return response
                        case .pending:
                            // Delete old pending subscription to allow retry
                            try await existingSubscription.delete(on: database)
                        case .failed, .unverified:
                            // Delete failed/unverified to allow retry
                            try await existingSubscription.delete(on: database)
                        }
                    }
                    
                    // Handle new subscription
                    try await client.subscribe.request(.init(email))
                    
                    let response = Response.json(success: true, message: "Successfully subscribed")
                    response.cookies[cookieId] = cookieValue
                    return response
                    
                } catch let error as ValidationError {
                    switch error {
                    case .tooManyAttempts:
                        throw Abort(.tooManyRequests, reason: "Too many subscription attempts. Please try again later.")
                    default:
                        throw error
                    }
                } catch {
                    logger.error("Mailgun subscription failed: \(error)")
                    throw Abort(.internalServerError, reason: "Failed to send subscription email. Please contact support.")
                }
                
            case .verify(let verify):
                logger.info("Processing verification request for email: \(verify.email) with token: \(verify.token)")
                
                do {
                    try await client.subscribe.verify(verify.token, verify.email)
                    
                    @Dependency(\.envVars.appEnv) var appEnv
                    
                    let cookieValue = HTTPCookies.Value(
                        string: "true",
                        expires: .distantFuture,
                        maxAge: nil,
                        isSecure: appEnv == .production ? true : false,
                        isHTTPOnly: false,
                        sameSite: .strict
                    )
                    
                    let response = Response.json(success: true, message: "Email successfully verified")
                    response.cookies[cookieId] = cookieValue
                    return response
                    
                } catch let error as ValidationError {
                    switch error {
                    case .invalidToken:
                        throw Abort(.badRequest, reason: "Invalid or expired verification token")
                    case .invalidInput:
                        throw Abort(.badRequest, reason: "Invalid verification data provided")
                    case .invalidVerificationStatus:
                        throw Abort(.badRequest, reason: "Invalid verification status")
                    case .tooManyAttempts:
                        throw Abort(.tooManyRequests, reason: "Too many verification attempts")
                    }
                } catch {
                    logger.error("Verification failed: \(error)")
                    throw Abort(.internalServerError, reason: "Verification failed. Please try again later.")
                }
            }
            
        case .unsubscribe(let emailAddress):
            logger.info("Received unsubscription request for email: \(emailAddress.value)")
            try await client.unsubscribe(.init(emailAddress.value))
            
            let response = Response.json(success: true)
            response.cookies[cookieId] = nil
            return response
            
        }
    }
}

