//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import EmailAddress
import MemberwiseInit
import Tagged

@MemberwiseInit(.public)
public struct Email: Sendable {
    public var from: EmailAddress
    public var to: [EmailAddress]
    @Init(default: nil)
    public var cc: [EmailAddress]?
    @Init(default: nil)
    public var bcc: [EmailAddress]?
    public var subject: String
    public var text: String?
    public var html: String?
    @Init(default: nil)
    public var testMode: Bool?
    @Init(default: nil)
    public var tracking: Tracking?
    @Init(default: nil)
    public var trackingClicks: TrackingClicks?
    @Init(default: nil)
    public var trackingOpens: TrackingOpens?
    public var domain: String
    @Init(default: [])
    public var headers: [(String, String)]
}
