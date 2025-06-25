//import CoenttbHTML
//
//public struct CallToActionModule<Content: HTML>: HTML {
//    
//    let title: (content: String, color: HTMLColor)
//    let blurb: (content: String, color: HTMLColor)?
//    let content: Content
//    
//    public init(
//        title: (content: String, color: HTMLColor),
//        blurb: (content: String, color: HTMLColor)?,
//        @HTMLBuilder content: () -> Content = { HTMLEmpty() }
//    ) {
//        self.title = title
//        self.blurb = blurb
//        self.content = content()
//    }
//    
//    public var body: some HTML {
//        div {
//            div {
//                HTMLGroup {
//                    div {
//                        Header(2) { HTMLRaw(title.content) }
//                            .color(title.color)
//                    }
//                    
//                    
//                    if let blurb {
//                        div {
//                            Paragraph(.big) { HTMLRaw(blurb.content) }
//                                .fontStyle(.body(.regular))
//                                .color(blurb.color)
//                                .margin(vertical: 0, horizontal: .auto, media: .desktop)
//                                .maxWidth(40.rem)
//                        }
//                    }
//                    content
//                }
//                .textAlign(.center, media: .desktop)
//            }
//            .margin(vertical: 0, horizontal: .auto)
//            .maxWidth(.px(1280))
//            .padding(vertical: .large, horizontal: .medium)
//            .padding(.extraLarge, media: .desktop)
//            .flexContainer(
//                direction: .column,
//                wrap: .wrap,
//                rowGap: .length(0.5.rem)
//            )
//            .alignItems(.center, media: .desktop)
//        }
//    }
//}
