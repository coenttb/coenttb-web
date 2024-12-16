//  MIT License
//
//  Copyright (c) 2018 Point-Free, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import EmailAddress
import MemberwiseInit
import Tagged

@MemberwiseInit(.public)
public struct SendEmailResponse: Decodable {
    public let id: String?
    public let message: String
}

public enum Tracking: String, Sendable {
    case no
    case yes
}

public enum TrackingClicks: String, Sendable {
    case yes
    case no
    case htmlOnly = "htmlonly"
}

public enum TrackingOpens: String, Sendable {
    case yes
    case no
    case htmlOnly = "htmlonly"
}

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

@MemberwiseInit(.public)
public struct MailgunForwardPayload: Codable, Equatable, Sendable {
    public let recipient: EmailAddress
    public let timestamp: Int
    public let token: String
    public let sender: EmailAddress
    public let signature: String
}
