//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 03/09/2024.
//

import CoenttbHTML

//extension RawRepresentable where Self.RawValue == String  {
//    public var rawValue: String {
//        func rawValue(for codingKey: Self) -> String {
//            let fullTypePath = String(reflecting: Self.self) + "." + codingKey.rawValue
//            let words = fullTypePath.split { $0 == "." || $0 == "_" }
//            
//            let firstWord = words.first?.lowercased() ?? ""
//            let camelCased = words.dropFirst().map { $0.capitalized }.joined()
//            
//            return firstWord + camelCased
//        }
//        return rawValue(for: self)
//    }
//}

public struct Input<CodingKey: RawRepresentable>: HTML where CodingKey.RawValue == String {
    
    public let codingKey: CodingKey
    
    public init(_ codingKey: CodingKey) {
        self.codingKey = codingKey
    }
    
    public var body: some HTML {
        input()
            .id(codingKey.rawValue)
            .name(codingKey.rawValue)
    }
}

extension Input {
    public static func `default`(_ codingKey: CodingKey) -> some HTML {
        Input(codingKey)
        .width(100.percent)
        .padding(vertical: 14.px, horizontal: 10.px)
        .border(width: 1.px, color: .gray900.withDarkColor(.gray100))
        .background(.white.withDarkColor(.black))
        .color(.secondary)
        .inlineStyle("border-radius", "5px")
    }
}

extension Input {
    public static func search(_ codingKey: CodingKey) -> some HTML {
        Input(codingKey)
        .width(100.percent)
        .padding(vertical: 14.px, horizontal: 10.px)
        .border(width: 1.px, color: .init(light: .hex("#ddd")))
        .inlineStyle("border-radius", "5px")
    }
}
