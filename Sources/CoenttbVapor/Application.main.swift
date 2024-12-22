//
//  Application.main.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 22/08/2024.
//

import Foundation
import Vapor
import Dependencies
import CoenttbWebDependencies

extension Application {
    public static func main(
        application: Vapor.Application,
        environment: Vapor.Environment,
        logLevel: Logger.Level,
        configure: (Application) async throws -> Void
    ) async throws {
        do {
            try await withDependencies {
                $0.application = application
            } operation: {
                @Dependency(\.application) var application
                
                application.logger.info("Application starting with environment: \(environment)")
                
                application.middleware = .init()
                application.middleware.use(ErrorMiddleware.default(environment: application.environment))
                
                application.middleware.use { request, next in
                    let timer = RequestTimer()
                    do {
                        let response = try await next.respond(to: request)
                        
                        let message = [
                            "\(response.status.code)",
                            "\(timer.milliseconds)ms",
                            "\(request.method) \(request.url.string)",
                            "request-id=\(request.id)"
                        ]
                            .joined(separator: " | ")
                        
                        request.logger.log(
                            level: .info,
                            "\(message)"
                        )
                        
                        return response
                    } catch {
                        request.logger.log(
                            level: .error,
                            "\(request.method) \(request.url.string) -> ERROR [\(timer.milliseconds)ms]: \(error)",
                            metadata: ["request-id": .string(request.id)]
                        )
                        
                        throw error
                    }
                }
                
                try await configure(application)
                try await application.execute()
            }
        } catch {
            let logger = Logger(label: "CoenttbVapor.main")
            logger.error("Server.main level error: \(String(reflecting: error))")
            throw error
        }
    }
}

