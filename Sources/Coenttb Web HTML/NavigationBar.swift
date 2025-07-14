//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 14/08/2024.
//

import Foundation
import CoenttbHTML
import Dependencies


public struct NavigationBar<
    Logo: HTML,
    CenteredItems: HTML,
    TrailingItems: HTML,
    MobileItems: HTML
>: HTML {
    let logo: Logo
    let centeredNavItems: CenteredItems
    let trailingNavItems: TrailingItems
    let mobileNavItems: MobileItems
    
    public init(
        @HTMLBuilder logo: () -> Logo,
        @HTMLBuilder centeredNavItems: () -> CenteredItems,
        @HTMLBuilder trailingNavItems: () -> TrailingItems,
        @HTMLBuilder mobileNavItems: () -> MobileItems
    ) {
        self.logo = logo()
        self.centeredNavItems = centeredNavItems()
        self.trailingNavItems = trailingNavItems()
        self.mobileNavItems = mobileNavItems()
    }
    
    public var body: some HTML {
        nav {
            div {
                logo
                    .lineHeight(0)
                centeredNavItems
                    .listStyle(.reset)
                    .display(Display.none, media: .mobile)
                trailingNavItems
                    .listStyle(.reset)
                    .display(Display.none, media: .mobile)
                MenuButton()
                mobileNavItems
                    .listStyle(.reset)
                       .flexItem(
                           grow: .number(1),
                           shrink: .number(1),
                           basis: .percent(100)
                       )
                       .margin(0)
                       .display(Display.none)
                       .display(.block, media: .mobile, pre: "input:checked ~")
            }
            .flexContainer(
                direction: .row,
                wrap: .wrap,
                justification: .spaceBetween,
                itemAlignment: .center
            )
            .padding(
                top: .rem(1.5),
                bottom: .rem(1.5),
                left: .rem(2),
                right: .rem(2)
            )
            .padding(.rem(1.5), media: .desktop)
            .maxWidth(.px(1280))
            .margin(vertical: 0, horizontal: .auto)
        }
        .width(.percent(100))
        .position(.sticky, media: .mobile)
        .top(0, media: .mobile)
        .zIndex(9999)
    }
    

    struct MenuButton: HTML {
        public var body: some HTML {
            input.checkbox()
                .id("menu-checkbox")
                .display(Display.none)
            
            Bars()
                .display(Display.none, media: .desktop)
        }
        
        struct Bars: HTML {
            public var body: some HTML {
                label {
                    HTMLForEach(-1...1) { index in
                        Bar(index: index)
                    }
                }
                .id("menu-icon")
                .attribute("for", "menu-checkbox")
                .cursor(.pointer)
                .inlineStyle("user-select", "none")
                .display(.block)
                .position(.relative)
                .width(.px(24))
                .height(.px(18)) // Enough height for 3 bars with spacing
            }
        }
        
        struct Bar: HTML {
            let index: Int
            public var body: some HTML {
                span {}
                    .position(.absolute)
                    .width(.px(24))
                    .height(.px(3))
                    .backgroundColor(.black.withDarkColor(.gray900))
                    .borderRadius(.px(1.5))
                    .transition("all .2s ease-out, background .2s ease-out")
                    .top(.px(Double(index + 1) * 6)) // Position bars: 6px, 12px, 18px from top
                    .left(0)
                    // Animation states
                    .top(index == 0 ? .px(9) : nil, pre: "input:checked ~ #menu-icon")
                    .top(index == 1 ? .px(9) : nil, pre: "input:checked ~ #menu-icon")
                    .top(index == -1 ? .px(9) : nil, pre: "input:checked ~ #menu-icon")
                    .transform("rotate(\(index == 1 ? 45 : index == -1 ? -45 : 0)deg)", pre: "input:checked ~ #menu-icon")
                    .opacity(index == 0 ? 0 : 1, pre: "input:checked ~ #menu-icon")
            }
        }
    }
}


public struct Login {
    let isLoggedIn: Bool
    let accountHref: String
    let signupHref: String
    let loginHref: String
    
    public init(isLoggedIn: Bool, accountHref: String, signupHref: String, loginHref: String) {
        self.isLoggedIn = isLoggedIn
        self.accountHref = accountHref
        self.signupHref = signupHref
        self.loginHref = loginHref
    }
}

public struct NavigationBarSVGLogo: HTML {
    let href: Href
    let svg: SVG
    
    public init(
        href: Href,
        svg: () -> SVG
    ) {
        self.svg = svg()
        self.href = href
    }
    
    public var body: some HTML {
        CoenttbHTML.Link(href: href) {
            svg
        }
    }
}

public struct NavigationBarCenteredNavItems: HTML {
    
    let items: [NavListItem]
    
    public init(items: [NavListItem]) {
        self.items = items
    }
    
    public var body: some HTML {
        ul {
            HTMLGroup {
                HTMLForEach(self.items) { item in
                    item
                }
            }
            .padding(left: .rem(1.5), media: .desktop)
        }
        
    }
    
    
    public struct NavListItem: HTML {
        let title: String
        let href: Href
        
        public init(_ title: String, href: Href) {
            self.title = title
            self.href = href
        }
        public var body: some HTML {
            li {
                CoenttbHTML.Link(
                    title,
                    href: href
                )
                    .padding(left: .rem(2), pseudo: .not(.firstChild))
            }
            .display(.inline)
        }
    }
}


public struct NavigationBarTrailingNavItems: HTML {
    
    let items: [NavListItem]
    
    public init(
        items: [NavListItem]
    ) {
        self.items = items
    }
    
    public var body: some HTML {
        ul {
            HTMLForEach(self.items) { item in
                item
            }
            .display(.inline)
            .padding(
                left: .rem(1),
                pseudo: .not(.firstChild)
            )
        }
    }
    
    public struct NavListItem: HTML {
        let title: String
        let href: Href
        
        public init(_ title: String, href: Href) {
            self.title = title
            self.href = href
        }
        public var body: some HTML {
            li {
                CoenttbHTML.Link(
                    title,
                    href: href
                )
                    .display(.block)
            }
        }
    }
}

public struct NavigationBarMobileNavItems: HTML {
    let login: Login?
    let items: [NavListItem]
    
    public init(
        login: Login?,
        items: [NavListItem]
    ) {
        self.login = login
        self.items = items
    }
    
    public var body: some HTML {
        HTMLText("TO BE DELETED")
//        ul {
//            HTMLForEach(self.items) { item in
//                li {
//                    item
//                }
//            }
//            .padding(top: 1.5.rem)
//            
//            if let login {
//                switch login.isLoggedIn {
//                case true:
//                    li {
//                        Button(
//                            tag: a,
//                            backgroundColor: .purple,
//                            foregroundColor: .white.withDarkColor(.black)
//                        ) {
//                            HTMLText("Account")
//                        }
//                        .textAlign(.center)
//                        .attribute("href", login.accountHref)
//                        .display(.block)
//                    }
//                case false:
//                    li {
//                        Button(
//                            tag: a,
//                            backgroundColor: .purple,
//                            foregroundColor: .white.withDarkColor(.black)
//                        ) {
//                            HTMLText("Login")
//                        }
//                        .textAlign(.center)
//                        .attribute(
//                            "href",
//                            login.loginHref
//                        )
//                        .display(.block)
//                    }
//                    
//                    li {
//
//                        Button(
//                            tag: a,
//                            backgroundColor: .purple,
//                            foregroundColor: .white.withDarkColor(.black)
//                        ) {
//                            HTMLText("Sign up")
//                        }
//                        .textAlign(.center)
//                        .attribute(
//                            "href",
//                            login.signupHref
//                        )
//                        .display(.block)
//                    }
//                }
//            } else {
//                HTMLEmpty()
//            }
//        }
    }
    
    public struct NavListItem: HTML {
        let title: String
        let href: Href
        
        public init(
            _ title: String,
            href: Href
        ) {
            self.title = title
            self.href = href
        }
        public var body: some HTML {
            
            CoenttbHTML.Link(
                title,
                href: href
            )
                .display(.block)
        }
    }
}



#if DEBUG && canImport(SwiftUI)
import SwiftUI

var content: some HTML {
    NavigationBar {
        div {}
    } centeredNavItems: {
        NavigationBarCenteredNavItems(
            items: [
                .init("hello", href: "#"),
                .init("THERE", href: "#")
            ]
        )
    } trailingNavItems: {
        NavigationBarTrailingNavItems(
            items: [
                .init("TEST", href: ""),
                .init("TEST2", href: "")
            ]
        )
    } mobileNavItems: {
        HTMLEmpty()
//            NavigationBarMobileNavItems.init(
//                login: nil,
//                items: [
//                    .init("TEST", href: ""),
//                    .init("TEST2", href: "")
//                ]
//            )
    }
}

let string = try! String(
    HTMLDocument {
        content
    }
)

#Preview {
    HTMLDocument {
        div {
            content
            .backgroundColor(.red)
        }
        
        HTMLText(
            string
        )
    }
    .frame(width: 450, height: 900)
    
    
}
#endif
