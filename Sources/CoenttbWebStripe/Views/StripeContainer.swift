//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 17/09/2024.
//

import Foundation
import CoenttbWebHTML

public struct StripeContainer<
    SidebarContent: HTML,
    MainContent: HTML,
    MobileHeader: HTML
>: HTML {
    private let sidebar: Sidebar
    private let main: MainContent
    private let mobileHeader: MobileHeader

    public struct Sidebar {
        let background: HTMLColor?
        let content: SidebarContent

        public init(
            background: HTMLColor? = nil,
            @HTMLBuilder content: () -> SidebarContent
        ) {
            self.background = background
            self.content = content()
        }
    }

    public init(
        sidebar: Sidebar,
        @HTMLBuilder main: () -> MainContent,
        @HTMLBuilder mobileHeader: () -> MobileHeader
    ) {
        self.sidebar = sidebar
        self.main = main()
        self.mobileHeader = mobileHeader()
    }

    public var body: some HTML {
        div {
            _mobileHeader
            desktopLayout
        }
        .height(100.vh)
        .overflowX(.hidden)
        .overflowY(.hidden)
    }

    private var _mobileHeader: some HTML {
        div {
            mobileHeader
        }
        .width(100.vw)
        .backgroundColor(sidebar.background)
        .display(.none, media: .desktop)
    }

    private var desktopLayout: some HTML {
        div {
            sidebarContent
            mainContent
        }
        .display(.flex)
        .flexDirection(.column, media: .mobile)
        .flexDirection(.row, media: .desktop)
        .height(100.vh)
        .overflowX(.hidden)
    }

    private var sidebarContent: some HTML {
        div {
            sidebar.content
        }
//        .rightBorderShadow()
        .inlineStyle("flex", "1 auto")
        .overflowY(.auto)
        .backgroundColor(sidebar.background)
        .maxWidth(576.px, media: .desktop)
        .minWidth(310.px, media: .desktop)
        .width(51.vw, media: .desktop)
        .display(.none, media: .mobile)
        
    }

    private var mainContent: some HTML {
        div {
            main
        }
        .inlineStyle("flex", "1 auto")
//        .flex(1, basis: .auto)
//        .padding(vertical: 2.rem, horizontal: 3.rem)
        .overflowY(.auto)
        .width(100.percent)
        .inlineStyle("box-shadow", "rgba(0, 0, 0, 0.18) 15px 0px 30px 0px")
    }
}
