import Dependencies
import DependenciesMacros
import EmailAddress
import Foundation
import Logging
import Tagged
import DatabaseHelpers
@preconcurrency import Fluent
import Vapor
import Languages

//public struct Migration {
//    public let migration: any AsyncMigration
//    public let databaseID: DatabaseID?
//
//    public init(migration: any AsyncMigration, databaseID: DatabaseID? = nil) {
//        self.migration = migration
//        self.databaseID = databaseID
//    }
//
//    public init(
//        prepare: @Sendable @escaping (_ database: FluentKit.Database) async throws -> Void,
//        revert: ( @Sendable (_ database: FluentKit.Database) async throws -> Void)? = nil,
//        databaseID: DatabaseID? = nil
//    ) {
//        self = .init(
//            migration: Migration.Closure(prepare: prepare, revert: revert),
//            databaseID: databaseID
//        )
//    }
//
//    struct Closure: AsyncMigration {
//
//        var name: String = UUID().uuidString
//
//        let prepare: @Sendable (_ database: FluentKit.Database) async throws -> Void
//        let revert: (@Sendable (_ database: FluentKit.Database) async throws -> Void)?
//
//        func prepare(on database: FluentKit.Database) async throws {
//            try await prepare(database)
//        }
//
//        func revert(on database: FluentKit.Database) async throws {
//            if let revert { try await revert(database) }
//        }
//    }
//}


func isValidPassword(_ password: String) throws -> Bool {

#if !DEBUG
    let minLength = 8
    let maxLength = 64

    // Regular expression patterns
    let uppercasePattern = ".*[A-Z]+.*"
    let lowercasePattern = ".*[a-z]+.*"
    let digitPattern = ".*[0-9]+.*"
    let specialCharacterPattern = ".*[!&^%$#@()/]+.*"

    // Check password length
    if password.count < minLength {
        throw PasswordValidationError.tooShort(minLength: minLength)
    }
    if password.count > maxLength {
        throw PasswordValidationError.tooLong(maxLength: maxLength)
    }

    // Check for uppercase, lowercase, digit, and special character
    if !matches(pattern: uppercasePattern, in: password) {
        throw PasswordValidationError.missingUppercase
    }
    if !matches(pattern: lowercasePattern, in: password) {
        throw PasswordValidationError.missingLowercase
    }
    if !matches(pattern: digitPattern, in: password) {
        throw PasswordValidationError.missingDigit
    }
    if !matches(pattern: specialCharacterPattern, in: password) {
        throw PasswordValidationError.missingSpecialCharacter
    }

#endif

    return true
}




private func matches(pattern: String, in text: String) -> Bool {
    let regex = try? NSRegularExpression(pattern: pattern)
    let range = NSRange(location: 0, length: text.utf16.count)
    return regex?.firstMatch(in: text, options: [], range: range) != nil
}


public enum PasswordValidationError: Error, CustomStringConvertible {
    case tooShort(minLength: Int)
    case tooLong(maxLength: Int)
    case missingUppercase
    case missingLowercase
    case missingDigit
    case missingSpecialCharacter

    public var description: String {
        switch self {
        case .tooShort(let minLength):
            return TranslatedString(
                english: "Password must be at least \(minLength) characters long."
            ).description
        case .tooLong(let maxLength):
            return TranslatedString(
                english: "Password must be no more than \(maxLength) characters long."
            ).description
        case .missingUppercase:
            return TranslatedString(
                english: "Password must contain at least one uppercase letter."
            ).description
        case .missingLowercase:
            return TranslatedString(
                english: "Password must contain at least one lowercase letter."
            ).description
        case .missingDigit:
            return TranslatedString(
                english: "Password must contain at least one digit."
            ).description
        case .missingSpecialCharacter:
            return TranslatedString(
                english: "Password must contain at least one special character (e.g., !&^%$#@()/)."
            ).description
        }
    }
}