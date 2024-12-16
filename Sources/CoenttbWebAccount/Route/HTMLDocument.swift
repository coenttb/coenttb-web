//
//  File.swift
//  tenthijeboonkkamp-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 16/08/2024.
//

import CoenttbWebHTML
import Dependencies
import Favicon
import Foundation
import Languages
import Vapor

public struct CoenttbWebAccountHTMLDocument<
    Body: HTML
>: HTMLDocument {
    let route: Route
    let title: (Route) -> String
    let description: (Route) -> String
    let primaryColor: HTMLColor
    let accentColor: HTMLColor
    let languages: [Languages.Language]
    let favicons: Favicons
    let canonicalHref: URL?
    let hreflang: (Route, Languages.Language) -> URL
    let termsOfUse: URL
    let privacyStatement: URL
    let _body: Body
    
    public init(
        route: Route,
        title: @escaping (Route) -> String,
        description: @escaping (Route) -> String,
        primaryColor: HTMLColor,
        accentColor: HTMLColor,
        languages: [Languages.Language],
        @HTMLBuilder favicons: () -> Favicons,
        canonicalHref: URL?,
        hreflang: @escaping (Route, Languages.Language) -> URL,
//        hotjarId: String?,
//        googleAnalyticsId: String?,
        termsOfUse: URL,
        privacyStatement: URL,
        @HTMLBuilder body: () -> Body
    ) {
        self.route = route
        self.title = title
        self.description = description
        self.primaryColor = primaryColor
        self.accentColor = accentColor
        self.languages = languages
        self.favicons = favicons()
        self.canonicalHref = canonicalHref
        self.hreflang = hreflang
        self.termsOfUse = termsOfUse
        self.privacyStatement = privacyStatement
        self._body = body()
    }
    
    public var head: some HTML {
        CoenttbWebHTMLDocumentHeader(
            title: title(route),
            description: description(route),
            canonicalHref: canonicalHref,
            themeColor: accentColor,
            language: language,
            languages: languages,
            hreflang: { language in hreflang(route, language) },
            styles: { HTMLEmpty() },
            scripts: { fontAwesomeScript },
            favicons: { favicons }
        )
    }
    
    @Dependencies.Dependency(\.language) var language
    
    public var body: some HTML {
        HTMLGroup {
            _body
            
            IdentityFooter(
                termsOfUse: self.termsOfUse,
                privacyStatement: self.privacyStatement
            )
            
        }
        .dependency(\.language, language)
        .linkColor(self.primaryColor)
    }
}


extension CoenttbWebAccountHTMLDocument: AsyncResponseEncodable {}

//public struct CoenttbWebAccountHTMLDocumentHeader<
//    Styles: HTML,
//    Scripts: HTML
//>: HTML {
//    public init?(
//        accentColor: HTMLColor ,
//        languages: [Languages.Language] = Languages.Language.allCases,
//        @HTMLBuilder favicons: () -> Favicons,
//        hotjarId: String?,
//        googleAnalyticsId: String?,
//        canonicalHost: String,
//        canonicalHref: URL
//    ) {
//        @Dependency(\.language) var language
//        
////        @Dependency(\.serverRouter) var siteRouter
////        @Dependency(\.route.website?.page) var page
////        @Dependency(\.envVars.hotjar_analytics_id) var hotjarId
////        @Dependency(\.envVars.google_analytics_id) var googleAnalyticsId
////        @Dependency(\.envVars.canonicalHost) var canonicalHost
//        
////        guard let page
////        else { return nil }
//        
////        let title: String = switch page.title?.capitalizingFirstLetter() {
////        case nil:
////            "\(CoenttbWebAccount.title)"
////        case let .some(description):
////            "\(description) - \(CoenttbWebAccount.title)"
////        }
//        
////        let canonicalHref = URL(string: "https://tenthijeboonkkamp.nl\(siteRouter.href(for: page))")!
////        let description = page.description()?.description
////        let hreflang = { siteRouter.url(for: .init(language: $0, page: page)) }
//        let hreflang = { fatalError() }
//        
////        self.body = CoenttbWebHTMLDocumentHeader(
////            title: "title",
////            description: "description",
////            canonicalHref: canonicalHref,
////            accentColor: accentColor,
////            language: language,
////            languages: languages,
////            hreflang: hreflang,
////            googleAnalyticsId: googleAnalyticsId ?? "",
////            hotjarId: hotjarId ?? "",
////            styles: { HTMLEmpty() },
////            scripts: { HTMLGroup{
////                fontAwesomeScript
////            } },
////            favicons: favicons
////        )
//    }
//    
//    public let body: CoenttbWebHTMLDocumentHeader<Styles, Scripts>
//}
