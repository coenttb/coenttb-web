////
////  File.swift
////
////
////  Created by Coen ten Thije Boonkkamp on 18-12-2023.
////
//
import Dependencies
import Foundation
import CoenttbWebModels

private enum FlashKey: DependencyKey {
    static let liveValue: Flash? = nil
    static let testValue: Flash? = nil
}

extension DependencyValues {
    public var flash: Flash? {
        get { self[FlashKey.self] }
        set { self[FlashKey.self] = newValue }
    }
}
