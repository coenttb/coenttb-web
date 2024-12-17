//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 17/12/2024.
//

import Dependencies
import Foundation
import Languages
import URLRouting
import MacroCodableKit

public enum API: Equatable, Sendable {
    case image(String)
}
extension CoenttbWebSyndication.API {
    public struct Router: ParserPrinter, Sendable {
        
        public init(){}
        
        public var body: some URLRouting.Router<CoenttbWebSyndication.API> {
            OneOf {
                URLRouting.Route(.case(CoenttbWebSyndication.API.image)) {
                    Path {
                        "image"
                        Parse(.string)
                    }
                }
            }
        }
    }
}
