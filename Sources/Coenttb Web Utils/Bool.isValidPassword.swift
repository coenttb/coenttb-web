//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 05/10/2024.
//

import Foundation
import Dependencies


extension Bool {
    public static func isValidPassword(_ password: String) throws(PasswordValidationError) -> Bool {
        let minLength = 8
        let maxLength = 128
        let specialCharacterPattern = #".*[!@#$%^&*()_+\-=[\]{}|;:'\",.<>?\\/`~]+.*"#
        
        if password.count < minLength {
            throw PasswordValidationError.tooShort(minLength: minLength)
        }
        
        if password.count > maxLength {
            throw PasswordValidationError.tooLong(maxLength: maxLength)
        }
        
        let complexityChecks = [
            (".*[A-Z]+.*", PasswordValidationError.missingUppercase),
            (".*[a-z]+.*", PasswordValidationError.missingLowercase),
            (".*[0-9]+.*", PasswordValidationError.missingDigit),
            (specialCharacterPattern, PasswordValidationError.missingSpecialCharacter)
        ]
        
        let passedChecks = complexityChecks.filter { matches(pattern: $0.0, in: password) }
        if passedChecks.count < 3 {
            throw PasswordValidationError.insufficientComplexity
        }
        
        return true
    }
    
    private static func matches(pattern: String, in text: String) -> Bool {
        return text.range(of: pattern, options: .regularExpression) != nil
    }
}

public enum PasswordValidationError: Error, CustomStringConvertible, Sendable {
    case tooShort(minLength: Int)
    case tooLong(maxLength: Int)
    case missingUppercase
    case missingLowercase
    case missingDigit
    case missingSpecialCharacter
    case insufficientComplexity
    
    public var description: String {
        switch self {
        case .tooShort(let minLength):
            return "Password must be at least \(minLength) characters long."
        case .tooLong(let maxLength):
            return "Password must be no more than \(maxLength) characters long."
        case .missingUppercase:
            return "Password must contain at least one uppercase letter."
        case .missingLowercase:
            return "Password must contain at least one lowercase letter."
        case .missingDigit:
            return "Password must contain at least one digit."
        case .missingSpecialCharacter:
            return "Password must contain at least one special character (e.g., !@#$%^&*)."
        case .insufficientComplexity:
            return "Password must meet at least three of the following: uppercase letter, lowercase letter, digit, special character."
        }
    }
}
