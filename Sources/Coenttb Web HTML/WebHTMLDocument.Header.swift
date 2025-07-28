//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 27/07/2024.
//

import Foundation
import CoenttbHTML
import Translating
import Dependencies
import Coenttb_Web_Dependencies

public struct WebHTMLDocumentHeader<
    Styles: HTML,
    Favicons: HTML,
    Scripts: HTML
>: HTML {
    let title: String?
    let description: String?
    let themeColor: HTMLColor
    let canonicalHref: URL?
    let rssXml: URL?
    let language: Language
    let hreflang: (Language) -> URL
    @HTMLBuilder let styles: () -> Styles
    @HTMLBuilder let favicons: () -> Favicons
    @HTMLBuilder let scripts: () -> Scripts
    
    @Dependencies.Dependency(\.languages) var languages
    
    public init(
        title: String?,
        description: String?,
        themeColor: HTMLColor,
        canonicalHref: URL?,
        rssXml: URL?,
        language: Language,
        hreflang: @escaping (Language) -> URL,
        @HTMLBuilder styles: @escaping  () -> Styles,
        @HTMLBuilder favicons: @escaping () -> Favicons,
        @HTMLBuilder scripts: @escaping () -> Scripts
    ) {
        self.title = title
        self.description = description
        self.themeColor = themeColor
        self.language = language
        self.hreflang = hreflang
        self.canonicalHref = canonicalHref
        self.rssXml = rssXml
        self.styles = styles
        self.favicons = favicons
        self.scripts = scripts
    }
    
    public var body: some HTML {
        if let title {
            tag("title") { HTMLText(title) }
        }
        meta(charset: .utf8)()
        
        if let canonicalHref {
            link(
                href: .init(canonicalHref.absoluteString),
                rel: .canonical
            )()
        }
        
        if
            let title,
            let rssXml {
            
            link(
                href: .init(rssXml.relativeString),
                rel: .alternate,
                title: .init("\(title) RSS Feed"),
                type: .rss
            )()
            
        }
        HTMLForEach(self.languages.filter { $0 != language }) { lx in
            link(
                href: .init(hreflang(lx).absoluteString),
                hreflang: .init(value: lx.rawValue),
                rel: .alternate,
                
            )()
        }
        meta(
            name: .themeColor,
            content: .init(themeColor.light.description),
            media: "(prefers-color-scheme: light)"
        )()
        
        meta(
            name: .themeColor,
            content: .init(themeColor.dark.description),
            media: "(prefers-color-scheme: dark)"
        )()
        
        meta(
            name: .viewport,
            content: "width=device-width, initial-scale=1.0, viewport-fit=cover"
        )()
        
        styles()
        favicons()
        scripts()
        if let title {
            meta(
                name: "title",
                content: .init(title)
            )()
            
            meta(
                content: .init(title)
            )()
                .attribute("property", "og:title")
            
            meta(
                name: "twitter:title",
                content: .init(title)
            )()
            
        }
        if let description {
            meta(
                name: "description",
                content: .init(description)
            )()
            
            meta(
                content: .init(description)
            )()
                .attribute("property", "og:description")
            
            meta(
                name: "twitter:description",
                content: .init(description)
            )()
        }
    }
}
