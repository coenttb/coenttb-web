import Foundation
import CoenttbHTML

public struct PageModule<Title: HTML, Content: HTML>: HTML {
    let title: Title?
    var theme: PageModule.Theme
    let content: Content
    
    public init(
        theme: PageModule.Theme,
        @HTMLBuilder content: () -> Content,
        @HTMLBuilder title: () -> Title
    ) {
        self.title = title()
        self.theme = theme
        self.content = content()
    }
    
//    public init(
//        title: String,
//        seeAllURL: String? = nil,
//        theme: PageModule.Theme,
//        @HTMLBuilder content: () -> Content
//    ) where Title == Header<HTMLText> {
//        self.title = Header(3) { HTMLText(title) }
//        self.theme = theme
//        self.content = content()
//    }
    
    public init(
        theme: PageModule.Theme,
        @HTMLBuilder content: () -> Content
    ) where Title == Never {
        self.title = nil
        self.theme = theme
        self.content = content()
    }
    
    public var body: some HTML {
        div {
            if let title {
                title
            }
            content
        }
        .flexContainer(
            direction: .column,
            wrap: .wrap,
            justification: theme.gridJustification,
            itemAlignment: theme.itemAlignment
        )
        .maxWidth(1280.px)
        .margin(vertical: 0, horizontal: .auto, media: .desktop)
        .padding(top: theme.topMargin, horizontal: theme.leftRightMargin, bottom: theme.bottomMargin)
        .padding(top: theme.topMargin, horizontal: theme.leftRightMarginDesktop, bottom: theme.bottomMargin, media: .desktop)
    }
}

public struct PageModuleSeeAllTitle<Title: HTML>: HTML {
    
    let seeAllURL: String
    let title: Title
    
    public init(
        seeAllURL: String,
        @HTMLBuilder title: () -> Title
    ) {
        self.seeAllURL = seeAllURL
        self.title = title()
    }
    
    public init(
        title: String,
        seeAllURL: String
    ) where Title == Header<HTMLText> {
        self.title = Header(3) { HTMLText(title) }
        self.seeAllURL = seeAllURL
    }
    
    
    public var body: some HTML {
            div {
                title
                Link("\(String.see_all.capitalizingFirstLetter().description) →", href: seeAllURL)
            }
            .width(100.percent)
            .flexContainer(
                direction: .row,
                wrap: .nowrap,
                justification: .spaceBetween,
                itemAlignment: .center
            )
            .flexItem(basis: .length(100.percent))
    }
}

extension PageModule {
    public struct Theme {
        let topMargin: Length
        let bottomMargin: Length
        let leftRightMargin: Length
        let leftRightMarginDesktop: Length
        let gridJustification: JustifyContent
        let itemAlignment: AlignItems
        
        public init(
            topMargin: Length,
            bottomMargin: Length,
            leftRightMargin: Length,
            leftRightMarginDesktop: Length,
            gridJustification: JustifyContent = .flexStart,
            itemAlignment: AlignItems = .baseline
        ) {
            self.topMargin = topMargin
            self.bottomMargin = bottomMargin
            self.leftRightMargin = leftRightMargin
            self.leftRightMarginDesktop = leftRightMarginDesktop
            self.gridJustification = gridJustification
            self.itemAlignment = itemAlignment
        }
    }
}

extension PageModule.Theme {
    public static var credits: Self {
        Self(
            topMargin: 2.rem,
            bottomMargin: 0.rem,
            leftRightMargin: 2.rem,
            leftRightMarginDesktop: 3.rem
        )
    }
    
    public static var content: Self {
        Self(
            topMargin: 4.rem,
            bottomMargin: 4.rem,
            leftRightMargin: 2.rem,
            leftRightMarginDesktop: 3.rem
        )
    }
    
    public static var whatPeopleAreSaying: Self {
        Self(
            topMargin: 4.rem,
            bottomMargin: 4.rem,
            leftRightMargin: 2.rem,
            leftRightMarginDesktop: 3.rem,
            itemAlignment: .center
        )
    }
}
