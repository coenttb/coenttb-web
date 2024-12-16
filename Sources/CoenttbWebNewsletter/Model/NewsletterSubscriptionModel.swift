//
//  File.swift
//  tenthijeboonkkamp-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 05/09/2024.
//

import Fluent
import FluentKit
import Foundation
import Vapor
import CoenttbWebUtils

public final class Newsletter: Model, @unchecked Sendable {
    public static let schema = "newsletter_subscriptions"

    @ID(key: .id)
    public var id: UUID?

    @Field(key: FieldKeys.email.rawValue)
    var email: String

    @Timestamp(key: Newsletter.FieldKeys.createdAt.rawValue, on: .create)
    var createdAt: Date?

    public init() { }
    
    public init(id: UUID? = nil, email: String) throws {
        self.id = id
        do {
            if try Bool.isValidEmail(email) {
                self.email = email
            } else {
                throw EmailValidationError.invalidEmailFormat
            }
        } catch {
            throw error
        }
    }
}

extension Newsletter {
    enum FieldKeys: FieldKey {
        case id
        case email
        case createdAt = "created_at"
    }
}

public struct CreateNewsletter: AsyncMigration {

    public init() {}

    public func prepare(on database: Database) async throws {
        try await database.schema(Newsletter.schema)
            .id()
            .field(Newsletter.FieldKeys.email.rawValue, .string, .required)
            .field(Newsletter.FieldKeys.createdAt.rawValue, .datetime)
            .unique(on: Newsletter.FieldKeys.email.rawValue)
            .create()
    }

    public func revert(on database: Database) async throws {
        try await database.schema(Newsletter.schema).delete()
    }
}
