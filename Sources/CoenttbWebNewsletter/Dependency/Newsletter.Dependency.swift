//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 07/10/2024.
//

import CoenttbWebDatabase
import EmailAddress
import Foundation
import CoenttbWebHTML
import Mailgun

@DependencyClient
public struct Client: @unchecked Sendable {
    @DependencyEndpoint
    public var subscribe: (EmailAddress) async throws -> Void

    @DependencyEndpoint
    public var unsubscribe: (EmailAddress) async throws -> Void
    
}
extension Client: TestDependencyKey {
    public static let testValue: Client = .init()
}

