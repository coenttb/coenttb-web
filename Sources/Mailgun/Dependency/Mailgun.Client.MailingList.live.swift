//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import Foundation

extension Client.MailingList {
    public static func live(
        baseUrl: URL,
        apiKey: Mailgun.Client.ApiKey
    ) -> Self {
        .init(
            create: { list in
                try await runMailgun(baseUrl: baseUrl, apiKey: apiKey)(Client.MailingList.createRequest(list))
            },
            delete: { address in
                try await runMailgun(baseUrl: baseUrl, apiKey: apiKey)(Client.MailingList.deleteRequest(address))
            },
            addMember: { listAddress, member in
                try await runMailgun(baseUrl: baseUrl, apiKey: apiKey)(Client.MailingList.Member.addRequest(listAddress, member))
            },
            removeMember: { listAddress, memberAddress in
                try await runMailgun(baseUrl: baseUrl, apiKey: apiKey)(Client.MailingList.Member.removeRequest(listAddress, memberAddress))
            },
            updateMember: { listAddress, member in
                try await runMailgun(baseUrl: baseUrl, apiKey: apiKey)(Client.MailingList.Member.updateRequest(listAddress, member))
            }
        )
    }
}
