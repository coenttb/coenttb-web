//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 14/09/2024.
//

import Foundation
import CoenttbHTML

import Foundation
import CoenttbHTML

public struct FontAwesomeScript: HTML {
    public init(){}
    public var body: some HTML {
        fontAwesomeScript
    }
}

public var fontAwesomeScript: some HTML {
    script()
        .src("https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js")
}

public struct FontAwesomeIcon: HTML {
    let icon: String
    let size: FontAwesomeIcon.Size
    let style: Style
    
    public init(
        icon: String,
        size: FontAwesomeIcon.Size = .normal,
        style: Style = .solid
    ) {
        self.icon = icon
        self.size = size
        self.style = style
    }
    
    public var body: some HTML {
        i()
            .attribute("class", "\(style.description) fa-\(icon) \(size.description)")
    }
}

extension FontAwesomeIcon: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self = .init(icon: value)
    }
}

extension FontAwesomeIcon {
    public enum Size: String, CaseIterable {
        case extraSmall, small, normal, large, extraLarge
        case x2, x3, x4, x5, x6, x7, x8, x9, x10

        var description: String {
            switch self {
            case .normal: return ""
            case .extraSmall: return "fa-xs"
            case .small: return "fa-sm"
            case .large: return "fa-lg"
            case .extraLarge: return "fa-xl"
            default: return "fa-\(rawValue)"
            }
        }
    }

    public enum Style: String {
        case solid, regular, light, thin, duotone, brands

        var description: String {
            switch self {
            case .solid: return "fas"
            case .regular: return "far"
            case .light: return "fal"
            case .thin: return "fat"
            case .duotone: return "fad"
            case .brands: return "fab"
            }
        }
    }
}


extension Label {
    init(
        alignment: VerticalAlign = .center,
        spacing: Length = 0.25.rem,
        fa icon: FontAwesomeIcon,
        @HTMLBuilder title: () -> Title
    ) where Icon == HTMLElement<FontAwesomeIcon> {
        self = .init(
            alignment: alignment,
            spacing: spacing,
            icon: {
                span {
                    icon
                }
            },
            title: title
        )
    }
    
    public init(
        alignment: VerticalAlign = .center,
        spacing: Length = 0.25.rem,
        size: FontAwesomeIcon.Size = .normal,
        style: FontAwesomeIcon.Style = .solid,
        fa icon: String,
        @HTMLBuilder title: () -> Title
    ) where Icon == HTMLElement<FontAwesomeIcon> {
        self = .init(
            alignment: alignment,
            spacing: spacing,
            icon: {
                span {
                    FontAwesomeIcon(icon: icon, size: size, style: style)
                }
            },
            title: title
        )
    }
    
    public init(
        alignment: VerticalAlign = .center,
        spacing: Length = 0.25.rem,
        size: FontAwesomeIcon.Size = .normal,
        style: FontAwesomeIcon.Style = .solid,
        fa icon: String,
        _ title: () -> String
    ) where Icon == HTMLElement<FontAwesomeIcon>, Title == HTMLText {
        self = .init(
            alignment: alignment,
            spacing: spacing,
            icon: {
                span {
                    FontAwesomeIcon(icon: icon, size: size, style: style)
                }
            },
            title: { HTMLText(title()) }
        )
    }
}
