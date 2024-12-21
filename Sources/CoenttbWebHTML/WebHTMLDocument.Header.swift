//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 27/07/2024.
//

import Foundation
import CoenttbHTML
import Languages

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
    let languages: [Language]
    let hreflang: (Languages.Language) -> URL
    @HTMLBuilder let styles: () -> Styles
    @HTMLBuilder let favicons: () -> Favicons
    @HTMLBuilder let scripts: () -> Scripts

    public init(
        title: String?,
        description: String?,
        themeColor: HTMLColor,
        canonicalHref: URL?,
        rssXml: URL?,
        language: Language,
        languages: [Language],
        hreflang: @escaping (Languages.Language) -> URL,
        @HTMLBuilder styles: @escaping  () -> Styles,
        @HTMLBuilder favicons: @escaping () -> Favicons,
        @HTMLBuilder scripts: @escaping () -> Scripts
    ) {
        self.title = title
        self.description = description
        self.themeColor = themeColor
        self.language = language
        self.languages = languages
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
        meta()
            .attribute("charset", "UTF-8")
        if let canonicalHref {
            link()
                .attribute("rel", "canonical")
                .attribute("href", canonicalHref.absoluteString)
        }
        if
            let title,
            let rssXml {
            link()
                .attribute("rel", "alternate")
                .attribute("type", "application/rss+xml")
                .attribute("title", "\(title) RSS Feed")
                .attribute("href", "\(rssXml.relativeString)")
        }
        HTMLForEach(self.languages.filter { $0 != language }) { lx in
            link()
                .attribute("rel", "alternate")
                .attribute("hreflang", "\(lx.rawValue)")
                .attribute("href", "\(hreflang(lx))")
        }
        meta()
            .attribute("name", "theme-color")
            .attribute("content", themeColor.light.description)
            .attribute("media", "(prefers-color-scheme: light)")
        meta()
            .attribute("name", "theme-color")
            .attribute("content", themeColor.dark?.description)
            .attribute("media", "(prefers-color-scheme: dark)")
        meta()
            .attribute("name", "viewport")
            .attribute("content", "width=device-width, initial-scale=1.0, viewport-fit=cover")
        styles()
        favicons()
        scripts()
        if let title {
          meta()
            .attribute("name", "title")
            .attribute("content", title)
          meta()
            .attribute("property", "og:title")
            .attribute("content", title)
          meta()
            .attribute("name", "twitter:title")
            .attribute("content", title)
        }
        if let description {
          meta()
            .attribute("name", "description")
            .attribute("content", description)
          meta()
            .attribute("property", "og:description")
            .attribute("content", description)
          meta()
            .attribute("name", "twitter:description")
            .attribute("content", description)
        }
    }
}
