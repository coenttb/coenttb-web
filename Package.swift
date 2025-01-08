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
}

extension Target.Dependency {
    static var coenttbWeb: Self { .target(name: .coenttbWeb) }
    static var coenttbWebEnvVars: Self { .target(name: .coenttbWebEnvVars) }
    static var coenttbWebHTML: Self { .target(name: .coenttbWebHTML) }
    static var coenttbWebDependencies: Self { .target(name: .coenttbWebDependencies) }
    static var coenttbWebModels: Self { .target(name: .coenttbWebModels) }
    static var coenttbWebTranslations: Self { .target(name: .coenttbWebTranslations) }
    static var coenttbWebUtils: Self { .target(name: .coenttbWebUtils) }
}

extension Target.Dependency {
    static var environmentVariables: Self { .product(name: "EnvironmentVariables", package: "swift-environment-variables") }
    static var swiftWeb: Self { .product(name: "SwiftWeb", package: "swift-web") }
    static var coenttbEmail: Self { .product(name: "CoenttbEmail", package: "coenttb-html") }
    static var coenttbHtml: Self { .product(name: "CoenttbHTML", package: "coenttb-html") }
    static var coenttbMarkdown: Self { .product(name: "CoenttbMarkdown", package: "coenttb-html") }
    static var languages: Self { .product(name: "Languages", package: "swift-language") }
    static var tagged: Self { .product(name: "Tagged", package: "swift-tagged") }
}

let package = Package(
    name: "coenttb-web",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(
            name: .coenttbWeb,
            targets: [
                .coenttbWeb,
                .coenttbWebEnvVars,
                .coenttbWebHTML,
                .coenttbWebDependencies,
                .coenttbWebModels,
                .coenttbWebTranslations,
                .coenttbWebUtils,
            ]
        ),
        .library(name: .coenttbWebEnvVars, targets: [.coenttbWebEnvVars]),
        .library(name: .coenttbWebHTML, targets: [.coenttbWebHTML]),
        .library(name: .coenttbWebDependencies, targets: [.coenttbWebDependencies]),
        .library(name: .coenttbWebModels, targets: [.coenttbWebModels]),
        .library(name: .coenttbWebTranslations, targets: [.coenttbWebTranslations]),
        .library(name: .coenttbWebUtils, targets: [.coenttbWebUtils]),
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/coenttb-html", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-environment-variables.git", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-language.git", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-web", branch: "main"),
        .package(url: "https://github.com/pointfreeco/swift-tagged", branch: "main"),
    ],
    targets: [
        
        .target(
            name: .coenttbWeb,
            dependencies: [
                .languages,
                .coenttbHtml,
                .coenttbMarkdown,
                .swiftWeb,
                .coenttbEmail,
                .coenttbWebEnvVars,
                .coenttbWebHTML,
                .coenttbWebDependencies,
                .coenttbWebModels,
                .coenttbWebTranslations,
                .coenttbWebUtils,
                .tagged,
            ]
        ),
        .target(
            name: .coenttbWebEnvVars,
            dependencies: [
                .languages,
                .swiftWeb,
                .coenttbWebModels,
                .environmentVariables,
            ]
        ),
        .target(
            name: .coenttbWebHTML,
            dependencies: [
                .languages,
                .swiftWeb,
                .coenttbHtml,
                .coenttbMarkdown,
                .coenttbWebTranslations,
                .coenttbWebDependencies,
            ]
        ),
        .target(
            name: .coenttbWebDependencies,
            dependencies: [
                .languages,
                .swiftWeb,
                .coenttbWebModels,
            ]
        ),
        .target(
            name: .coenttbWebUtils,
            dependencies: [
                .languages,
                .swiftWeb
            ]
        ),
        .target(
            name: .coenttbWebModels,
            dependencies: [
                .languages,
                .swiftWeb,
            ]
        ),
        .target(
            name: .coenttbWebTranslations,
            dependencies: [
                .languages,
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
