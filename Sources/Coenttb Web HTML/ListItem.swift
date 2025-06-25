//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 25/08/2024.
//

import Foundation
import CoenttbHTML

public struct ListItem<
    Bullet: HTML,
    Content: HTML
>: HTML {
    let bullet: Bullet
    let content: Content
        
    public init(
        @HTMLBuilder bullet: () -> Bullet,
        @HTMLBuilder content: () -> Content
    ) {
        self.bullet = bullet()
        self.content = content()
    }
    
    public var body: some HTML {
        div {
            span {
                bullet
            }
            .margin(right: .rem(1))
            .margin(top: .rem(0.125))
            
            span {
                content
            }
        }
        .display(.flex)
        .alignItems(.flexStart)
    }
}
