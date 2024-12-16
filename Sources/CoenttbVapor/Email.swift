//
//  Email.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 14/12/2024.
//

import Foundation
import EmailAddress
import CoenttbEnvVars
import Mailgun
import Dependencies

extension Email {
    public static func notifyOfNewSubscription(
        companyName: String,
        companyEmail: EmailAddress,
        subscriberEmail: EmailAddress,
        domain: String
    ) -> Email {
        @Dependencies.Dependency(\.envVars.appEnv) var appEnv

        return Email.notifyOfNewSubscription(
            from: companyEmail,
            to: companyEmail,
            subscriberEmail: subscriberEmail,
            companyEmail: companyEmail,
            companyName: companyName,
            domain: domain
        )
    }
}

extension Email {
    public static func notifyOfNewSubscription(
        companyName: String,
        to: EmailAddress,
        companyEmail: EmailAddress,
        subscriberEmail: EmailAddress,
        domain: String
    ) -> Email {
        @Dependencies.Dependency(\.envVars.appEnv) var appEnv

        switch appEnv {
        case .production:
            return Mailgun.Email.notifyOfNewSubscription(
                from: companyEmail,
                to: to,
                subscriberEmail: subscriberEmail,
                companyEmail: companyEmail,
                companyName: companyName,
                domain: domain
            )
        default:
            return Mailgun.Email.notifyOfNewSubscription(
                from: EmailAddress("mailgun@\(domain)"),
                to: to,
                subscriberEmail: subscriberEmail,
                companyEmail: companyEmail,
                companyName: companyName,
                domain: domain
            )
        }
    }
}

