//import Foundation
//import EmailAddress
//import CoenttbVapor
//import Foundation
//import EmailAddress
//import Dependencies
//
//
//
//
//actor SubscriptionRateLimiter {
//    
//    private let config: RateLimitConfig
//    private let metrics: RateLimitMetrics
//    private var attemptsByEmail: BoundedCache<String, AttemptInfo>
//    private var attemptsByIP: BoundedCache<String, AttemptInfo>
//    
//    init(
//        config: RateLimitConfig = .default,
//        metrics: RateLimitMetrics = NoOpRateLimitMetrics()
//    ) {
//        self.config = config
//        self.metrics = metrics
//        self.attemptsByEmail = BoundedCache(capacity: config.maxCacheSize)
//        self.attemptsByIP = BoundedCache(capacity: config.maxCacheSize)
//    }
//    
//    func subscribe(_ context: RateLimitContext) async throws -> RateLimitResult {
//        let now = context.timestamp
//        let windowStart = getWindowStart(for: now)
//        
//        // Clean up old entries
//        await cleanup(now)
//        
//        // Get current attempt counts
//        let emailInfo = attemptsByEmail.getValue(forKey: context.email.rawValue) ??
//        AttemptInfo(timestamp: now, windowStart: windowStart)
//        
//        let ipInfo = attemptsByIP.getValue(forKey: context.ipAddress) ??
//        AttemptInfo(timestamp: now, windowStart: windowStart)
//        
//        // Reset counts if we're in a new window
//        let emailAttempts = emailInfo.windowStart == windowStart ? emailInfo.attempts : 0
//        let ipAttempts = ipInfo.windowStart == windowStart ? ipInfo.attempts : 0
//        
//        // Calculate backoff if needed
//        let backoffInterval = calculateBackoffInterval(
//            consecutiveFailures: max(emailInfo.consecutiveFailures, ipInfo.consecutiveFailures)
//        )
//        
//        // Check if either limit is exceeded
//        if emailAttempts >= config.maxEmailAttempts || ipAttempts >= config.maxIPAttempts {
//            let nextWindow = windowStart.addingTimeInterval(config.windowDuration)
//            let reason = emailAttempts >= config.maxEmailAttempts
//            ? "Too many subscription attempts from this email"
//            : "Too many subscription attempts from this IP address"
//            
//            let result = RateLimitResult(
//                isAllowed: false,
//                emailAttempts: emailAttempts,
//                ipAttempts: ipAttempts,
//                nextAllowedAttempt: nextWindow,
//                reason: reason,
//                backoffInterval: backoffInterval
//            )
//            
//            await metrics.recordAttempt(context: context, result: result)
//            
//            if shouldCheckForAbusePattern(emailAttempts: emailAttempts, ipAttempts: ipAttempts) {
//                await metrics.recordAbusePattern(
//                    ipAddress: context.ipAddress,
//                    email: context.email.rawValue,
//                    pattern: "Exceeded rate limit"
//                )
//            }
//            
//            return result
//        }
//        
//        // Update attempts
//        let newEmailInfo = AttemptInfo(
//            timestamp: now,
//            attempts: emailAttempts + 1,
//            windowStart: windowStart,
//            consecutiveFailures: emailInfo.consecutiveFailures
//        )
//        
//        let newIPInfo = AttemptInfo(
//            timestamp: now,
//            attempts: ipAttempts + 1,
//            windowStart: windowStart,
//            consecutiveFailures: ipInfo.consecutiveFailures
//        )
//        
//        attemptsByEmail.insert(newEmailInfo, forKey: context.email.rawValue)
//        attemptsByIP.insert(newIPInfo, forKey: context.ipAddress)
//        
//        let result = RateLimitResult(
//            isAllowed: true,
//            emailAttempts: emailAttempts + 1,
//            ipAttempts: ipAttempts + 1,
//            backoffInterval: backoffInterval
//        )
//        
//        await metrics.recordAttempt(context: context, result: result)
//        return result
//    }
//    
//    
//    
//    func recordFailure(email: String, ipAddress: String) async {
//        if var emailInfo = attemptsByEmail.getValue(forKey: email) {
//            emailInfo.consecutiveFailures += 1
//            attemptsByEmail.insert(emailInfo, forKey: email)
//        }
//        
//        if var ipInfo = attemptsByIP.getValue(forKey: ipAddress) {
//            ipInfo.consecutiveFailures += 1
//            attemptsByIP.insert(ipInfo, forKey: ipAddress)
//        }
//    }
//    
//    func recordSuccess(email: String, ipAddress: String) async {
//        if var emailInfo = attemptsByEmail.getValue(forKey: email) {
//            emailInfo.consecutiveFailures = 0
//            attemptsByEmail.insert(emailInfo, forKey: email)
//        }
//        
//        if var ipInfo = attemptsByIP.getValue(forKey: ipAddress) {
//            ipInfo.consecutiveFailures = 0
//            attemptsByIP.insert(ipInfo, forKey: ipAddress)
//        }
//    }
//    
//    func reset(email: String? = nil, ipAddress: String? = nil) async {
//        if let email = email {
//            _ = attemptsByEmail.removeValue(forKey: email)
//        }
//        if let ipAddress = ipAddress {
//            _ = attemptsByIP.removeValue(forKey: ipAddress)
//        }
//    }
//    
//    private func getWindowStart(for date: Date) -> Date {
//        @Dependency(\.calendar) var calendar
//        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
//        return calendar.date(from: components) ?? date
//    }
//    
//    private func calculateBackoffInterval(consecutiveFailures: Int) -> TimeInterval? {
//        guard consecutiveFailures > 0 else { return nil }
//        return pow(config.backoffMultiplier, Double(consecutiveFailures)) * config.windowDuration
//    }
//    
//    private func shouldCheckForAbusePattern(emailAttempts: Int, ipAttempts: Int) -> Bool {
//        return emailAttempts >= config.maxEmailAttempts * 2 || ipAttempts >= config.maxIPAttempts * 2
//    }
//    
//    private func cleanup(_ now: Date) async {
//        let cutoff = now.addingTimeInterval(-config.windowDuration)
//        attemptsByEmail.filter { _, info in info.timestamp > cutoff }
//        attemptsByIP.filter { _, info in info.timestamp > cutoff }
//    }
//}
//
//extension SubscriptionRateLimiter {
//    /// Configuration for rate limiting behavior
//    public struct RateLimitConfig: Sendable {
//        let windowDuration: TimeInterval
//        let maxEmailAttempts: Int
//        let maxIPAttempts: Int
//        let maxCacheSize: Int
//        let backoffMultiplier: Double
//        let trustForwardedFor: Bool
//        
//        public init(
//            windowDuration: TimeInterval, // 1 hour default
//            maxEmailAttempts: Int,
//            maxIPAttempts: Int,
//            maxCacheSize: Int,
//            backoffMultiplier: Double,
//            trustForwardedFor: Bool
//        ) {
//            self.windowDuration = windowDuration
//            self.maxEmailAttempts = maxEmailAttempts
//            self.maxIPAttempts = maxIPAttempts
//            self.maxCacheSize = maxCacheSize
//            self.backoffMultiplier = backoffMultiplier
//            self.trustForwardedFor = trustForwardedFor
//        }
//        
//        public static let `default` = RateLimitConfig.init(
//            windowDuration: 3600,
//            maxEmailAttempts: 5,
//            maxIPAttempts: 10,
//            maxCacheSize: 10000,
//            backoffMultiplier: 2.0,
//            trustForwardedFor: false
//        )
//    }
//}
// 
//extension SubscriptionRateLimiter {
//    /// Result of rate limit check with detailed information
//    public struct RateLimitResult: Sendable {
//        public let isAllowed: Bool
//        public let emailAttempts: Int
//        public let ipAttempts: Int
//        public let nextAllowedAttempt: Date?
//        public let reason: String?
//        public let backoffInterval: TimeInterval?
//        
//        public init(
//            isAllowed: Bool,
//            emailAttempts: Int,
//            ipAttempts: Int,
//            nextAllowedAttempt: Date? = nil,
//            reason: String? = nil,
//            backoffInterval: TimeInterval? = nil
//        ) {
//            self.isAllowed = isAllowed
//            self.emailAttempts = emailAttempts
//            self.ipAttempts = ipAttempts
//            self.nextAllowedAttempt = nextAllowedAttempt
//            self.reason = reason
//            self.backoffInterval = backoffInterval
//        }
//    }
//}
//
//extension SubscriptionRateLimiter {
//    /// Protocol for monitoring rate limiting metrics
//    public protocol RateLimitMetrics: Sendable {
//        func recordAttempt(context: RateLimitContext, result: RateLimitResult) async
//        func recordAbusePattern(ipAddress: String, email: String, pattern: String) async
//    }
//}
// 
//extension SubscriptionRateLimiter {
//    /// Default no-op implementation of metrics
//    public struct NoOpRateLimitMetrics: RateLimitMetrics {
//        public func recordAttempt(context: RateLimitContext, result: RateLimitResult) async {}
//        public func recordAbusePattern(ipAddress: String, email: String, pattern: String) async {}
//    }
//}
//
//extension SubscriptionRateLimiter {
//    private struct AttemptInfo: Sendable {
//        let timestamp: Date
//        var attempts: Int
//        let windowStart: Date
//        var consecutiveFailures: Int
//        
//        init(timestamp: Date, attempts: Int = 0, windowStart: Date, consecutiveFailures: Int = 0) {
//            self.timestamp = timestamp
//            self.attempts = attempts
//            self.windowStart = windowStart
//            self.consecutiveFailures = consecutiveFailures
//        }
//    }
//}
//
//extension SubscriptionRateLimiter {
//    /// Request context for rate limiting
//    public struct RateLimitContext: Sendable {
//        public let email: EmailAddress
//        public let ipAddress: String
//        public let userAgent: String?
//        public let timestamp: Date
//        public let requestId: String?
//        public let geoLocation: GeoLocation?
//        
//        public init(
//            email: EmailAddress,
//            ipAddress: String,
//            userAgent: String? = nil,
//            timestamp: Date = Date(),
//            requestId: String? = nil,
//            geoLocation: GeoLocation? = nil
//        ) {
//            self.email = email
//            self.ipAddress = ipAddress
//            self.userAgent = userAgent
//            self.timestamp = timestamp
//            self.requestId = requestId
//            self.geoLocation = geoLocation
//        }
//    }
//}
//
