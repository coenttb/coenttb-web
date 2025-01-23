//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 23/12/2024.
//

import Dependencies
import Foundation

public enum ProjectRootKey: Sendable, TestDependencyKey {
    public static let testValue: URL = {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }()
}

extension DependencyValues {
    public var projectRoot: URL {
        get { self[ProjectRootKey.self] }
        set { self[ProjectRootKey.self] = newValue }
    }
}


