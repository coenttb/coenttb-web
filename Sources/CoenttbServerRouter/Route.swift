//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 10/08/2022.
//


import Dependencies
import Foundation
import Languages
import URLRouting
import CasePaths

@CasePathable
@dynamicMemberLookup
public enum CoenttbServerRoute<
    API: Equatable & Sendable,
    WebsitePage: Equatable & Sendable,
    Public: Equatable & Sendable,
    Webhook: Equatable & Sendable
>: Equatable, Sendable {
    case api(API)
    case website(Website<WebsitePage>)
    case `public`(Public)
    case webhook(Webhook)
    case index
}

extension CoenttbServerRoute {
    public struct Router<
        APIRouter: URLRouting.Router<API> & Sendable,
        WebhookRouter: URLRouting.Router<Webhook> & Sendable,
        PageRouter: URLRouting.Router<WebsitePage> & Sendable,
        PublicRouter: URLRouting.Router<Public> & Sendable
    >: ParserPrinter & Sendable {
        let _baseURL: String
        let apiRouter: APIRouter
        let webhookRouter: WebhookRouter
        let publicRouter: PublicRouter
        let pageRouter: PageRouter
        
        public init(
            baseURL: URL,
            apiRouter: APIRouter,
            webhookRouter: WebhookRouter,
            publicRouter: PublicRouter,
            pageRouter: PageRouter
        ) {
            self._baseURL = baseURL.absoluteString
            self.apiRouter = apiRouter
            self.webhookRouter = webhookRouter
            self.publicRouter = publicRouter
            self.pageRouter = pageRouter
        }
        
        public var body: some URLRouting.Router<CoenttbServerRoute> {
            OneOf {

                URLRouting.Route(.case(CoenttbServerRoute.index))

                URLRouting.Route(.case(CoenttbServerRoute.api)) {
                    Path { "api" }
                    self.apiRouter
                }

                URLRouting.Route(.case(CoenttbServerRoute.webhook)) {
                    Path { "webhook" }
                    self.webhookRouter
                }

                URLRouting.Route(.case(CoenttbServerRoute.website)) {
                    Website.Router(pageRouter: self.pageRouter)
                }

                URLRouting.Route(.case(CoenttbServerRoute.public)) {
                    self.publicRouter
                }
            }
            .baseURL(self._baseURL)
        }
        
        public func href(for public: Public) -> String {
            self.url(for: .public(`public`)).relativePath
        }

        public func href(for website: Website<WebsitePage>) -> String {
            self.url(for: website).relativePath
        }

        public func url(for website: Website<WebsitePage>) -> URL {
            return self.url(for: .website(website))
        }
        
        public func url(for page: WebsitePage) -> URL {
            @Dependency(\.language) var language
            return self.url(for: .website(.init(language: language, page: page)))
        }
        
        public func href(for page: WebsitePage) -> String {
            @Dependency(\.language) var language
            return self.url(for: .website(.init(language: language, page: page))).relativePath
        }
    }
}
