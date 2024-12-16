//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 15/12/2024.
//

import Foundation
import MemberwiseInit

public struct Client {
    
}

extension Client {
    @MemberwiseInit(.public)
    public struct EnvVars: Codable {
        public var id: String
    }
}
