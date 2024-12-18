//
//  File.swift
//  tenthijeboonkkamp-nl-server
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
    private static let subscriptionManager = SubscriptionManager()
    
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
                
                let isNewSubscription = await subscriptionManager.subscribe(email)
                
                let cookieValue = HTTPCookies.Value(
                    string: "true",
                    expires: .distantFuture,
                    maxAge: nil,
                    isSecure: false,
                    isHTTPOnly: false,
                    sameSite: .strict
                )
                
                if isNewSubscription {
                    do {
                        try await client.subscribe.request(.init(email))
                    } catch {
                        logger.error("Mailgun subscription failed: \(error)")
                        throw Abort(.internalServerError, reason: "Failed to send subscription email. Please contact support.")
                    }

                    let response = Response.json(success: true, message: "Successfully subscribed")

                    response.cookies[cookieId] = cookieValue
                    
                    return response
                                    
                } else {
                    let response = Response.json(success: true, message: "Already subscribed")
                    response.cookies[cookieId] = cookieValue
                    return response
                }
            case .verify(let verify):
                print("Hello")
                fatalError()
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

