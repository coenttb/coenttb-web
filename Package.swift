// swift-tools-version:6.0

import Foundation
import PackageDescription

extension String {
    static let coenttbWeb: Self = "Coenttb Web"
    static let coenttbWebEnvVars: Self = "Coenttb Web EnvVars"
    static let coenttbWebHTML: Self = "Coenttb Web HTML"
    static let coenttbWebDependencies: Self = "Coenttb Web Dependencies"
    static let coenttbWebModels: Self = "Coenttb Web Models"
    static let coenttbWebTranslations: Self = "Coenttb Web Translations"
    static let coenttbWebUtils: Self = "Coenttb Web Utils"
    static let coenttbWebLegal: Self = "Coenttb Web Legal"
}

extension Target.Dependency {
    static var coenttbWeb: Self { .target(name: .coenttbWeb) }
    static var coenttbWebEnvVars: Self { .target(name: .coenttbWebEnvVars) }
    static var coenttbWebHTML: Self { .target(name: .coenttbWebHTML) }
    static var coenttbWebDependencies: Self { .target(name: .coenttbWebDependencies) }
    static var coenttbWebModels: Self { .target(name: .coenttbWebModels) }
    static var coenttbWebTranslations: Self { .target(name: .coenttbWebTranslations) }
    static var coenttbWebLegal: Self { .target(name: .coenttbWebLegal) }
    static var coenttbWebUtils: Self { .target(name: .coenttbWebUtils) }
}

extension Target.Dependency {
    static var environmentVariables: Self { .product(name: "EnvironmentVariables", package: "swift-environment-variables") }
    static var swiftWeb: Self { .product(name: "SwiftWeb", package: "swift-web") }
    static var coenttbEmail: Self { .product(name: "CoenttbEmail", package: "coenttb-html") }
    static var coenttbHtml: Self { .product(name: "CoenttbHTML", package: "coenttb-html") }
    static var coenttbMarkdown: Self { .product(name: "CoenttbMarkdown", package: "coenttb-html") }
    static var casePaths: Self { .product(name: "CasePaths", package: "swift-case-paths") }
    static var language: Self { .product(name: "Languages", package: "swift-language") }
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
        .library(name: .coenttbWebUtils, targets: [.coenttbWebUtils]),
        .library(name: .coenttbWebLegal, targets: [.coenttbWebLegal]),
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/coenttb-html", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-environment-variables.git", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-language.git", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-web", branch: "main"),
    ],
    targets: [
        
        .target(
            name: .coenttbWeb,
            dependencies: [
                .coenttbHtml,
                .coenttbMarkdown,
                .swiftWeb,
                .coenttbEmail,
                .coenttbWebEnvVars,
                .coenttbWebHTML,
                .coenttbWebDependencies,
                .coenttbWebModels,
                .coenttbWebTranslations,
                .coenttbWebLegal,
                .coenttbWebUtils,
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
                    .coenttbWebDependencies,
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
            ]
        ),
        .target(
            name: .coenttbWebDependencies,
            dependencies: [
                .swiftWeb,
                .coenttbWebModels,
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
            ]
        ),
        .target(
            name: .coenttbWebTranslations,
            dependencies: [
                .language
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
