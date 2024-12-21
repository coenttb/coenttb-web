public struct Flash: Codable, Hashable, Sendable {
    public enum Priority: String, Codable, Hashable, Sendable {
        case error
        case notice
        case warning
    }

    public let message: String
    public let priority: Priority

    public init(
        _ priority: Priority,
        _ message: String
    ) {
        self.priority = priority
        self.message = message
    }
}

//extension Flash: RawRepresentable {
//    public typealias RawValue = String
//
//    public init?(rawValue: RawValue) {
//        let components = rawValue.components(separatedBy: "§")
//        guard components.count == 2,
//              let priority = Priority(rawValue: components[0]) else {
//            return nil
//        }
//        self.init(priority, components[1])
//
//    }
//
//    public var rawValue: RawValue {
//        return "\(priority.rawValue)§\(message)"
//    }
//}
