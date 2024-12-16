//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 16/10/2024.
//

import CoenttbWebDatabase
import EmailAddress
import Foundation
import Mailgun
import CoenttbWebHTML

extension Client {
    public static func live(
        database: Fluent.Database,
        logger: Logger,
        notifyOfNewSubscriptionEmail: ((_ addres: String) -> Email)?,
        sendEmail: ( @Sendable (Email) async throws -> SendEmailResponse)?
    ) -> Self {
        return .init(
            subscribe: { emailAddress in
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
            unsubscribe: { emailAddress in
                try await Newsletter.query(on: database)
                    .filter(\.$email == emailAddress.rawValue)
                    .delete()
            }
        )
    }
}
