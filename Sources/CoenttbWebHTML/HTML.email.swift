////
////  File.swift
////  coenttb-web
////
////  Created by Coen ten Thije Boonkkamp on 31/08/2024.
////
//
//import Foundation
//import EmailAddress
//import struct Mailgun.Email
//import Languages
//
//extension HTML {
//    public func email(
//        _ email: Email
//    ) -> _HTMLAttributes<Self> {
//        self.email(recipients: email.to, subject: email.subject.description, body: email.text ?? "")
//    }
//    
//    public func email(
//        id: String = UUID.short(),
//        recipients: [EmailAddress],
//        subject: String?,
//        body: String
//    ) -> _HTMLAttributes<Self> {
//        
//        let ref: TranslatedString = "Ref"
//        
//        let subject = subject.map { title in
//            "\(title.description) - \(ref): \(id)"
//                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?
//                .replacingOccurrences(of: "+", with: "%20") ?? ""
//        }
//        
//        let body = body
//            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?
//            .replacingOccurrences(of: "+", with: "%20") ?? ""
//        
//        let href = switch subject {
//        case .none:
//            "mailto:\(recipients.map(\.description).joined(separator: "; "))?body=\(body)"
//        case let .some(subject):
//            "mailto:\(recipients.map(\.description).joined(separator: "; "))?subject=\(subject)&body=\(body)"
//        }
//        
//        return self.href(href)
//    }
//}
//
//extension UUID {
//    public static func short() -> String {
//        UUID().uuidString.split(separator: "-").first.map(String.init) ?? UUID().uuidString
//    }
//}
//
