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
    
//    public struct RateLimitContext: Sendable, Hashable {
//        public let email: EmailAddress
//        public let ipAddress: String
//        public let userAgent: String?
//        public let timestamp: Date
//        public let requestId: String?
//        public let geoLocation: GeoLocation?
//    }
    
//    private static let subscriptionRateLimiter: RateLimiter<RateLimitContext> = .init(windows: [])
    
    
    private enum RateLimitKey: Hashable, Sendable {
        case email(String)
        case ip(String)
    }
    
    private static let emailLimiter = RateLimiter<RateLimitKey>(
        windows: [
            .minutes(5, maxAttempts: 3),   // 3 attempts per 5 minutes
            .hours(24, maxAttempts: 10)    // 10 attempts per day
        ],
        backoffMultiplier: 2.0
    )
    
    private static let ipLimiter = RateLimiter<RateLimitKey>(
        windows: [
            .minutes(5, maxAttempts: 5),   // 5 attempts per 5 minutes
            .hours(24, maxAttempts: 20)    // 20 attempts per day
        ],
        backoffMultiplier: 2.0
    )
    
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
                
                @Dependency(\.request) var request
                
                let ipAddress = request?.realIP ?? "unknown"
                
                do {

                    // Check both email and IP limits
                    let emailResult = await emailLimiter.checkLimit(.email(email))
                    let ipResult = await ipLimiter.checkLimit(.ip(ipAddress))

                    logger.info("Rate limit check results - Email attempts: \(emailResult.currentAttempts), IP attempts: \(ipResult.currentAttempts)")

                    if !emailResult.isAllowed {
                        throw Abort(.tooManyRequests, reason: "Too many subscription attempts from this email. Please try again later.")
                    }
                    
                    if !ipResult.isAllowed {
                        throw Abort(.tooManyRequests, reason: "Too many subscription attempts from this IP. Please try again later.")
                    }
                    
                    try await client.subscribe.request(.init(email))
                    
                    await emailLimiter.recordSuccess(.email(email))
                    await ipLimiter.recordSuccess(.ip(ipAddress))
                    
                    @Dependency(\.envVars.appEnv) var appEnv
                    
                    let cookieValue = HTTPCookies.Value(
                        string: "true",
                        expires: .distantFuture,
                        maxAge: nil,
                        isSecure: appEnv == .production ? true : false,
                        isHTTPOnly: false,
                        sameSite: .strict
                    )
                    
                    let response = Response.json(success: true, message: "Successfully subscribed")
                    response.cookies[cookieId] = cookieValue
                    return response
                }
                catch let error as ValidationError {
                    switch error {
                    case .tooManyAttempts:
                        await emailLimiter.recordFailure(.email(email))
                        await ipLimiter.recordFailure(.ip(ipAddress))
                        throw Abort(.tooManyRequests, reason: "Too many subscription attempts. Please try again later.")
                    default:
                        throw error
                    }
                }
                catch {
                    await emailLimiter.recordFailure(.email(email))
                    await ipLimiter.recordFailure(.ip(ipAddress))
                    logger.error("Subscription failed: \(error)")
                    throw Abort(.internalServerError, reason: "Failed to process subscription. Please try again later.")
                }
                
            case .verify(let verify):
                logger.info("Processing verification request for email: \(verify.email) with token: \(verify.token)")
                
                do {
                    
                    @Dependency(\.request) var request
                    
                    let ipAddress = request?.realIP ?? "unknown"
                    
                    // Check both email and IP limits for verification
                    let emailResult = await emailLimiter.checkLimit(.email(verify.email))
                    let ipResult = await ipLimiter.checkLimit(.ip(ipAddress))
                    
                    if !emailResult.isAllowed || !ipResult.isAllowed {
                        throw Abort(.tooManyRequests, reason: "Too many verification attempts. Please try again later.")
                    }
                    
                    try await client.subscribe.verify(verify.token, verify.email)
                    
                    // Record success
                    await emailLimiter.recordSuccess(.email(verify.email))
                    await ipLimiter.recordSuccess(.ip(ipAddress))
                    
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

