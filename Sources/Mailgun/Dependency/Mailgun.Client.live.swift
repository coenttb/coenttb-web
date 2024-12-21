//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import Foundation
import AppSecret
import DecodableRequest
import FoundationPrelude
import EmailAddress

extension Client {
    public static func live(
        baseUrl: URL,
        apiKey: ApiKey,
        appSecret: AppSecret,
        domain: Client.Domain
    ) -> Client {
        return .init(
            appSecret: appSecret,
            sendEmail: { email in
                try await runMailgun(baseUrl: baseUrl, apiKey: apiKey)(
                    mailgunSend(email: email, domain: domain))
            },
            validate: { emailAddress in
                try await runMailgun(baseUrl: baseUrl, apiKey: apiKey)(mailgunValidate(email: emailAddress))
            },
            mailingLists: .live(baseUrl: baseUrl, apiKey: apiKey)
        )
    }
}

@Sendable func runMailgun<A>(
    baseUrl: URL,
    apiKey: Client.ApiKey
) async throws -> (DecodableRequest<A>?) async throws -> A {
    return { mailgunRequest in
        guard var mailgunRequest = mailgunRequest
        else { throw MailgunError("mailgunRequest is nil") }
        
        mailgunRequest.rawValue.set(baseUrl: baseUrl)
        mailgunRequest.rawValue.attachBasicAuth(username: "api", password: apiKey.rawValue)
        
        return try await dataTask(with: mailgunRequest.rawValue)
            .map { data, _ in data }
            .flatMap { data in
                    .wrap {
                        do {
                            return try jsonDecoder.decode(A.self, from: data)
                        } catch {
                            throw (try? jsonDecoder.decode(MailgunError.self, from: data))
                            ?? JSONError.error(String(decoding: data, as: UTF8.self), error) as Error
                        }
                    }
            }
            .performAsync()
    }
}


@Sendable func mailgunRequest<A>(_ path: String, _ method: FoundationPrelude.Method = .get([:]))
-> DecodableRequest<A> {
    
    var components = URLComponents(url: URL(string: path)!, resolvingAgainstBaseURL: false)!
    if case let .get(params) = method {
        components.queryItems = params.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
    }
    
    var request = URLRequest(url: components.url!)
    request.attach(method: method)
    return DecodableRequest(rawValue: request)
}

@Sendable func mailgunSend(email: Email, domain: Client.Domain) -> DecodableRequest<SendEmailResponse> {
    var params: [String: String] = [:]
    params["from"] = email.from.rawValue
    params["to"] = email.to.map(\.rawValue).joined(separator: ",")
    params["cc"] = email.cc?.map(\.rawValue).joined(separator: ",")
    params["bcc"] = email.bcc?.map(\.rawValue).joined(separator: ",")
    params["subject"] = email.subject
    params["text"] = email.text
    params["html"] = email.html
    params["tracking"] = email.tracking?.rawValue
    params["tracking-clicks"] = email.trackingClicks?.rawValue
    params["tracking-opens"] = email.trackingOpens?.rawValue
    email.headers.forEach { key, value in
        params["h:\(key)"] = value
    }
    
    return mailgunRequest("v3/\(domain.rawValue)/messages", Method.post(params))
}

@Sendable func mailgunValidate(email: EmailAddress) -> DecodableRequest<Client.Validation> {
    return mailgunRequest(
        "v3/address/private/validate",
        .get([
            "address": email.rawValue,
            "mailbox_verification": true
        ])
    )
}

private let jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    return decoder
}()


extension URLRequest {
    fileprivate mutating func set(baseUrl: URL) {
        self.url = URLComponents(url: self.url!, resolvingAgainstBaseURL: false)?.url(
            relativeTo: baseUrl)
    }
}


public struct MailgunError: Codable, Swift.Error {
    let description: String
    public init(_ description: String = "") {
        self.description = description
    }
}
