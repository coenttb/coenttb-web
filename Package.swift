// swift-tools-version:6.0

import Foundation
import PackageDescription

extension String {
    static let coenttbWeb: Self = "CoenttbWeb"
    static let coenttbServerRouter: Self = "CoenttbServerRouter"
    static let coenttbWebEnvVars: Self = "CoenttbWebEnvVars"
    static let coenttbWebHTML: Self = "CoenttbWebHTML"
    static let coenttbWebDependencies: Self = "CoenttbWebDependencies"
    static let coenttbWebModels: Self = "CoenttbWebModels"
    static let coenttbWebTranslations: Self = "CoenttbWebTranslations"
    static let coenttbWebVapor: Self = "CoenttbVapor"
    static let coenttbWebDatabase: Self = "CoenttbWebDatabase"
    static let coenttbWebUtils: Self = "CoenttbWebUtils"
    static let coenttbWebLegal: Self = "CoenttbWebLegal"
}

extension Target.Dependency {
    static var coenttbWeb: Self { .target(name: .coenttbWeb) }
    static var coenttbWebEnvVars: Self { .target(name: .coenttbWebEnvVars) }
    static var coenttbWebHTML: Self { .target(name: .coenttbWebHTML) }
    static var coenttbWebDependencies: Self { .target(name: .coenttbWebDependencies) }
    static var coenttbWebModels: Self { .target(name: .coenttbWebModels) }
    static var coenttbWebTranslations: Self { .target(name: .coenttbWebTranslations) }
    static var coenttbWebVapor: Self { .target(name: .coenttbWebVapor) }
    static var coenttbWebDatabase: Self { .target(name: .coenttbWebDatabase) }
    static var coenttbWebLegal: Self { .target(name: .coenttbWebLegal) }
    static var coenttbWebUtils: Self { .target(name: .coenttbWebUtils) }
    static var coenttbServerRouter: Self { .target(name: .coenttbServerRouter) }
}

extension Target.Dependency {
    static var environmentVariables: Self { .product(name: "EnvironmentVariables", package: "swift-environment-variables") }
    static var swiftWeb: Self { .product(name: "SwiftWeb", package: "swift-web") }
    static var coenttbEmail: Self { .product(name: "CoenttbEmail", package: "coenttb-html") }
    static var coenttbHtml: Self { .product(name: "CoenttbHTML", package: "coenttb-html") }
    static var coenttbMarkdown: Self { .product(name: "CoenttbMarkdown", package: "coenttb-html") }
    static var casePaths: Self { .product(name: "CasePaths", package: "swift-case-paths") }
    static var fluent: Self { .product(name: "Fluent", package: "fluent") }
    static var rateLimiter: Self { .product(name: "RateLimiter", package: "coenttb-utils") }
    static var language: Self { .product(name: "Languages", package: "swift-language") }
    static var postgresKit: Self { .product(name: "PostgresKit", package: "postgres-kit") }
    static var vapor: Self { .product(name: "Vapor", package: "vapor") }
    static var vaporRouting: Self { .product(name: "VaporRouting", package: "vapor-routing") }
    static var fluentPostgresDriver: Self { .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver") }
    static var issueReporting: Self { .product(name: "IssueReporting", package: "xctest-dynamic-overlay") }
}

let package = Package(
    name: "coenttb-web",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(name: .coenttbWeb, targets: [.coenttbWeb]),
        .library(name: .coenttbWebEnvVars, targets: [.coenttbWebEnvVars]),
        .library(name: .coenttbWebHTML, targets: [.coenttbWebHTML]),
        .library(name: .coenttbWebDependencies, targets: [.coenttbWebDependencies]),
        .library(name: .coenttbWebModels, targets: [.coenttbWebModels]),
        .library(name: .coenttbWebTranslations, targets: [.coenttbWebTranslations]),
        .library(name: .coenttbWebVapor, targets: [.coenttbWebVapor]),
        .library(name: .coenttbWebDatabase, targets: [.coenttbWebDatabase]),
        .library(name: .coenttbWebUtils, targets: [.coenttbWebUtils]),
        .library(name: .coenttbWebLegal, targets: [.coenttbWebLegal]),
        .library(name: .coenttbServerRouter, targets: [.coenttbServerRouter]),
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/swift-html", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-web", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-date", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-html", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-utils.git", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-language.git", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-environment-variables.git", branch: "main"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.1.5"),
        .package(url: "https://github.com/pointfreeco/swift-tagged.git", from: "0.10.0"),
        .package(url: "https://github.com/pointfreeco/swift-url-routing", from: "0.6.0"),
        .package(url: "https://github.com/pointfreeco/vapor-routing.git", from: "0.1.3"),
        .package(url: "https://github.com/pointfreeco/swift-sharing.git", from: "1.0.4"),
        .package(url: "https://github.com/pointfreeco/swift-case-paths.git", from: "1.5.6"),
        .package(url: "https://github.com/pointfreeco/swift-prelude.git", branch: "main"),
        .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay.git", from: "1.4.3"),
        .package(url: "https://github.com/vapor/postgres-kit", from: "2.12.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.8.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.7.2"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.102.1"),
    ],
    targets: [
        
        .target(
            name: .coenttbWeb,
            dependencies: [
                .coenttbHtml,
                .coenttbMarkdown,
                .coenttbServerRouter,
                .swiftWeb,
                .coenttbEmail,
                .coenttbWebEnvVars,
                .coenttbWebHTML,
                .coenttbWebDependencies,
                .coenttbWebModels,
                .coenttbWebTranslations,
                .coenttbWebVapor,
                .coenttbWebDatabase,
                .coenttbWebLegal,
                .coenttbWebUtils,
                .rateLimiter,
                .vapor,
                .vaporRouting,
                .fluent,
                .fluentPostgresDriver,
                .issueReporting,
                .postgresKit,
            ]
        ),
        .target(
            name: .coenttbWebEnvVars,
            dependencies: [
                .swiftWeb,
                .coenttbWebModels,
                .environmentVariables,
            ]
        ),
        
            .target(
                name: .coenttbWebHTML,
                dependencies: [
                    .swiftWeb,
                    .coenttbHtml,
                    .coenttbMarkdown,
                    .coenttbWebTranslations,
                ]
            ),
        .target(
            name: .coenttbWebLegal,
            dependencies: [
                .swiftWeb,
                .coenttbWebHTML,
                .coenttbMarkdown,
                .coenttbWebTranslations,
                .coenttbHtml,
                .vapor,
            ]
        ),
        .target(
            name: .coenttbWebDependencies,
            dependencies: [
                .swiftWeb,
                .coenttbWebModels,
                .fluent,
                .postgresKit,
                .vapor,
                .issueReporting,
            ]
        ),
        .target(
            name: .coenttbWebUtils,
            dependencies: [
                .swiftWeb
            ]
        ),
        .target(
            name: .coenttbWebModels,
            dependencies: [
                .swiftWeb,
                .fluent,
            ]
        ),
        .target(
            name: .coenttbWebTranslations,
            dependencies: [
                .language
            ]
        ),
        .target(
            name: .coenttbWebVapor,
            dependencies: [
                .swiftWeb,
                .coenttbWebDependencies,
                .coenttbServerRouter,
                .coenttbWebEnvVars,
                .vapor,
                .vaporRouting,
                .rateLimiter
            ]
        ),
        .target(
            name: .coenttbWebDatabase,
            dependencies: [
                .swiftWeb,
                .fluent,
                .fluentPostgresDriver,
            ]
        ),
        .target(
            name: .coenttbServerRouter,
            dependencies: [
                .language,
                .swiftWeb,
                .coenttbWebTranslations,
                .coenttbWebDependencies,
                .coenttbWebModels,
                .casePaths,
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
