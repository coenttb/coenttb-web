//
//  File 2.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 03/06/2022.
//

import Dependencies
import Foundation
import Translating
import Logging
import Coenttb_Web_Models
import EnvironmentVariables

extension EnvVars {
    public var appEnv: AppEnv {
        get { AppEnv(rawValue: self["APP_ENV"]!)! }
        set { self["APP_ENV"] = newValue.rawValue }
    }
}

extension EnvVars {
    public enum AppEnv: String, Sendable, Codable {
        case development
        case production
        case testing
        case staging
    }
}

extension EnvVars {
    public var languages: [Language]? {
        get {
            self["LANGUAGES"]?
                .components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .compactMap { Language(rawValue: $0) }
        }
        set { self["LANGUAGES"] = newValue?.map { $0.rawValue }.joined(separator: ",") }
    }
}


extension EnvVars {
    public static let localWebDevelopment: EnvVars = try! EnvVars(dictionary: [
        "APP_ENV": "testing"
    ], requiredKeys: [
        "APP_ENV"
    ]
    )
}

extension Set<String> {
    public static let requiredKeys: Set<String> = [
        "APP_SECRET"
    ]
}
