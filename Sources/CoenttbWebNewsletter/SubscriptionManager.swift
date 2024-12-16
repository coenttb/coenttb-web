//
//  File.swift
//  tenthijeboonkkamp-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 20/09/2024.
//

import Foundation

actor SubscriptionManager {
    private var subscribedEmails: Set<String> = []
    
    func isSubscribed(_ email: String) -> Bool {
        subscribedEmails.contains(email)
    }
    
    func subscribe(_ email: String) -> Bool {
        if subscribedEmails.contains(email) {
            return false
        }
        subscribedEmails.insert(email)
        return true
    }
    
    func unsubscribe(_ email: String) {
        subscribedEmails.remove(email)
    }
}
