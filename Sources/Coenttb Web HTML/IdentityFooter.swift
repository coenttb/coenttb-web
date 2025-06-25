//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 15/09/2024.
//

import Foundation
import Coenttb_Web_Translations

public struct IdentityFooter: HTML {
    
    let termsOfUse: URL
    let privacyStatement: URL
    
    public init(termsOfUse: URL, privacyStatement: URL) {
        self.termsOfUse = termsOfUse
        self.privacyStatement = privacyStatement
    }
    
    public var body: some HTML {
        footer {
            HStack {
                Link(String.terms_of_use.capitalizingFirstLetter().description, href: .init(termsOfUse.absoluteString))
                    .inlineStyle("flex", "1")
                    .textAlign(.right)
                    .padding(right: .rem(0.25))
                
                div { "|" }
                    .width(.rem(1))
                    .textAlign(.center)
                
                Link(String.privacyStatement.capitalizingFirstLetter().description, href: .init(privacyStatement.absoluteString))
                    .inlineStyle("flex", "1")
                    .textAlign(.left)
                    .padding(left: .rem(0.25))
            }
            .maxWidth(.px(800))
            .margin(vertical: nil, horizontal: .auto)
            .padding(.rem(1))
        }
//        .fontSize(.secondary)
        .color(.text.secondary)
        .fontWeight(.light)
    }
}

