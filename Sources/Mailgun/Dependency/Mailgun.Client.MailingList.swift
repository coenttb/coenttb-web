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

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif


// MARK: - Client MailingList Interface
extension Client {
    @DependencyClient
    public struct MailingList: Sendable {
        public var create: @Sendable (_ list: Mailgun.MailingList) async throws -> Client.MailingList.Response
        public var delete: @Sendable (_ address: String) async throws -> SendEmailResponse
        public var addMember: @Sendable (_ listAddress: String, _ member: Client.MailingList.Member) async throws -> Client.MailingList.MemberResponse
        public var removeMember: @Sendable (_ listAddress: String, _ memberAddress: EmailAddress) async throws -> SendEmailResponse
        public var updateMember: @Sendable (_ listAddress: String, _ member: Client.MailingList.Member) async throws -> Client.MailingList.MemberResponse
    }
}




extension Client.MailingList: TestDependencyKey {
    static public let testValue: Client.MailingList = .testValue
}

extension Client.MailingList {
    public struct Member: Codable, Sendable {
        public let address: EmailAddress
        public let name: String?
        public let vars: [String: String]?
        public let subscribed: Bool
        
        public init(
            address: EmailAddress,
            name: String? = nil,
            vars: [String: String]? = nil,
            subscribed: Bool = true
        ) {
            self.address = address
            self.name = name
            self.vars = vars
            self.subscribed = subscribed
        }
        
        enum CodingKeys: String, CodingKey {
            case address
            case name
            case vars
            case subscribed
        }
    }
    
    public struct Response: Codable, Sendable {
        public let list: MailingList
        public let message: String
    }
    
    public struct MemberResponse: Codable, Sendable {
        public let member: Member
        public let message: String
    }
}

// MARK: - MailingList API Requests
extension Client.MailingList {
    static func createRequest(_ list: MailingList) -> DecodableRequest<Response> {
        var params: [String: String] = [:]
        params["address"] = list.address
        params["name"] = list.name
        params["description"] = list.description
        params["access_level"] = list.accessLevel?.rawValue
        params["reply_preference"] = list.replyPreference?.rawValue
        
        return mailgunRequest("v3/lists", Method.post(params))
    }
    
    static func deleteRequest(_ address: String) -> DecodableRequest<SendEmailResponse> {
        mailgunRequest("v3/lists/\(address)", Method.delete([:]))
    }
}

// MARK: - MailingList.Member API Requests
extension Client.MailingList.Member {
    static func addRequest(_ listAddress: String, _ member: Client.MailingList.Member) -> DecodableRequest<Client.MailingList.MemberResponse> {
        var params: [String: String] = [:]
        params["address"] = member.address.rawValue
        params["name"] = member.name
        if let vars = member.vars {
            params["vars"] = try? String(decoding: JSONEncoder().encode(vars), as: UTF8.self)
        }
        params["subscribed"] = String(member.subscribed)
        
        return mailgunRequest("v3/lists/\(listAddress)/members", Method.post(params))
    }
    
    static func removeRequest(_ listAddress: String, _ memberAddress: EmailAddress) -> DecodableRequest<SendEmailResponse> {
        mailgunRequest("v3/lists/\(listAddress)/members/\(memberAddress.rawValue)", Method.delete([:]))
    }
    
    static func updateRequest(_ listAddress: String, _ member: Client.MailingList.Member) -> DecodableRequest<Client.MailingList.MemberResponse> {
        var params: [String: String] = [:]
        params["name"] = member.name
        if let vars = member.vars {
            params["vars"] = try? String(decoding: JSONEncoder().encode(vars), as: UTF8.self)
        }
        params["subscribed"] = String(member.subscribed)
        
        return mailgunRequest("v3/lists/\(listAddress)/members/\(member.address.rawValue)", Method.put(params))
    }
}
