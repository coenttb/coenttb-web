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
    static var swiftWeb: Self { .product(name: "Web", package: "swift-web") }
    static var coenttbEmail: Self { .product(name: "CoenttbEmail", package: "coenttb-html") }
    static var coenttbHtml: Self { .product(name: "CoenttbHTML", package: "coenttb-html") }
    static var coenttbMarkdown: Self { .product(name: "CoenttbMarkdown", package: "coenttb-html") }
    static var coenttbUtils: Self { .product(name: "CoenttbUtils", package: "coenttb-utils") }
    static var translating: Self { .product(name: "Translating", package: "swift-translating") }
    static var tagged: Self { .product(name: "Tagged", package: "swift-tagged") }
    static var htmlTestSupport: Self { .product(name: "PointFreeHTMLTestSupport", package: "pointfree-html") }
    static var passwordValidation: Self { .product(name: "PasswordValidation", package: "swift-password-validation") }
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
        .package(url: "https://github.com/coenttb/coenttb-utils", branch: "main"),
        .package(url: "https://github.com/coenttb/pointfree-html", from: "2.0.0"),
        .package(url: "https://github.com/coenttb/swift-html", from: "0.0.1"),
        .package(url: "https://github.com/coenttb/swift-environment-variables.git", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-password-validation.git", from: "0.0.1"),
        .package(url: "https://github.com/coenttb/swift-html-css-pointfree", from: "0.0.1"),
        .package(url: "https://github.com/coenttb/swift-translating.git", from: "0.0.1"),
        .package(url: "https://github.com/coenttb/swift-web", branch: "main"),
        .package(url: "https://github.com/pointfreeco/swift-tagged", branch: "main"),
    ],
    targets: [
        .target(
            name: .coenttbWeb,
            dependencies: [
                .translating,
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
                .translating,
                .swiftWeb,
                .coenttbWebModels,
                .environmentVariables,
            ]
        ),
        .target(
            name: .coenttbWebHTML,
            dependencies: [
                .translating,
                .swiftWeb,
                .coenttbHtml,
                .coenttbMarkdown,
                .coenttbWebTranslations,
                .coenttbWebDependencies,
            ]
        ),
        .testTarget(
            name: .coenttbWebHTML.tests,
            dependencies: [
                .coenttbWebHTML,
                .htmlTestSupport,
            ]
        ),
        .target(
            name: .coenttbWebDependencies,
            dependencies: [
                .translating,
                .swiftWeb,
                .coenttbWebModels,
            ]
        ),
        .target(
            name: .coenttbWebUtils,
            dependencies: [
                .translating,
                .swiftWeb,
                .tagged,
                .coenttbUtils,
                .passwordValidation,
            ]
        ),
        .target(
            name: .coenttbWebModels,
            dependencies: [
                .translating,
                .swiftWeb,
                .tagged,
            ]
        ),
        .target(
            name: .coenttbWebTranslations,
            dependencies: [
                .translating,
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: String {
        appending(" Tests")
    }
}
