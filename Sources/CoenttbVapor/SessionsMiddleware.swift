//
//  SessionsMiddleware.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 16/10/2024.
//

import Foundation
import Vapor

extension SessionsMiddleware {
    public static func secure(
        driver: any SessionDriver,
        cookieName: String = "vapor-session",
        maxAge: Int = 604_800,
        isSecure: Bool = true
    ) -> SessionsMiddleware {
        return SessionsMiddleware(
            session: driver,
            configuration: .init(
                cookieName: cookieName
            ) { sessionId in
                return HTTPCookies.Value(
                    string: sessionId.string,
                    expires: Date().addingTimeInterval(Double(maxAge)),
                    maxAge: maxAge,
                    domain: nil,
                    path: "/",
                    isSecure: isSecure,
                    isHTTPOnly: true,
                    sameSite: .lax
                )
            }
        )
    }
}