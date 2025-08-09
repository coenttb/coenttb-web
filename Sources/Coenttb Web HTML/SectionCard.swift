//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 20/09/2024.
//

import Foundation
import Dependencies
import CoenttbHTML

public struct SectionCard: HTML {
    let title: String
    let subtitle: String
    let href: String
    let icon: FontAwesomeIcon
    
    @Dependency(\.theme.text.link) var color
    
    public init(
        title: String,
        subtitle: String,
        href: String,
        icon: FontAwesomeIcon
    ) {
        self.title = title
        self.subtitle = subtitle
        self.href = href
        self.icon = icon
    }
    
    public var body: some HTML {
            a {
                HStack(
                    alignment: .center,
                    spacing: 0.75.rem
                ) {
                    span { icon }
                        .color(color)
                        .padding(.all(.length(.extraSmall)))
                        .backgroundColor(.cardBackground)
                        .borderRadius(.percentage(20))
                        .size(.px(32))
                        .display(.flex)
                        .alignItems(.center)
                        .justifyContent(.center)
                    
                    VStack(
                        alignment: .leading,
                        spacing: 0.rem
                    ) {
                        h5 { HTMLText(title) }
                            .margin(.all(.zero))
//                            .padding(Padding?.none)
//                            .color(color)
//                            .fontSize(.primary)
                        
                        p { HTMLText(subtitle) }
                            .margin(.all(.zero))
//                            .padding(Padding?.none)
//                            .color(.text.primary)
//                            .fontSize(.secondary)
                    }
                }
            }
//            .border(.radius(8.px))
//            .transition("background-color 0.3s ease;")
//            .backgroundColor(.cardBackground, media: .desktop, pseudo: .hover)
//            .padding(.trbl(top: .extraSmall, right: .medium, bottom: .extraSmall, left: .extraSmall))
//            .textDecoration(.none)
//            .href(href)
        }
}

extension AlignItems {
    public static let leading: Self = .start
    public static let trailing: Self = .end
    public static let center: Self = .center(nil)
}

extension VerticalAlign {
    public static let center: Self = .middle
}

