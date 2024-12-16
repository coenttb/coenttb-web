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
                    .display(.none, media: .mobile)
                trailingNavItems
                    .listStyle(.reset)
                    .display(.none, media: .mobile)
                MenuButton()
                mobileNavItems
                    .listStyle(.reset)
                       .flexItem(
                           grow: .number(1),
                           shrink: .number(1),
                           basis: .length(100.percent)
                       )
                       .margin(0)
                       .display(.none)
                       .display(.block, media: .mobile, pre: "input:checked ~")
            }
            .flexContainer(
                direction: .row,
                wrap: .wrap,
                justification: .spaceBetween,
                itemAlignment: .center
            )
            .padding(top: 1.5.rem, right: 2.rem, bottom: 1.5.rem, left: 2.rem)
            .padding(1.5.rem, media: .desktop)
            .maxWidth(1280.px)
            .margin(vertical: 0, horizontal: .auto)
        }
        .width(100.percent)
        .position(.sticky, media: .mobile)
        .top(0, media: .mobile)
        .zIndex("9999")
    }
    

    struct MenuButton: HTML {
        public var body: some HTML {
            input()
                .id("menu-checkbox")
                .attribute("type", "checkbox")
                .display(.none)
            
            Bars()
                .id("menu-icon")
                .attribute("for", "menu-checkbox")
                .cursor(.pointer)
                .display(.none, media: .desktop)
                .inlineStyle("user-select", "none")
        }
        
        struct Bars: HTML {
            public var body: some HTML {
                label {
                    HTMLForEach(-1...1) { index in
                        Bar(index: index)
                    }
                    .size(width: .px(24), height: .px(3))
                    .background(.black.withDarkColor(.gray900))
                    .display(.block)
                    .border(.radius(1.5.px))
                    .transition("all .2s ease-out, background .2s ease-out")
                    .position(.relative)
                }
            }
        }
        
        struct Bar: HTML {
            let index: Int
            public var body: some HTML {
                span {}
                    .top(index == 0 ? nil : (index * 5).px)
                    .top(index == 0 ? nil : index == 1 ? (-5).px : 0, pre: "input:checked ~ #menu-icon")
                    .transform("rotate(\(index * 45)deg)", pre: "input:checked ~ #menu-icon")
                    .background(index == 0 ? HTMLColor.transparent : nil, pre: "input:checked ~ #menu-icon")
                
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
    let href: String
    let svg: SVG
    
    public init(
        href: String,
        svg: () -> SVG
    ) {
        self.svg = svg()
        self.href = href
    }
    
    public var body: some HTML {
        Link.init(href: href) {
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
            .padding(left: 1.5.rem, media: .desktop)
        }
        
    }
    
    
    public struct NavListItem: HTML {
        let title: String
        let href: String
        public init(_ title: String, href: String) {
            self.title = title
            self.href = href
        }
        public var body: some HTML {
            li {
                Link(title, href: href)
                    .padding(left: 2.rem, pseudo: .not(.firstChild))
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
            .padding(left: 1.rem, pseudo: .not(.firstChild))
        }
    }
    
    public struct NavListItem: HTML {
        let title: String
        let href: String
        
        public init(_ title: String, href: String) {
            self.title = title
            self.href = href
        }
        public var body: some HTML {
            li {
                Link(title, href: href)
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
        let href: String
        public init(_ title: String, href: String) {
            self.title = title
            self.href = href
        }
        public var body: some HTML {
            
            Link(title, href: href)
                .display(.block)
        }
    }
}



