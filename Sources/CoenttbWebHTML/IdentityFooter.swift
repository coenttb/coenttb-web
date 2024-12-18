//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 15/09/2024.
//

import Foundation
import CoenttbWebTranslations

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
                Link(String.terms_of_use.capitalizingFirstLetter().description, href: termsOfUse.absoluteString)
                    .inlineStyle("flex", "1")
                    .textAlign(.right)
                    .padding(right: 0.25.rem)
                
                div { "|" }
                    .width(1.rem)
                    .textAlign(.center)
                
                Link(String.privacyStatement.capitalizingFirstLetter().description, href: privacyStatement.absoluteString)
                    .inlineStyle("flex", "1")
                    .textAlign(.left)
                    .padding(left: 0.25.rem)
            }
            .maxWidth(800.px)
            .margin(horizontal: .auto)
            .padding(1.rem)
        }
        .fontSize(.secondary)
        .color(.gray600)
        .fontWeight(.light)
    }
}

