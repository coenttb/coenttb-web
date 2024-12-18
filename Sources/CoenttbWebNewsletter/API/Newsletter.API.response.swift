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
                    // Check rate limiting first
                    try await subscriptionRateLimiter.subscribe(email)
                    
                    // Let the client handle all subscription logic
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
                    logger.error("Subscription failed: \(error)")
                    throw Abort(.internalServerError, reason: "Failed to process subscription. Please try again later.")
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

