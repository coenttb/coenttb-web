//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 31/08/2024.
//

import Foundation
import Dependencies
import Logging

extension EnvVars {
    private static let logger = Logger(label: "EnvVars")

    public static func live(
        localDevelopment: URL? = nil
    ) -> Self {
        do {
            let defaultEnvVarDict: [String:String] = [:]
            let localEnvVarDict = try getLocalEnvironment(from: localDevelopment)
            let processEnvVarDict = ProcessInfo.processInfo.environment
            
            let mergedEnvironment: [String : String] = defaultEnvVarDict
                .merging(localEnvVarDict, uniquingKeysWith: { $1 })
                .merging(processEnvVarDict, uniquingKeysWith: { $1 })
            
            return try EnvVars(dictionary: mergedEnvironment)
        } catch {
            logger.error("Failed to initialize EnvVars: \(error.localizedDescription)")
            fatalError("Environment initialization failed: \(error.localizedDescription)")
        }
    }
    
    private static func getLocalEnvironment(from url: URL?) throws -> [String: String] {
        guard let url = url else { return [:] }
        do {
            let data = try Data(contentsOf: url)
            return try decoder.decode([String: String].self, from: data)
        } catch {
            logger.warning("Could not load local environment from \(url.path): \(error.localizedDescription)")
            return [:]
        }
    }
}

private let encoder = JSONEncoder()
private let decoder = JSONDecoder()
