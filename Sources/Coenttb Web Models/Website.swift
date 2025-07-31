//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 25/08/2024.
//

import Foundation
import Translating
import URLRouting

public struct Website<
    Page: Equatable & Sendable
>: Equatable & Sendable {
    public let language: Language?
    public let page: Page

    public init(
        language: Language? = nil,
        page: Page
    ) {
        self.language = language
        self.page = page
    }
}

extension Website {
    public struct Router<
        PageRouter: URLRouting.Router<Page>
    >: ParserPrinter {

        let pageRouter: PageRouter

        public init(
            pageRouter: PageRouter
        ) {
            self.pageRouter = pageRouter
        }

        public var body: some URLRouting.Router<Website> {
            Parse(.memberwise(Website.init)) {
                Optionally {
                    Path {
                        Parse(.string.representing(Language.self))
                    }
                }

                self.pageRouter
            }
        }
    }
}
