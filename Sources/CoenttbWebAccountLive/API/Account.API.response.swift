//
//  File.swift
//  tenthijeboonkkamp-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 10/09/2024.
//

import CoenttbVapor
import CoenttbWebAccount
import CoenttbWebHTML
import Dependencies
import Fluent
import Foundation
import Languages
import Mailgun

extension CoenttbWebAccount.API {
    public static func response<User: Encodable>(
        logoutRedirectURL: () async throws -> any AsyncResponseEncodable,
        account: CoenttbWebAccount.API,
        database: CoenttbWebAccount.Client<User>,
        userInit: (CoenttbWebAccount.API.Update) -> User?,
        reauthenticateForEmailChange: (_ password: String) async throws -> Void,
        reauthenticateForPasswordChange: (_ password: String) async throws -> Void
    ) async throws -> any AsyncResponseEncodable {
        switch account {
        case .create(let create):
            switch create {
            case .request(let request):
                do {
                    try await database.create(email: request.email, password: request.password)
                    return Response.success(true)
                } catch {
                    @Dependencies.Dependency(\.logger) var logger
                    logger.log(.critical, "Failed to create account. Error: \(String(describing: error))")

                    throw Abort(.internalServerError, reason: "Failed to create account")
                }
            case .verify(let verify):
                do {
                    try await database.verify(token: verify.token, email: verify.email)
                    return Response.success(true)
                } catch {
                    print(error)
                    return Response.success(false)
                }
            }

        case .update(let update):

            guard let user = try await database.update(userInit(update)) else {
                throw Abort(.notFound, reason: "Account not found")
            }
            
            return Response.success(true, data: user)

        case .delete(let delete):
            switch delete {
            case .request(let request):
                
                if request.reauthToken.isEmpty {
                    throw Abort(.unauthorized, reason: "Please re-authorize")
                }
                
                do {
                    try await database.delete.request(userId: UUID(uuidString: request.userId)!, deletionRequestedAt: Date.now)
                    return Response.success(true)
                } catch {
                    throw Abort(.internalServerError, reason: "Failed to delete")
                }
            case .cancel(let cancel):
                do {
                    try await database.delete.cancel(userId: .init(uuidString: cancel.userId)!)
                    return Response.success(true)
                } catch {
                    throw Abort(.internalServerError, reason: "Failed to delete")
                }
            }

        case .login(let login):
            do {
                try await database.login(email: login.email, password: login.password)
                return Response.success(true)
            } catch {
                throw Abort(.internalServerError, reason: "Failed to login")
            }

        case .logout:
            try await database.logout()
            return try await logoutRedirectURL()
            
        
        case let .password(password):
            switch password {
            case .reset(let reset):
                switch reset {
                case let .request(request):
                    do {
                        try await database.password.reset.request(email: request.email)
                        return Response.success(true)
                    } catch {
                        @Dependencies.Dependency(\.logger) var logger
                        logger.log(.error, "Failed to request password reset. Error: \(String(describing: error))")
                        throw Abort(.internalServerError, reason: "Failed to request password reset")
                    }
                case let .confirm(confirm):
                    do {
                        try await database.password.reset.confirm(
                            token: confirm.token,
                            newPassword: confirm.newPassword
                        )
                        
                        return Response.success(true)
                    } catch {
                        @Dependencies.Dependency(\.logger) var logger
                        logger.log(.error, "Failed to reset password. Error: \(String(describing: error))")
                        throw Abort(.internalServerError, reason: "Failed to reset password")
                    }
                }
            case .change(let change):
                switch change {
                case let .reauthorization(reauthorization):
                    do {
                        try await reauthenticateForPasswordChange(reauthorization.password)
                        return Response.success(true)
                    } catch {
                        @Dependencies.Dependency(\.logger) var logger
                        logger.log(.error, "Failed to reauthorize for password change. Error: \(String(describing: error))")
                        throw Abort(.unauthorized, reason: "Failed to reauthorize")
                    }
                case let .request(change: request):
                    do {
                        try await database.password.change.request(
                            currentPassword: request.currentPassword,
                            newPassword: request.newPassword
                        )
                        return Response.success(true)
                    } catch {
                        @Dependencies.Dependency(\.logger) var logger
                        logger.log(.error, "Failed to change password. Error: \(String(describing: error))")
                        throw Abort(.internalServerError, reason: "Failed to change password")
                    }
                }
            }
        case let .emailChange(emailChange):
            switch emailChange {
            case .reauthorization(let reauthorization):
                do {
                    try await reauthenticateForEmailChange(reauthorization.password)
                    
                    return Response.success(true)
                } catch {
                    return Response.success(false)
                }
            case .request(let request):
                do {
                    let _ = try await database.emailChange.request(
                        newEmail: request.newEmail
                    )
                    
                    return Response.success(true)

                } catch {
                    @Dependencies.Dependency(\.logger) var logger
                    logger.log(.error, "Failed to request email change. Error: \(String(describing: error))")
                    throw error
                }
            case .confirm(let confirm):
                do {
                    try await database.emailChange.confirm(
                        token: confirm.token
                    )
                    
                    @Dependencies.Dependency(\.logger) var logger
                    logger.log(.info, "Email change confirmed for new email: \(confirm.newEmail)")
                    
                    return Response.success(true)
                } catch {
                    @Dependencies.Dependency(\.logger) var logger
                    logger.log(.error, "Failed to confirm email change. Error: \(String(describing: error))")
                    throw Abort(.internalServerError, reason: "Failed to confirm email change")
                }
            }
        }
    }
}
