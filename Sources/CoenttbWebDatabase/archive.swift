//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 05/09/2024.
//





////
////  File.swift
////  coenttb-web
////
////  Created by Coen ten Thije Boonkkamp on 05/09/2024.
////
//
//import Dependencies
//@preconcurrency import Fluent
//import Languages
//import NIODependencies
//import NIOSSL
//import PostgresKit
//import ServerDependencies
//import ServerModels
//import ServerRouter
//import Tagged
//import Vapor
//
//extension DatabaseClient: DependencyKey {
//    public static var liveValue: Self {
//        @Dependency(\.eventLoopGroupConnectionPool) var eventLoopGroupConnectionPool
//        return .live(pool: eventLoopGroupConnectionPool)
//    }
//}
//
//extension DatabaseClient {
//    public static func live(
//        //        request: Request?,
//        pool: EventLoopGroupConnectionPool<PostgresConnectionSource>
//    ) -> Self {
//        return DatabaseClient(
//            add_user: { post in
//                @Dependency(\.request) var request
//                guard let request else { throw DatabaseError.noRequest1 }
//                let newUser = User(email: post.email, password: try Bcrypt.hash(post.password), name: post.name)
//                try await newUser.save(on: request.db)
//
//                let newUserKurkuma = try newUser.generateRule()
//                try await newUserKurkuma.save(on: request.db)
//                let token = try newUser.generateToken()
//                try await token.save(on: request.db)
//
//                return (try await .init(user: newUser), token.value)
//            },
//            authenticate: { email, password in
//                @Dependency(\.request) var request
//                guard let request
//                else { throw DatabaseError.noRequest2 }
//
//                guard let user: User = try await User.query(on: request.db)
//                    .filter(\.$email == email)
//                    .first()
//                else { throw AuthError.noUserFound1 }
//
//                print("987t438wendcujn")
//                do {
//
//                    guard try Bcrypt.verify(password, created: user.password)
//                    else { throw AuthError.cantVerifyPassword }
//
//                    guard user.isValidatedViaEmail
//                    else { throw AuthError.userNotEmailValidated }
//
//                    request.auth.login(user)
//
//                    return try request.auth.require(User.self)
//                } catch {
//                    throw AuthError.loginFailed
//                }
//            },
//            fetchUserById: { id in
//                @Dependency(\.request) var request
//                guard let request else { throw DatabaseError.noRequest3 }
//
//                guard let user: User = try await User.find(id, on: request.db)
//                else { throw UserError.notFound  }
//
//                let rule: User.Rule = try await user.rule()
//
//                return DTO.User(user: user, rule: rule)
//            },
//            logoutUser: {
//                @Dependency(\.request) var request
//                guard let request else { throw DatabaseError.noRequest4 }
//
//                request.auth.logout(User.self)
//            },
//            migrations: {
//                []
////                [
////                    .init(migration: User.SetupMigration()),
////                    .init(migration: UserToken.SetupMigration()),
////                    .init(migration: User.Rule.SetupMigration()),
////                    .init(migration: ResearchProjectModel.SetupMigration()),
////                    .init(migration: ResearchProjectModel.Pivot.SetupMigration()),
////                    .init(migration: FinancialRelation.SetupMigration())
////                ]
//            },
//            request_reset_password: { email in
//                @Dependency(\.request) var request
//                guard let request else { throw DatabaseError.noRequest4 }
//
//                guard let user = try await User.query(on: request.db)
//                    .filter(\.$email == email)
//                    .first() else {
//                    throw Abort(.notFound, reason: "User not found")
//                }
//
//                let tokenValue = UUID().uuidString.lowercased()
//                let token = UserToken(id: nil, value: tokenValue, userID: try user.requireID())
//                token.validUntil = Date().add(time: UserToken.validFor)
//
//                try await token.save(on: request.db)
//
//                return token.value
//            },
//            sawUser: { userId in
//                @Dependency(\.request) var request
//                guard let request else { throw DatabaseError.noRequest5 }
//
//                guard let user = try await User.find(userId, on: request.db)
//                else { throw AuthError.noUserFound2 }
//
//                try await User.query(on: request.db)
//                        .filter(\.$id == user.id!)
//                        .set(\.$updatedAt, to: .now)
//                        .update()
//
//                try await user.update(on: request.db)
//
//            },
//            updateUser: { userId, name, email, password, date_of_birth in
//                @Dependency(\.request) var request
//                guard let request else { throw DatabaseError.noRequest6 }
//
//                guard let user = try await User.find(userId, on: request.db)
//                else { throw AuthError.noUserFound3 }
//
//                user.name = name ?? user.name
//                user.email = email?.rawValue ?? user.email
//
//                if let password, try Bcrypt.verify(password.current, created: user.password) {
//                    user.password = try Bcrypt.hash(password.new)
//                }
//
//                let rule = try await User.Rule.query(on: request.db)
//                    .filter(\.$user.$id == user.id!)
//                    .first()
//                rule?.dateOfBirth = date_of_birth ?? rule?.dateOfBirth
//
//                try await user.update(on: request.db)
//
//                if let rule = rule {
//                    try await rule.update(on: request.db)
//                }
//
//                return user
//            },
//            verify: { id in
//                @Dependency(\.request) var request
//                guard let request else { throw DatabaseError.noRequest7 }
//
//                enum VerificationError: Error {
//                    case error
//                    case didntFindUser
//                    case didntFindToken
//                }
//
//                do {
//
//                    let token = try await UserToken.query(on: request.db)
//                        .filter(\.$value == id.lowercased())
//                        .with(\.$user)
//                        .first()
//
//                    guard let user = token?.user
//                    else { throw VerificationError.didntFindUser }
//
//                    user.isValidatedViaEmail = true
//                    try await user.save(on: request.db)
//                    try await token?.delete(on: request.db)
//                    request.auth.login(user)
//
//                    return user
//
//                } catch {
//                    throw VerificationError.didntFindToken
//                }
//            }
//        )
//    }
//}
//
//extension UserToken {
//    static let validFor: Date.Time = .minutes(15)
//}
//
//public enum UserError: Error {
//    case notFound
//    case ruleDetailsNotFound
//    case userTokenNotFound
//    case invalidOrExpiredToken
//    case invalidPassword
//}
//
//public enum DatabaseError: Error {
//    case couldnt_find_user
//    case couldnt_find_token
//    case noRequest
//    case noRequest1
//    case noRequest2
//    case noRequest3
//    case noRequest4
//    case noRequest5
//    case noRequest6
//    case noRequest7
//    case noRequest8
//    case noRequest9
//    case noRequest10
//}
//
//public enum AuthError: Error {
//    case noUserFound1
//    case noUserFound2
//    case noUserFound3
//    case userNotEmailValidated
//    case loginFailed
//    case cantVerifyPassword
//}
//
//extension User {
//    public func rule(
//    ) async throws -> User.Rule {
//        @Dependency(\.request) var request
//        guard let request else { throw DatabaseError.noRequest8 }
//
//        guard
//            let userId: UUID = self.id,
//            let rule: User.Rule = try await User.Rule.query(on: request.db)
//                .filter(\.$user.$id == userId)
//                .first()
//        else { throw UserError.ruleDetailsNotFound }
//
//        return rule
//    }
//}
//
//extension DatabaseClient {
//    public func authenticate(
//        post: SiteRoute.Page.Page.Registration.Post
//    ) async throws -> User {
//        try await self.authenticate(username: post.email, password: post.password )
//    }
//}
//
//extension DatabaseClient {
//    public func authenticate(
//        post: SiteRoute.Page.Page.Login.Post
//    ) async throws -> User {
//        return try await self.authenticate(username: post.username, password: post.password )
//    }
//}
//
//extension DatabaseClient {
//    public func resetPassword(
//        post: SiteRoute.Page.Page.Login.RequestPassword.Input.Post
//    ) async throws -> User {
//        @Dependency(\.request) var request
//        guard let request else { throw DatabaseError.noRequest }
//
//        guard
//            let token = try await UserToken.query(on: request.db)
//                .filter(\.$value == post.token)
//                .with(\.$user)
//                .first(),
//            token.isValid // Check if token is valid
//        else { throw UserError.invalidOrExpiredToken }
//
//        guard try isValidPassword(post.password) else { throw UserError.invalidPassword }
//
//        let user = token.user
//        user.password = try Bcrypt.hash(post.password)
//        try await user.save(on: request.db)
//
//        try await token.delete(on: request.db)
//        return user
//    }
//}
//
//enum PasswordValidationError: Error, CustomStringConvertible {
//    case tooShort(minLength: Int)
//    case tooLong(maxLength: Int)
//    case missingUppercase
//    case missingLowercase
//    case missingDigit
//    case missingSpecialCharacter
//
//    var description: String {
//        switch self {
//        case .tooShort(let minLength):
//            return TranslatedString(
//                english: "Password must be at least \(minLength) characters long."
//            ).description
//        case .tooLong(let maxLength):
//            return TranslatedString(
//                english: "Password must be no more than \(maxLength) characters long."
//            ).description
//        case .missingUppercase:
//            return TranslatedString(
//                english: "Password must contain at least one uppercase letter."
//            ).description
//        case .missingLowercase:
//            return TranslatedString(
//                english: "Password must contain at least one lowercase letter."
//            ).description
//        case .missingDigit:
//            return TranslatedString(
//                english: "Password must contain at least one digit."
//            ).description
//        case .missingSpecialCharacter:
//            return TranslatedString(
//                english: "Password must contain at least one special character (e.g., !&^%$#@()/)."
//            ).description
//        }
//    }
//}
//
//func isValidPassword(_ password: String) throws -> Bool {
//
//    #if !DEBUG
//    let minLength = 8
//    let maxLength = 64
//
//    // Regular expression patterns
//    let uppercasePattern = ".*[A-Z]+.*"
//    let lowercasePattern = ".*[a-z]+.*"
//    let digitPattern = ".*[0-9]+.*"
//    let specialCharacterPattern = ".*[!&^%$#@()/]+.*"
//
//    // Check password length
//    if password.count < minLength {
//        throw PasswordValidationError.tooShort(minLength: minLength)
//    }
//    if password.count > maxLength {
//        throw PasswordValidationError.tooLong(maxLength: maxLength)
//    }
//
//    // Check for uppercase, lowercase, digit, and special character
//    if !matches(pattern: uppercasePattern, in: password) {
//        throw PasswordValidationError.missingUppercase
//    }
//    if !matches(pattern: lowercasePattern, in: password) {
//        throw PasswordValidationError.missingLowercase
//    }
//    if !matches(pattern: digitPattern, in: password) {
//        throw PasswordValidationError.missingDigit
//    }
//    if !matches(pattern: specialCharacterPattern, in: password) {
//        throw PasswordValidationError.missingSpecialCharacter
//    }
//
//    #endif
//
//    return true
//}
//
//private func matches(pattern: String, in text: String) -> Bool {
//    let regex = try? NSRegularExpression(pattern: pattern)
//    let range = NSRange(location: 0, length: text.utf16.count)
//    return regex?.firstMatch(in: text, options: [], range: range) != nil
//}
//
//extension DatabaseClient {
//    public func updateUser(
//        id: DTO.User.ID,
//        post: SiteRoute.Page.Page.Account.Person.Post
//    ) async throws -> User {
//        return try await self.updateUser(
//            id: id,
//            name: post.name,
//            emailAddress: nil,
//            password: nil,
//            date_of_birth: post.date_of_birth
//        )
//    }
//}
//
//extension DatabaseClient {
//    public func fetchUser(
//        email: String
//    ) async throws -> DTO.User? {
//        @Dependency(\.request) var request
//        guard let request else { throw RequestError(1) }
//
//        guard let user = try await User.query(on: request.db)
//            .filter(\.$email == email)
//            .first()
//        else { throw RequestError(2) }
//
//        return try await .init(user: user)
//
//    }
//}
//
//extension DatabaseClient {
//    public func fetchToken(
//        id: Tagged<DTO.User, UUID>
//    ) async throws -> UserToken? {
//        @Dependency(\.request) var request
//        guard let request else { throw RequestError(3) }
//
//        return try await UserToken.query(on: request.db)
//            .filter(\.user.$id == id.rawValue)
//            .first()
//    }
//}
//
//extension DatabaseClient {
//    public func addFinancialRelation(
//        ontvangerID: UUID,
//        vergunninghouderID: UUID
//    ) async throws -> DTO.FinancialRelation {
//        @Dependency(\.request) var request
//
//        guard let request else { throw DatabaseError.noRequest1 }
//
//        let financialRelation = FinancialRelation(ontvangerID: ontvangerID, vergunninghouderID: vergunninghouderID)
//
//        try await financialRelation.save(on: request.db)
//
//        return try await .init(financialRelation)
//    }
//}
//
//extension DatabaseClient {
//    public func addResearchProject(
//        title: String?,
//        researchers: [DTO.User]?
//    ) async throws -> DTO.ResearchProjectModel {
//        @Dependency(\.request) var request
//        guard let request else { throw RequestError(4) }
//
//        let researchProject = ResearchProjectModel()
//
//        researchProject.title = title
//
//        try await researchProject.save(on: request.db)
//
//        if let researchers {
//            for researcher in researchers {
//                guard let rule = try await User.Rule.query(on: request.db)
//                    .filter(\.$user.$id == researcher.id.rawValue)
//                    .first()
//                else { throw Abort(.internalServerError) }
//
//                let pivot = ResearchProjectModel.Pivot(userID: rule.id!, researchProjectID: researchProject.id!)
//
//                try await pivot.save(on: request.db)
//            }
//        }
//
//        return try await .init(researchProject)
//
//    }
//}
//
//extension DatabaseClient {
//    public func add(
//        vergunninghouder: DTO.User,
//        to financialRelation: DTO.FinancialRelation?
//    ) async throws -> DTO.FinancialRelation {
//        @Dependency(\.request) var request
//        guard let request else { throw RequestError(13) }
//
//        guard financialRelation != nil
//        else {
//
//            guard let vergunninghouder = try await User.Rule.query(on: request.db)
//                .filter(\.$user.$id == vergunninghouder.id.rawValue)
//                .first()
//            else { throw Abort(.internalServerError) }
//
//            let financialRelation = try await self.addFinancialRelation(ontvangerID: vergunninghouder.id!, vergunninghouderID: vergunninghouder.id!)
//
//            guard let model = try await FinancialRelation.find(financialRelation.id.rawValue, on: request.db)
//            else { throw Abort(.notFound) }
//
//            model.$vergunninghouder.id = try vergunninghouder.requireID()
//
//            try await model.save(on: request.db)
//
//            return financialRelation
//        }
//
//        fatalError()
//    }
//}
//
//extension DatabaseClient {
//    public func delete(
//        researchProject: Tagged<DTO.ResearchProjectModel, UUID>
//    ) async throws {
//        @Dependency(\.request) var request
//        guard let request else { throw RequestError(5) }
//
//        guard let researchProjectModel = try await ResearchProjectModel.query(on: request.db)
//            .filter(\.$id == researchProject.rawValue)
//            .first()
//        else { throw RequestError(6) }
//
//        try await researchProjectModel.delete(on: request.db)
//
//    }
//}
//
//extension DatabaseClient {
//    public func fetchResearchProject(
//        id: Tagged<DTO.ResearchProjectModel, UUID>
//    ) async throws -> DTO.ResearchProjectModel? {
//        @Dependency(\.request) var request
//        guard let request else { throw RequestError(5) }
//
//        guard let researchProjectModel = try await ResearchProjectModel.query(on: request.db)
//            .filter(\.$id == id.rawValue)
//            .first()
//        else { throw RequestError(18) }
//        try await researchProjectModel.$researchers.load(on: request.db)
//
//        return try await .init(researchProjectModel)
//
//    }
//}
//
//extension DatabaseClient {
//    public func fetchFinancialRelation(
//        id: Tagged<DTO.FinancialRelation, UUID>
//    ) async throws -> DTO.FinancialRelation? {
//        @Dependency(\.request) var request
//        guard let request else { throw RequestError(7) }
//
//        guard let financialRelation = try await FinancialRelation.query(on: request.db)
//            .filter(\.$id == id.rawValue)
//            .first()
//        else { throw RequestError(8) }
//
////        try await financialRelation.$researchers.load(on: request.db)
//
//        return try await .init(financialRelation)
//
//    }
//}
//
//extension DatabaseClient {
//    fileprivate func fetchResearchProject(
//        id: UUID
//    ) async throws -> ResearchProjectModel? {
//        @Dependency(\.request) var request
//        guard let request else { throw RequestError(14) }
//
//        guard let researchProjectModel = try await ResearchProjectModel.find(id, on: request.db)
//        else { throw RequestError(9) }
//
//        return researchProjectModel
//
//    }
//}
//
//extension DatabaseClient {
//    public func updateResearchProject(
//        post: SiteRoute.Page.Page.Account.Person.PostUpdateResearchProject
//    ) async throws -> DTO.ResearchProjectModel? {
//        @Dependency(\.request) var request
//        guard let request else { throw RequestError(15) }
//
//        guard let researchProjectModel = try await fetchResearchProject(id: post.id)
//        else { throw RequestError(10) }
//
//        researchProjectModel.title = post.title
//
//        try await researchProjectModel.save(on: request.db)
//
//        return try await .init(researchProjectModel)
//
//    }
//}
//
//extension DatabaseClient {
//    public func updateResearchProject(
//        id: UUID,
//        facts: Facts
//    ) async throws -> DTO.ResearchProjectModel? {
//        @Dependency(\.request) var request
//        guard let request else { throw RequestError(11) }
//
//        guard let researchProjectModel = try await fetchResearchProject(id: id)
//        else { throw RequestError(12) }
//
//        researchProjectModel.facts = facts
//
//        try await researchProjectModel.save(on: request.db)
//
//        return try await .init(researchProjectModel)
//
//    }
//}
//
//extension DatabaseClient {
//    public func fetchResearchProjects(
//        id: DTO.User.ID
//    ) async throws -> [DTO.ResearchProjectModel]? {
//        @Dependency(\.request) var request
//        guard let request else { throw RequestError(17) }
//
//        guard let rule = try await User.Rule.query(on: request.db)
//            .filter(\.$user.$id == id.rawValue)
//            .first()
//        else { throw Abort(.internalServerError) }
//
//        let projects = try await ResearchProjectModel.query(on: request.db)
//            .join(ResearchProjectModel.Pivot.self, on: \ResearchProjectModel.Pivot.$researchProject.$id == \ResearchProjectModel.$id)
//            .filter(ResearchProjectModel.Pivot.self, \.$researcher.$id == rule.id!)
//            .all()
//
//        return try await projects.asyncMap { project in try await DTO.ResearchProjectModel(project) }
//    }
//}
//
//extension DatabaseClient {
//    public func fetchFinancialRelations(
//        id: DTO.User.ID
//    ) async throws -> [DTO.FinancialRelation]? {
//        @Dependency(\.request) var request
//        guard let request else { throw RequestError(16) }
//
//        guard let rule = try await User.Rule.query(on: request.db)
//            .filter(\.$user.$id == id.rawValue)
//            .first()
//        else { throw Abort(.internalServerError) }
//
//        let projects = try await FinancialRelation.query(on: request.db)
//            .filter(\.$vergunninghouder.$id == rule.id!)
//            .all()
//
//        return try await projects.asyncMap { project in try await DTO.FinancialRelation(project) }
//    }
//}
//
//extension DatabaseClient {
//    public func requestEmailVerification() async throws {
//
//    }
//}
//import Foundation
