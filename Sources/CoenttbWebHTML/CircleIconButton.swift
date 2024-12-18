//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 19/09/2024.
//


import Dependencies
import Foundation


public struct CircleIconButton: HTML {
    let icon: FontAwesomeIcon
    let color: HTMLColor
    let href: String
    let buttonSize: CSS.Length

    public init(
        icon: FontAwesomeIcon,
        color: HTMLColor,
        href: String,
        buttonSize: CSS.Length = 2.5.rem
    ) {
        self.icon = icon
        self.color = color
        self.href = href
        self.buttonSize = buttonSize
    }

    public var body: some HTML {
        Button(
            tag: a,
            background: .transparent,
            style: .round
        ) {
            span { icon }
                .color(color)
        }
        .href(href)
        .size(buttonSize)
        .display(.flex)
        .alignItems(.center)
        .justifyContent(.center)
    }
}
