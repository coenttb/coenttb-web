//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 19/09/2024.
//


import Dependencies
import Foundation
import HTML

public struct CircleIconButton: HTML {
    let button: HTMLElementTypes.Button
    let icon: FontAwesomeIcon
    let color: HTMLColor
    let buttonSize: CSSPropertyTypes.Size

    public init(
        button: HTMLElementTypes.Button = .init(
            type: nil,
            disabled: nil,
            form: nil,
            name: nil,
            value: nil,
            autofocus: nil,
            formaction: nil,
            formenctype: nil,
            formmethod: nil,
            formnovalidate: nil,
            formtarget: nil,
            popovertarget: nil,
            popovertargetaction: nil
        ),
        icon: FontAwesomeIcon,
        color: HTMLColor,
        href: Href,
        buttonSize: CSSPropertyTypes.Size = .single(.rem(2.5))
    ) {
        self.button = button
        self.icon = icon
        self.color = color
        self.buttonSize = buttonSize
    }

    public var body: some HTML {
        button {
            span { icon }
                .color(color)
        }
        .size(buttonSize)
        .display(.flex)
        .alignItems(.center)
        .justifyContent(.center())
    }
}
