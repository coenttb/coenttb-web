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
        let htmlString: String = String(decoding: bytes, as: UTF8.self)
        
        // Escape characters that would break template literals
        let escapedString = htmlString
            .replacingOccurrences(of: "\\", with: "\\\\")   // Escape backslashes first (must be first!)
            .replacingOccurrences(of: "`", with: "\\`")     // Escape backticks
            .replacingOccurrences(of: "${", with: "\\${")   // Escape template literal expressions
            .replacingOccurrences(of: "\u{2028}", with: "\\u2028") // Escape line separator
            .replacingOccurrences(of: "\u{2029}", with: "\\u2029") // Escape paragraph separator
        
        // Wrap in backticks to create a template literal
        appendLiteral("`\(escapedString)`")
    }
}
