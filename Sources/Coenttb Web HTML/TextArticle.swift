//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 25/08/2024.
//

import Foundation
import CoenttbHTML

public struct TextArticle<Content: HTML>: HTML {
    let content: Content
    
    public init(
        @HTMLBuilder content: () -> Content
    ) {
        self.content = content()
    }
    
    public var body: some HTML {
        article {
            content
        }
//        .color(.gray150.withDarkColor(.gray800))
        .color(.text.primary)
        .linkColor(.text.primary)
        .linkUnderline(true)
        .margin(vertical: 0, horizontal: .auto, media: .desktop)
        .width(60.percent, media: .desktop)
    }
}
