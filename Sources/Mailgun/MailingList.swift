//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import AppSecret
import DecodableRequest
import Dependencies
import DependenciesMacros
import Either
import EmailAddress
import Foundation
import FoundationPrelude
import HttpPipeline
import Logging
import LoggingDependencies
import MemberwiseInit
import Tagged
import UrlFormEncoding

// MARK: - MailingList
public struct MailingList: Codable, Sendable {
    public let address: String
    public let name: String?
    public let description: String?
    public let accessLevel: MailingList.AccessLevel?
    public let replyPreference: MailingList.ReplyPreference?
    
    public init(
        address: String,
        name: String? = nil,
        description: String? = nil,
        accessLevel: MailingList.AccessLevel? = nil,
        replyPreference: MailingList.ReplyPreference? = nil
    ) {
        self.address = address
        self.name = name
        self.description = description
        self.accessLevel = accessLevel
        self.replyPreference = replyPreference
    }
    
    enum CodingKeys: String, CodingKey {
        case address
        case name
        case description
        case accessLevel = "access_level"
        case replyPreference = "reply_preference"
    }
}

// MARK: - MailingList Nested Types
extension MailingList {
    public enum AccessLevel: String, Codable, Sendable {
        case readonly
        case members
        case everyone
    }
    
    public enum ReplyPreference: String, Codable, Sendable {
        case list
        case sender
        case none = ""
    }
}
