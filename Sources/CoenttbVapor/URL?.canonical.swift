//
//  URL?.canonical.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 22/08/2024.
//

import Foundation

extension URL {
    /// Updates the host of a given URL to the canonical host.
    public static func canonical(url: URL, canonicalHost: String) -> URL? {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        let hostAndPort = canonicalHost.split(separator: ":").map(String.init)
        components?.host = hostAndPort.first
        
        if hostAndPort.count > 1, let port = Int(hostAndPort[1]) {
            components?.port = port
        }

        return components?.url
    }
}
