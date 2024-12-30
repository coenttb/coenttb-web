//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 16/09/2024.
//

import Foundation
import Dependencies

public actor InMemoryStore {
    private struct Entry {
        let value: Any
        let expiresAt: Date?
    }
    
    private var storage: [String: Entry] = [:]
    private var cleanupTimer: SendableTimer?
    
    public init(cleanupInterval: TimeInterval = 60) {
        Task {
            await self.startCleanupTimer(interval: cleanupInterval)
        }
    }
    
    deinit {
        Task { [weak self] in
            await self?.invalidateTimer()
        }
    }
    
    private func invalidateTimer() {
        cleanupTimer?.invalidate()
    }
    
    private func startCleanupTimer(interval: TimeInterval) {
        let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            Task { [weak self] in
                await self?.removeExpiredEntries()
            }
        }
        let sendableTimer = SendableTimer()
        sendableTimer.setTimer(timer)
        self.cleanupTimer = sendableTimer
    }
}

extension InMemoryStore {
    private class SendableTimer: @unchecked Sendable {
        private var timer: Timer?
        
        func setTimer(_ timer: Timer) {
            self.timer = timer
        }
        
        func invalidate() {
            timer?.invalidate()
            timer = nil
        }
    }
}
extension InMemoryStore {
    public func set(_ key: String, value: Any, expiresIn: TimeInterval? = nil) {
        let expiresAt = expiresIn.map { Date().addingTimeInterval($0) }
        storage[key] = Entry(value: value, expiresAt: expiresAt)
    }
    
    public func get(_ key: String) -> Any? {
        guard let entry = storage[key] else { return nil }
        
        if let expiresAt = entry.expiresAt, expiresAt < Date() {
            storage.removeValue(forKey: key)
            return nil
        }
        
        return entry.value
    }
    
    public func remove(_ key: String) {
        storage.removeValue(forKey: key)
    }
    
    public func removeExpiredEntries() {
        let now = Date()
        storage = storage.filter { _, entry in
            guard let expiresAt = entry.expiresAt else { return true }
            return expiresAt > now
        }
    }
    
    public func clear() {
        storage.removeAll()
    }
}

enum InMemoryStoreKey: DependencyKey {
    static public let testValue: InMemoryStore = .init()
    static public let liveValue: InMemoryStore = .init()
}


extension DependencyValues {
    public var inMemoryStore: InMemoryStore {
        get { self[InMemoryStoreKey.self] }
        set { self[InMemoryStoreKey.self] = newValue }
    }
}
