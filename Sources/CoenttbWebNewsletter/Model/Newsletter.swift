//
//  File.swift
//  tenthijeboonkkamp-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 05/09/2024.
//


import Dependencies
@preconcurrency import Fluent
import Foundation
import Tagged
@preconcurrency import Vapor
import CoenttbWebUtils

public final class Newsletter: Model, @unchecked Sendable {
    public static let schema = "newsletter_subscriptions"

    @ID(key: .id)
    public var id: UUID?

    @Field(key: Newsletter.FieldKeys.email)
    var email: String

    @Field(key: Newsletter.FieldKeys.emailVerificationStatus)
    public var emailVerificationStatus: EmailVerificationStatus
    
    @Timestamp(key: Newsletter.FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    public var updatedAt: Date?
    

    public init() { }
    
    public init(
        id: UUID? = nil,
        email: String,
        emailVerificationStatus: EmailVerificationStatus = .unverified
    ) throws {
        self.id = id
        do {
            if try Bool.isValidEmail(email) {
                self.email = email
                self.emailVerificationStatus = emailVerificationStatus
            } else {
                throw EmailValidationError.invalidEmailFormat
            }
        } catch {
            throw error
        }
    }
    
    enum FieldKeys {
        public static let email: FieldKey = "email"
        public static let emailVerificationStatus: FieldKey = "email_verification_status"
        public static let createdAt: FieldKey = "created_at"
        public static let updatedAt: FieldKey = "updated_at"
    }
}

extension Newsletter {
    public enum EmailVerificationStatus: String, Codable, Sendable {
        case unverified
        case pending
        case verified
        case failed
    }
}

extension Newsletter {
    public func generateToken(type: Newsletter.Token.TokenType, validUntil: Date? = nil) throws -> Newsletter.Token {
        try .init(
            newsletter: self,
            type: type,
            validUntil: validUntil
        )
    }
}

extension Newsletter {
    public func canGenerateToken(on db: Database) async throws -> Bool {
        guard let id = self.id else { return false }
        
        let recentTokens = try await Newsletter.Token.query(on: db)
            .filter(\.$newsletter.$id == id)
            .filter(\.$createdAt >= Date().addingTimeInterval(-Newsletter.Token.generationWindow))
            .count()

        return recentTokens < Newsletter.Token.generationLimit
    }
}


extension Newsletter {
    public enum Migration {
        public struct Create: AsyncMigration {
            
            public init() {}
            
            public func prepare(on database: Database) async throws {
                try await database.schema(Newsletter.schema)
                    .id()
                    .field(Newsletter.FieldKeys.email, .string, .required)
                    .field(Newsletter.FieldKeys.createdAt, .datetime)
                    .unique(on: Newsletter.FieldKeys.email)
                    .create()
            }
            
            public func revert(on database: Database) async throws {
                try await database.schema(Newsletter.schema).delete()
            }
        }
        
        public struct STEP_1_AddUpdatedAt: AsyncMigration {
            
            public init() {}
            
            public func prepare(on database: Database) async throws {
                try await database.schema(Newsletter.schema)
                    .field(Newsletter.FieldKeys.updatedAt, .datetime)
                    .update()
            }
            
            public func revert(on database: Database) async throws {
                try await database.schema(Newsletter.schema)
                    .deleteField(Newsletter.FieldKeys.updatedAt)
                    .update()
            }
        }
        
        public struct STEP_2_AddEmailVerification: AsyncMigration {
            
            public init() {}
            
            public func prepare(on database: Database) async throws {
                try await database.schema(Newsletter.schema)
                    .field(FieldKeys.emailVerificationStatus, .string, .required, .custom("DEFAULT \(EmailVerificationStatus.unverified.rawValue)"))
                    .update()
            }
            
            public func revert(on database: Database) async throws {
                try await database.schema(Newsletter.schema)
                    .deleteField(FieldKeys.emailVerificationStatus)
                    .update()
            }
        }
    }
}
