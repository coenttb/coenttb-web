import Foundation
import CoenttbHTML

public struct PageHeader<Title: HTML, Blurb: HTML, CallToAction: HTML>: HTML {
    var title: Title
    var blurb: Blurb
    var callToAction: CallToAction?
    
    public init(
        title: String,
        @HTMLBuilder blurb: () -> Blurb,
        @HTMLBuilder callToAction: () -> CallToAction? = { Never?.none }
    ) where Title == HTMLText {
        self.title = HTMLText(title)
        self.blurb = blurb()
        self.callToAction = callToAction()
    }
    
    public init(
        @HTMLBuilder title: () -> Title,
        @HTMLBuilder blurb: () -> Blurb,
        @HTMLBuilder callToAction: () -> CallToAction? = { Never?.none }
    ) {
        self.title = title()
        self.blurb = blurb()
        self.callToAction = callToAction()
    }
    
    public var body: some HTML {
        VStack {
            HStack(alignment: .center) {
                div {
                    Header(2) { title }
                        .color(.black.withDarkColor(.white))
                    
                    Paragraph(.big) { blurb }
                        .fontStyle(.body(.regular))
                        .color(.gray150.withDarkColor(.gray800))
                }
                .grow()
                
                div {
                    callToAction
                }
                .color(.offWhite)
            }
            .boxSizing(.borderBox)
            .inlineStyle("flex-basis", "100%")
            .maxWidth(1280.px)
            .width(100.percent)
            .margin(vertical: 0, horizontal: .auto)
            .padding(vertical: 6.rem, horizontal: 2.rem)
            .padding(vertical: 8.rem, horizontal: 3.rem, media: .desktop)
        }
        .boxSizing(.borderBox)
        .boxSizing(.borderBox)
    }
}


    

public struct PageHeaderGradient {
    let bottom: HTMLColor
    let top: HTMLColor
    
    public init(bottom: HTMLColor, top: HTMLColor) {
        self.bottom = bottom
        self.top = top
    }
}

extension PageHeaderGradient {
    public static var pf: Self {
        .init(bottom: .init(light: .hex("E0E0E0"), dark: .hex("121212")), top: .init(light: .hex("B0B0B0"), dark: .hex("242424")))
    }
    
    public static var coenttb: Self {
        .init(bottom: .init(light: .hex("D3D3D3"), dark: .hex("242424")), top: .init(light: .hex("D6C4F2"), dark: .hex("6a5acd")))
    }
}
