//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 10/01/2025.
//

import Foundation
import Dependencies

public enum TestStrategy: Codable, Hashable, Sendable {
    case local
    case liveTest
}

extension TestStrategy: TestDependencyKey {
    public static let testValue: TestStrategy = .local
}

extension DependencyValues {
    public var testStrategy: TestStrategy {
        get { self[TestStrategy.self] }
        set { self[TestStrategy.self] = newValue }
    }
}
