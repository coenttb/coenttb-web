//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 16/08/2024.
//

import Foundation
import CoenttbHTML
import Favicon
import Languages
import Dependencies
import CoenttbWebDependencies

public struct CoenttbWebHTMLDocumentHeader<
    Styles: HTML,
    Scripts: HTML
>: HTML {
    let title: String?
    let description: String?
    let canonicalHref: URL?
    let rssXml: URL?
    let themeColor: HTMLColor
    let language: Languages.Language
    let hreflang: (Languages.Language) -> URL
    let styles: Styles
    let scripts: Scripts
    let favicons: Favicons
    
    public init(
        title: String?,
        description: String?,
        canonicalHref: URL?,
        rssXml: URL?,
        themeColor: HTMLColor,
        language: Languages.Language,
        hreflang: @escaping (Languages.Language) -> URL,
        @HTMLBuilder styles: () -> Styles,
        @HTMLBuilder scripts: () -> Scripts,
        @HTMLBuilder favicons: () -> Favicons
    ) {
        self.title = title
        self.description = description
        self.canonicalHref = canonicalHref
        self.rssXml = rssXml
        self.themeColor = themeColor
        self.language = language
        self.hreflang = hreflang
        self.styles = styles()
        self.scripts = scripts()
        self.favicons = favicons()
    }
    
    @Dependencies.Dependency(\.languages) var languages
    
    public var body: some HTML {
        WebHTMLDocumentHeader(
            title: title,
            description: description,
            themeColor: themeColor,
            canonicalHref: canonicalHref,
            rssXml: rssXml,
            language: language,
            hreflang: hreflang,
            styles: {
                style { "\(renderedNormalizeCss)" }
                style {"""
                html {
                    font-family: ui-sans-serif, -apple-system, Helvetica Neue, Helvetica, Arial, sans-serif;
                    line-height: 1.6;
                    box-sizing: border-box;
                    color: #000;
                }
                code, pre, tt, kbd, samp {
                    font-family: 'SF Mono', SFMono-Regular, ui-monospace, Menlo, Monaco, Consolas, monospace;
                }
                body {
                    box-sizing: border-box;
                    background: #fff;
                    transition: background 0.3s, color 0.3s;
                }
                *, *::before, *::after {
                    box-sizing: inherit;
                }
                @media (prefers-color-scheme: dark) {
                    html {
                        color: #e0e0e0;
                    }
                    body {
                        background: #121212;
                    }
                }
                @media only screen and (min-width: 832px) {
                    html {
                        font-size: 16px;
                    }
                }
                @media only screen and (max-width: 831px) {
                    html {
                        font-size: 14px;
                    }
                }                
                ul, ol, li {
                    margin-block-start: 0;
                    margin-block-end: 0;
                }
                
                p + ul, p + ol, p + li {
                    margin-block-start: inherit;
                    margin-block-end: inherit;
                }
                """}
                styles
            },
            favicons: { favicons },
            scripts: { scripts }
        )
    }
}
