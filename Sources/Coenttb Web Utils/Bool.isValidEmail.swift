//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 05/10/2024.
//

import Foundation
import Dependencies
import Translating

extension Bool {
    public static func isValidEmail(_ email: String) throws(EmailValidationError) -> Bool {
        if email.range(of: String.emailRegularExpression, options: [.regularExpression, .caseInsensitive]) != nil {
            return true
        } else {
            throw EmailValidationError.invalidEmailFormat
        }
    }
}

public enum EmailValidationError: Error, CustomStringConvertible, Sendable {
    case invalidEmailFormat
    
    public var description: String {
        switch self {
        case .invalidEmailFormat:
            return TranslatedString(
                dutch: "Het e-mailadres heeft een ongeldig formaat.",
                english: "The email address format is invalid."
            ).description
        }
    }
}
