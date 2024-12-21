//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 10/10/2024.
//

import Foundation
import CoenttbHTML

public extension String.StringInterpolation {
    mutating func appendInterpolation(html value: some HTML) {        
        let bytes: ContiguousArray<UInt8> = value.render()
        let string: String = String(decoding: bytes, as: UTF8.self)
            .replacingOccurrences(of: "\"", with: "\\\"")
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\r", with: "")
        
        appendLiteral(string)
    }
}
