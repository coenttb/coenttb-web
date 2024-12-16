//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 18-12-2023.
//

import Dependencies
import Foundation
import Languages

private enum LanguagesKey: DependencyKey {
    static let liveValue: [Languages.Language] = []
    static let testValue: [Languages.Language] = [.dutch, .english]
}

extension DependencyValues {
    public var languages: [Languages.Language] {
        get { self[LanguagesKey.self] }
        set { self[LanguagesKey.self] = newValue }
    }
}
