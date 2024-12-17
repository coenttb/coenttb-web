// swift-tools-version:6.0

import Foundation
import PackageDescription

extension String {
    static let coenttbEnvVars: Self = "CoenttbEnvVars"
    static let coenttbWebHTML: Self = "CoenttbWebHTML"
    static let coenttbWebDependencies: Self = "CoenttbWebDependencies"
    static let coenttbWebModels: Self = "CoenttbWebModels"
    static let coenttbTranslations: Self = "CoenttbWebTranslations"
    static let coenttbWebVapor: Self = "CoenttbVapor"
    static let coenttbWebDatabase: Self = "CoenttbWebDatabase"
    static let coenttbServerRouter: Self = "CoenttbServerRouter"
    static let coenttbWebUtils: Self = "CoenttbWebUtils"
    static let coenttbWebLegal: Self = "CoenttbWebLegal"
    static let coenttbWebNewsletter: Self = "CoenttbWebNewsletter"
    static let coenttbWebAccount: Self = "CoenttbWebAccount"
    static let coenttbWebAccountLive: Self = "CoenttbWebAccountLive"
    static let coenttbWebStripe: Self = "CoenttbWebStripe"
    static let coenttbWebStripeLive: Self = "CoenttbWebStripeLive"
    static let coenttbWebBlog: Self = "CoenttbWebBlog"
    static let coenttbWebSyndication: Self = "CoenttbWebSyndication"
    static let mailgun: Self = "Mailgun"
    static let gitHub: Self = "GitHub"
    static let hotjar: Self = "Hotjar"
    static let postgres: Self = "Postgres"
    static let googleAnalytics: Self = "GoogleAnalytics"
}

extension Target.Dependency {
    static var coenttbEnvVars: Self { .target(name: .coenttbEnvVars) }
    static var coenttbWebHTML: Self { .target(name: .coenttbWebHTML) }
    static var coenttbWebDependencies: Self { .target(name: .coenttbWebDependencies) }
    static var coenttbWebModels: Self { .target(name: .coenttbWebModels) }
    static var coenttbTranslations: Self { .target(name: .coenttbTranslations) }
    static var coenttbWebVapor: Self { .target(name: .coenttbWebVapor) }
    static var coenttbWebDatabase: Self { .target(name: .coenttbWebDatabase) }
    static var coenttbWebLegal: Self { .target(name: .coenttbWebLegal) }
    static var coenttbWebUtils: Self { .target(name: .coenttbWebUtils) }
    static var coenttbServerRouter: Self { .target(name: .coenttbServerRouter) }
    static var coenttbWebAccount: Self { .target(name: .coenttbWebAccount) }
    static var coenttbWebAccountLive: Self { .target(name: .coenttbWebAccountLive) }
    static var coenttbWebNewsletter: Self { .target(name: .coenttbWebNewsletter) }
    static var coenttbWebStripe: Self { .target(name: .coenttbWebStripe) }
    static var coenttbWebStripeLive: Self { .target(name: .coenttbWebStripeLive) }
    static var coenttbWebBlog: Self { .target(name: .coenttbWebBlog) }
    static var coenttbWebSyndication: Self { .target(name: .coenttbWebSyndication) }
    
    static var gitHub: Self { .target(name: .gitHub) }
    static var mailgun: Self { .target(name: .mailgun) }
    static var hotjar: Self { .target(name: .hotjar) }
    static var googleAnalytics: Self { .target(name: .googleAnalytics) }
    static var postgres: Self { .target(name: .postgres) }
}

extension Target.Dependency {
    static var appSecret: Self { .product(name: "AppSecret", package: "swift-web") }
    static var coenttbEmail: Self { .product(name: "CoenttbEmail", package: "coenttb-html") }
    static var casePaths: Self { .product(name: "CasePaths", package: "swift-case-paths") }
    static var databaseHelpers: Self { .product(name: "DatabaseHelpers", package: "swift-web") }
    static var dependencies: Self { .product(name: "Dependencies", package: "swift-dependencies") }
    static var dependenciesMacros: Self { .product(name: "DependenciesMacros", package: "swift-dependencies") }
    static var fluent: Self { .product(name: "Fluent", package: "fluent") }
    static var fluentPostgresDriver: Self { .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver") }
    static var language: Self { .product(name: "Languages", package: "swift-language") }
    static var swiftHtml: Self { .product(name: "HTML", package: "swift-html") }
    static var logging: Self { .product(name: "Logging", package: "swift-log") }
    static var codable: Self { .product(name: "MacroCodableKit", package: "macro-codable-kit") }
    static var memberwiseInit: Self { .product(name: "MemberwiseInit", package: "swift-memberwise-init-macro") }
    static var nioDependencies: Self { .product(name: "NIODependencies", package: "swift-web") }
    static var postgresKit: Self { .product(name: "PostgresKit", package: "postgres-kit") }
    static var coenttbHtml: Self { .product(name: "CoenttbHTML", package: "coenttb-html") }
    static var coenttbMarkdown: Self { .product(name: "CoenttbMarkdown", package: "coenttb-html") }
    static var tagged: Self { .product(name: "Tagged", package: "swift-tagged") }
    static var taggedMoney: Self { .product(name: "TaggedMoney", package: "swift-tagged") }
    static var urlRouting: Self { .product(name: "URLRouting", package: "swift-url-routing") }
    static var vapor: Self { .product(name: "Vapor", package: "vapor") }
    static var vaporRouting: Self { .product(name: "VaporRouting", package: "vapor-routing") }
    static var emailaddress: Self { .product(name: "EmailAddress", package: "swift-web") }
    static var urlFormCoding: Self { .product(name: "UrlFormCoding", package: "swift-web") }
    static var loggingDependencies: Self { .product(name: "LoggingDependencies", package: "swift-web") }
    static var web: Self { .product(name: "Web", package: "swift-web") }
    static var stripeKit: Self { .product(name: "StripeKit", package: "stripe-kit") }
    static var jwt: Self { .product(name: "JWT", package: "jwt") }
    static var sharing: Self { .product(name: "Sharing", package: "swift-sharing") }
    static var swiftDate: Self { .product(name: "Date", package: "swift-date") }
    static var decodableRequest: Self { .product(name: "DecodableRequest", package: "swift-web") }
    static var either: Self { .product(name: "Either", package: "swift-prelude") }
    static var foundationPrelude: Self { .product(name: "FoundationPrelude", package: "swift-web") }
    static var httpPipeline: Self { .product(name: "HttpPipeline", package: "swift-web") }
    static var urlFormEncoding: Self { .product(name: "UrlFormEncoding", package: "swift-web") }
}

let package = Package(
    name: "coenttb-web",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(name: .coenttbEnvVars, targets: [.coenttbEnvVars]),
        .library(name: .coenttbWebHTML, targets: [.coenttbWebHTML]),
        .library(name: .coenttbWebDependencies, targets: [.coenttbWebDependencies]),
        .library(name: .coenttbWebModels, targets: [.coenttbWebModels]),
        .library(name: .coenttbTranslations, targets: [.coenttbTranslations]),
        .library(name: .coenttbWebVapor, targets: [.coenttbWebVapor]),
        .library(name: .coenttbWebDatabase, targets: [.coenttbWebDatabase]),
        .library(name: .coenttbWebUtils, targets: [.coenttbWebUtils]),
        .library(name: .coenttbWebLegal, targets: [.coenttbWebLegal]),
        .library(name: .coenttbServerRouter, targets: [.coenttbServerRouter]),
        .library(name: .coenttbWebAccount, targets: [.coenttbWebAccount]),
        .library(name: .coenttbWebAccountLive, targets: [.coenttbWebAccountLive]),
        .library(name: .coenttbWebStripe, targets: [.coenttbWebStripe]),
        .library(name: .coenttbWebStripeLive, targets: [.coenttbWebStripeLive]),
        .library(name: .coenttbWebNewsletter, targets: [.coenttbWebNewsletter]),
        .library(name: .coenttbWebBlog, targets: [.coenttbWebBlog]),
        .library(name: .coenttbWebSyndication, targets: [.coenttbWebSyndication]),
        .library(name: .mailgun, targets: [.mailgun]),
        .library(name: .gitHub, targets: [.gitHub]),
        .library(name: .hotjar, targets: [.hotjar]),
        .library(name: .googleAnalytics, targets: [.googleAnalytics]),
        .library(name: .postgres, targets: [.postgres]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log", from: "1.5.0"),
        .package(url: "https://github.com/coenttb/swift-html", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-web", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-date", branch: "main"),
        .package(url: "https://github.com/coenttb/coenttb-html", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-language.git", branch: "main"),
        .package(url: "https://github.com/coenttb/macro-codable-kit.git", branch: "main"),
        .package(url: "https://github.com/gohanlon/swift-memberwise-init-macro", from: "0.3.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.1.5"),
        .package(url: "https://github.com/pointfreeco/swift-tagged.git", from: "0.10.0"),
        .package(url: "https://github.com/pointfreeco/swift-url-routing", from: "0.6.0"),
        .package(url: "https://github.com/pointfreeco/vapor-routing.git", from: "0.1.3"),
        .package(url: "https://github.com/pointfreeco/swift-sharing.git", from: "1.0.4"),
        .package(url: "https://github.com/pointfreeco/swift-case-paths.git", from: "1.5.6"),
        .package(url: "https://github.com/pointfreeco/swift-prelude.git", branch: "main"),
        .package(url: "https://github.com/vapor/postgres-kit", from: "2.12.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.8.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.7.2"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.102.1"),
        .package(url: "https://github.com/vapor/jwt.git", from: "5.0.0"),
        .package(url: "https://github.com/vapor-community/stripe-kit.git", from: "25.1.1"),
    ],
    targets: [
        .target(
            name: .coenttbWebAccount,
            dependencies: [
                .casePaths,
                .urlRouting,
                .vaporRouting,
                .dependencies,
                .memberwiseInit,
                .codable,
                .vapor,
                .dependenciesMacros,
                .coenttbWebHTML,
                .coenttbEmail,
                .coenttbWebUtils
            ]
        ),
        .target(
            name: .coenttbWebAccountLive,
            dependencies: [
                .casePaths,
                .urlRouting,
                .vaporRouting,
                .dependencies,
                .memberwiseInit,
                .codable,
                .vapor,
                .dependenciesMacros,
                .coenttbWebHTML,
                .coenttbWebStripe,
                .coenttbEmail,
                .coenttbWebAccount,
            ]
        ),
        .target(
            name: .coenttbWebNewsletter,
            dependencies: [
                .urlRouting,
                .vaporRouting,
                .dependencies,
                .memberwiseInit,
                .codable,
                .vapor,
                .dependenciesMacros,
                .coenttbWebHTML,
                .coenttbWebDatabase,
                .coenttbWebUtils,
            ]
        ),
        .target(
            name: .coenttbWebBlog,
            dependencies: [
                .urlRouting,
                .vaporRouting,
                .dependencies,
                .memberwiseInit,
                .codable,
                .vapor,
                .dependenciesMacros,
                .coenttbWebHTML,
                .coenttbWebModels,
                .swiftDate,
                
                // unsure whether this is correct, included to thread through the overlay view instead of introducting a generic.
                .coenttbWebNewsletter
            ],
            resources: [ .process("Resources") ]
        ),
        .target(
            name: .coenttbWebStripe,
            dependencies: [
                .urlRouting,
                .vaporRouting,
                .stripeKit,
                .dependencies,
                .memberwiseInit,
                .codable,
                .vapor,
                .dependenciesMacros,
                .coenttbWebHTML,
            ]
        ),
        .target(
            name: .coenttbWebStripeLive,
            dependencies: [
                .urlRouting,
                .vaporRouting,
                .stripeKit,
                .dependencies,
                .memberwiseInit,
                .codable,
                .vapor,
                .dependenciesMacros,
                .coenttbWebHTML,
                .coenttbWebStripe
            ]
        ),
        .target(
            name: .coenttbEnvVars,
            dependencies: [
                .appSecret,
                .coenttbWebModels,
                .dependencies,
                .gitHub,
                .language,
                .logging,
                .mailgun,
                .memberwiseInit,
                .tagged,
                .sharing
            ]
        ),
        .target(
            name: .coenttbWebSyndication,
            dependencies: [
                .swiftDate
            ]
        ),
        .target(
            name: .coenttbWebHTML,
            dependencies: [
                .coenttbMarkdown,
                .coenttbTranslations,
                .coenttbWebVapor,
                .dependencies,
                .language,
                .coenttbHtml,
                .vapor,
                .web,
                .swiftHtml,
                .mailgun
            ]
        ),
        .target(
            name: .coenttbWebLegal,
            dependencies: [
                .coenttbWebHTML,
                .coenttbMarkdown,
                .coenttbTranslations,
                .coenttbWebVapor,
                .dependencies,
                .language,
                .coenttbHtml,
                .vapor,
                .web,
                .swiftHtml,
                .mailgun
            ]
        ),
        .target(
            name: .coenttbWebDependencies,
            dependencies: [
                .coenttbWebModels,
                .dependencies,
                .fluent,
                .language,
                .memberwiseInit,
                .nioDependencies,
                .postgresKit,
                .vapor,
            ]
        ),
        .target(
            name: .coenttbWebUtils,
            dependencies: [
                .dependencies,
                .language
            ]
        ),
        .target(
            name: .coenttbWebModels,
            dependencies: [
                .dependencies,
                .dependenciesMacros,
                .emailaddress,
                .fluent,
                .memberwiseInit,
                .tagged,
                .vapor,
                .jwt,
                .casePaths
            ]
        ),
        .target(
            name: .coenttbTranslations,
            dependencies: [
                .language
            ]
        ),
        .target(
            name: .coenttbWebVapor,
            dependencies: [
                .coenttbWebDependencies,
                .memberwiseInit,
                .loggingDependencies,
                .coenttbHtml,
                .vapor,
                .vaporRouting,
                .coenttbServerRouter,
                .coenttbEnvVars,
                .coenttbWebSyndication
            ]
        ),
        .target(
            name: .coenttbWebDatabase,
            dependencies: [
                .dependencies,
                .dependenciesMacros,
                .fluent,
                .fluentPostgresDriver,
                .databaseHelpers,
                .loggingDependencies,
                .postgresKit,
                .language,
                .emailaddress
            ]
        ),
        .target(
            name: .coenttbServerRouter,
            dependencies: [
                .casePaths,
                .coenttbTranslations,
                .coenttbWebDependencies,
                .urlFormCoding,
                .urlRouting,
                .coenttbWebModels,
            ]
        ),
        .target(
            name: .gitHub,
            dependencies: [
                .decodableRequest,
                .dependencies,
                .dependenciesMacros,
                .either,
                .foundationPrelude,
                .logging,
                .memberwiseInit,
                .tagged,
                .emailaddress,
            ]
        ),
        .target(
            name: .mailgun,
            dependencies: [
                .appSecret,
                .decodableRequest,
                .dependencies,
                .dependenciesMacros,
                .either,
                .emailaddress,
                .foundationPrelude,
                .httpPipeline,
                .logging,
                .loggingDependencies,
                .memberwiseInit,
                .tagged,
                .urlFormEncoding,
            ]
        ),
        .target(
            name: .hotjar,
            dependencies: [
                .memberwiseInit,
            ]
        ),
        .target(
            name: .googleAnalytics,
            dependencies: [
                .memberwiseInit,
            ]
        ),
        .target(
            name: .postgres,
            dependencies: [
                .memberwiseInit,
            ]
        ),
        .testTarget(
            name: .coenttbWebVapor + " Tests",
            dependencies: [
                .coenttbWebVapor
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)
