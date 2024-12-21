//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 06/10/2024.
//

import Foundation
import Vapor
import JWT
import Dependencies
import DependenciesMacros

public struct JWTTokenPayload<JWTTokenPayloadData: Codable & Sendable> {
    
    public let sub: SubjectClaim
    public let exp: ExpirationClaim
    public let iat: IssuedAtClaim
    public let jti: IDClaim
    
    public let data: JWTTokenPayloadData?
    
    
    public init(
        sub: SubjectClaim,
        exp: ExpirationClaim,
        iat: IssuedAtClaim,
        jti: IDClaim,
        data: JWTTokenPayloadData?
    ) {
        self.sub = sub
        self.exp = exp
        self.iat = iat
        self.jti = jti
        self.data = data
    }
}

struct EmptyJWTTokenPayloadData: Codable, Sendable {}

extension JWTTokenPayload: JWTPayload {
    public func verify(using algorithm: some JWTKit.JWTAlgorithm) async throws {
        try exp.verifyNotExpired()
    }
}

extension JWTTokenPayload {
    var subjectClaim: SubjectClaim { sub }
    var expirationClaim: ExpirationClaim { exp }
    var issuedAtClaim: IssuedAtClaim { iat }
    var idClaim: IDClaim { jti }
}

@DependencyClient
public struct JWTService<JWTTokenPayloadData: Codable & Sendable>: Sendable {
    public var sign: @Sendable (JWTTokenPayload<JWTTokenPayloadData>) async throws -> String
    public var verify: @Sendable (String) async throws -> JWTTokenPayload<JWTTokenPayloadData>
}

//
//extension JWTService {
//    enum Key: DependencyKey {
//        static let liveValue: JWTService = {
//            let keyCollection: JWTKeyCollection = .init()
//            
//            // 'await' in a function that does not support concurrency
//            // if we remove this .add call, the code compiles.
//            await keyCollection.add(hmac: "secret", digestAlgorithm: .sha256)
//            
//            return JWTService(
//                sign: { payload in
//                    return try await keyCollection.sign(payload)
//                },
//                verify: { token in
//                    return try await keyCollection.verify(token)
//                }
//            )
//        }()
//    }
//}

 

// Define a custom error type if needed
enum JWTError: Error {
    case signingFailed
    case verificationFailed
}
//
//// MARK: - JWTService Dependency Value
//
//extension DependencyValues {
//    public var jwtService: JWTService {
//        get { self[JWTServiceKey.self] }
//        set { self[JWTServiceKey.self] = newValue }
//    }
//}
//
//// MARK: - Usage Example
//
//public func issueReauthTokenHandler(request: Request) async throws -> String {
//    @Dependency(\.jwtService) var jwtService
//    
//    guard let user = request.auth.get(Identity.self) else {
//        throw Abort(.unauthorized)
//    }
//    
//    let payload = jwtService.generateReauthorizationPayload(try user.requireID())
//    return try await jwtService.sign(payload)
//}
//
//public func verifyReauthTokenHandler(request: Request) async throws -> HTTPStatus {
//    @Dependency(\.jwtService) var jwtService
//    
//    guard let token = request.headers.bearerAuthorization?.token else {
//        throw Abort(.unauthorized)
//    }
//    
//    let payload = try await jwtService.verify(token)
//    
//    guard case .reauthorization = payload.variant else {
//        throw Abort(.unauthorized, reason: "Invalid token type")
//    }
//    
//    // Additional checks can be performed here
//    
//    return .ok
//}
//
//// MARK: - Vapor Application Extension
//
//extension Application {
//    public var jwt: JWTService {
//        .init(
//            sign: { payload in
//                try self.jwt.signers.sign(payload)
//            },
//            verify: { token in
//                try self.jwt.signers.verify(token, as: JWTTokenPayload.self)
//            },
//            generateReauthorizationPayload: { userId in
//                JWTTokenPayload(
//                    sub: .init(value: userId.uuidString),
//                    exp: .init(value: Date().addingTimeInterval(600)), // 10 minutes
//                    iat: .init(value: Date()),
//                    jti: .init(value: UUID().uuidString),
//                    variant: .reauthorization(userID: userId)
//                )
//            }
//        )
//    }
//}
