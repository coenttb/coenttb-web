//
//  File.swift
//  tenthijeboonkkamp-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 04/10/2024.
//

import EmailAddress
import Foundation
import CoenttbHTML
import Mailgun
import CoenttbEmail
import CoenttbWebTranslations

extension Email {
    public static func requestEmailVerification(
        verificationUrl: URL,
        businessName: String,
        supportEmail: String,
        from: String,
        to user: (name: String?, email: EmailAddress),
        primaryColor: HTMLColor
    ) -> Self {
        
        let html = TableEmailDocument(
            preheader: TranslatedString(
                dutch: "Verifiëer je emailadres voor Ten Thije Boonkkamp",
                english: "Verify your email for Ten Thije Boonkkamp"
            ).description
        ) {
            tr {
                td {
                    VStack(alignment: .leading) {
                        Header(3) {
                            TranslatedString(
                                dutch: "Verifiëer je emailadres",
                                english: "Verify your email address"
                            )
                        }
                        
                        Paragraph {
                            TranslatedString(
                                dutch: "Om de setup van je \(businessName) account te voltooien, bevestig alsjeblieft dat dit je e-mailadres is.",
                                english: "To continue setting up your \(businessName) account, please verify that this is your email address."
                            )
                        }
                        .padding(bottom: .extraSmall)
                        .fontSize(.body)
                        
                        Button(
                            tag: a,
                            background: primaryColor
                        ) {
                            TranslatedString(
                                dutch: "Verifieer e-mailadres",
                                english: "Verify email address"
                            )
                        }
                        .color(.primary.reverse())
                        .href(verificationUrl.absoluteString)
                        .padding(bottom: Length.medium)
                        
                        
                        Paragraph(.small) {
                            
                            TranslatedString(
                                dutch: "Om veiligheidsredenen verloopt deze verificatielink binnen 24 uur. ",
                                english: "This verification link will expire in 24 hours for security reasons. "
                            )
                            
                            TranslatedString(
                                dutch: "Als je deze aanvraag niet hebt gedaan, kun je deze e-mail negeren.",
                                english: "If you did not make this request, please disregard this email."
                            )
                            
                            br()
                            
                            TranslatedString(
                                dutch: "Voor hulp, neem contact op met ons op via \(supportEmail).",
                                english: "For help, contact us at \(supportEmail)."
                            )
                        }
                        .fontSize(.footnote)
                        .color(.secondary)
                    }
                    .padding(vertical: .small, horizontal: .medium)
                }
            }
        }
            .backgroundColor(.primary.reverse())
            
        
        
        let bytes: ContiguousArray<UInt8> = html.render()
        let string: String = String(decoding: bytes, as: UTF8.self)
        
        let subjectAdd = TranslatedString(
            dutch: "Verifieer je e-mailadres",
            english: "Verify your email address"
        )
        
        return .init(
            from: .init(rawValue: from),
            to: [
                user.name.map { name in "\(name) <\(user.email.rawValue)>" } ?? "\(user.email.rawValue)"
            ],
            subject: "\(businessName) | \(subjectAdd)",
            text: nil,
            html: string,
            domain: ""
        )
    }
}