//
//  LogHandler.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 22/08/2024.
//

import Foundation

public struct CoenttbLogHandler: LogHandler {
    // MARK: - Properties
    private let label: String
    private let queue: DispatchQueue
    private let logDateFormatter: DateFormatter
    
    public var logLevel: Logger.Level
    
    private var _metadata: Logger.Metadata
    public var metadata: Logger.Metadata {
        get { queue.sync { _metadata } }
        set { queue.sync { _metadata = newValue } }
    }
    
    public var metadataProvider: Logger.MetadataProvider?
    
    public init(
        label: String,
        logLevel: Logger.Level = .info,
        metadataProvider: Logger.MetadataProvider? = nil
    ) {
        self.label = label
        self.logLevel = logLevel
        self.metadataProvider = metadataProvider
        self._metadata = [:]
        
        self.queue = DispatchQueue(label: "com.coenttb.logging.\(label)")
        
        self.logDateFormatter = .log
    }
    
    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get { queue.sync { _metadata[metadataKey] } }
        set { queue.sync { _metadata[metadataKey] = newValue } }
    }
    
    public func log(
        level: Logger.Level,
        message: Logger.Message,
        metadata explicitMetadata: Logger.Metadata?,
        source: String,
        file: String,
        function: String,
        line: UInt
    ) {
        queue.sync {
            let timestamp = timestamp()
            let mergedMetadata = Self.prepareMetadata(
                base: _metadata,
                provider: metadataProvider,
                explicit: explicitMetadata
            )
            
            let levelString = formatLevel(level)
            let sourceLocation = "\(source):\(line)"
            
            let components = [
                timestamp,
                levelString,
                "[\(sourceLocation)]",
                message.description,
                mergedMetadata
            ].compactMap { $0 }
            
            let fullMessage = components.joined(separator: " | ")
            
            FileHandle.standardError.write(Data((fullMessage + "\n").utf8))
        }
    }
    
    private static func prepareMetadata(
        base: Logger.Metadata,
        provider: Logger.MetadataProvider?,
        explicit: Logger.Metadata?
    ) -> String? {
        var metadata = base
        
        if let provided = provider?.get(), !provided.isEmpty {
            metadata.merge(provided) { _, new in new }
        }
        
        if let explicit = explicit, !explicit.isEmpty {
            metadata.merge(explicit) { _, new in new }
        }
        
        guard !metadata.isEmpty else { return nil }
        
        return metadata
            .sorted(by: { $0.key < $1.key })
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: ", ")
    }
    
    private func timestamp() -> String {
        logDateFormatter.string(from: Date())
    }
    
    private func formatLevel(_ level: Logger.Level) -> String {
        switch level {
        case .trace:    return "TRACE"
        case .debug:    return "DEBUG"
        case .info:     return "INFO "
        case .notice:   return "NOTCE"
        case .warning:  return "WARN "
        case .error:    return "ERROR"
        case .critical: return "CRIT "
        }
    }
}


extension DateFormatter {
    static let log: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

}
