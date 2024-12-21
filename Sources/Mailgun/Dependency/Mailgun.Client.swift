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

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@DependencyClient
public struct Client: Sendable {
    public let appSecret: AppSecret
    public var sendEmail: @Sendable (Email) async throws -> SendEmailResponse
    public var validate: @Sendable (_ emailAddress: EmailAddress) async throws -> Validation
    public var mailingLists: Client.MailingList
}

extension Mailgun.Client {
    public typealias ApiKey = Tagged<(Self, apiKey: ()), String>
    public typealias Domain = Tagged<(Self, domain: ()), String>
}

extension Mailgun.Client {
    public struct Validation: Codable {
        public var mailboxVerification: Bool
        
        public init (mailboxVerification: Bool) {
            self.mailboxVerification = mailboxVerification
        }
        
        public enum CodingKeys: String, CodingKey {
            case mailboxVerification = "mailbox_verification"
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.mailboxVerification =
            Bool(try container.decode(String.self, forKey: .mailboxVerification)) ?? false
        }
    }
}
 
extension Mailgun.Client {
    public func verify(payload: MailgunForwardPayload, with apiKey: ApiKey) -> Bool {
        let digest = hexDigest(
            value: "\(payload.timestamp)\(payload.token)",
            asciiSecret: apiKey.rawValue
        )
        return payload.signature == digest
    }
}

extension Client: TestDependencyKey {
    public static let testValue: Client? = Client(appSecret: "deadbeefdeadbeefdeadbeefdeadbeef", mailingLists: .testValue)
}

extension DependencyValues {
    public var mailgun: Client? {
        get { self[Client.self] }
        set { self[Client.self] = newValue }
    }
}

public extension URL {
    static let mailgun_eu_baseUrl: Self = URL(string: "https://api.eu.mailgun.net")!
    static let mailgun_usa_baseUrl: Self = URL(string: "https://api.mailgun.net")!
}
