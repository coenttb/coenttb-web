//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 04-01-2024.
//

import Dependencies
@preconcurrency import Fluent
@preconcurrency import FluentKit
import Foundation
@preconcurrency import PostgresKit

extension DependencyValues {
    public var sqlConfiguration: SQLPostgresConfiguration {
        get { self[SQLPostgresConfigurationKey.self] }
        set { self[SQLPostgresConfigurationKey.self] = newValue }
    }
}

public enum SQLPostgresConfigurationKey: TestDependencyKey {
    public static var testValue: SQLPostgresConfiguration {
        fatalError()
    }
}

extension SQLPostgresConfiguration {
    public static func liveValue(
        emergencyMode: Bool,
        postgresDatabaseUrl: String
    ) -> Self {
        guard !emergencyMode
        else { fatalError() }
        
        var sqlConfiguration = try! SQLPostgresConfiguration(url: postgresDatabaseUrl)
        
        if postgresDatabaseUrl.contains("amazonaws.com") {
            var tlsConfig: TLSConfiguration = .makeClientConfiguration()
            tlsConfig.certificateVerification = .none
            
            let nioSSLContext = try? NIOSSLContext(configuration: tlsConfig)
            
            sqlConfiguration.coreConfiguration.tls = nioSSLContext.map { .require($0) } ?? .disable
        }
        
        return sqlConfiguration
    }
}
