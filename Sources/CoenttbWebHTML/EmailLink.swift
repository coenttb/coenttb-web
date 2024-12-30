//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 30/12/2024.
//

import Foundation
import EmailAddress
import CoenttbHTML

public struct EmailLink {
    public let to: [EmailAddress]
    public let subject: String?
    public let body: String?
    public let cc: [String]?
    public let bcc: [String]?
    
    public init(
        to: [EmailAddress],
        subject: String? = nil,
        body: String? = nil,
        cc: [String]? = nil,
        bcc: [String]? = nil
    ) {
        self.to = to
        self.subject = subject
        self.body = body
        self.cc = cc
        self.bcc = bcc
    }
    
    // Convenience initializer for single recipient
    public init(
        to: EmailAddress,
        subject: String? = nil,
        body: String? = nil,
        cc: [String]? = nil,
        bcc: [String]? = nil
    ) {
        self.init(to: [to], subject: subject, body: body, cc: cc, bcc: bcc)
    }
}

extension HTML {
    @discardableResult
    public func email(_ email: EmailLink) -> some HTML {
        // Create mailto URL components
        var components: [String] = []
        
        // Add subject if present
        if let subject = email.subject {
            components.append("subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")
        }
        
        // Add body if present
        if let body = email.body {
            components.append("body=\(body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")
        }
        
        // Add CC recipients if present
        if let cc = email.cc, !cc.isEmpty {
            components.append("cc=\(cc.joined(separator: ",").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")
        }
        
        // Add BCC recipients if present
        if let bcc = email.bcc, !bcc.isEmpty {
            components.append("bcc=\(bcc.joined(separator: ",").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")
        }
        
        // Create the complete mailto URL
        let mailtoUrl = "mailto:\(email.to.map(\.description).joined(separator: ","))"
        let queryString = components.isEmpty ? "" : "?\(components.joined(separator: "&"))"
        
        return attribute("href", mailtoUrl + queryString)
    }
}
