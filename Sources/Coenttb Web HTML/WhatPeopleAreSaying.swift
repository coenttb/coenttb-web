////
////  File.swift
////  coenttb-web
////
////  Created by Coen ten Thije Boonkkamp on 25/08/2024.
////
//
//import Foundation
//import CoenttbHTML
//import Languages
//
//public struct WhatPeopleAreSaying: HTML {
//    
//    let testimonials: [Testimonial]
//    
//    public init(testimonials: [Testimonial]) {
//        self.testimonials = testimonials
//    }
//    
//    public var body: some HTML {
//        PageModule(theme: .whatPeopleAreSaying) {
//            VStack(alignment: .center) {
//                LazyVGrid(
//                    columns: [.desktop: [1, 1, 1]],
//                    horizontalSpacing: 1.rem,
//                    verticalSpacing: 1.rem
//                ) {
//                    for (offset, group) in testimonials.prefix(9)
//                        .grouped(into: 3).enumerated()
//                    {
//                        VStack {
//                            for testimonial in group {
//                                TestimonialCard(testimonial: testimonial)
//                                    .margin(top: 1.rem, right: 0, bottom: 2.rem, left: 0)
//                            }
//                        }
//                        .display(offset == 0 ? nil : Display.none)
//                        .display(.block, media: .desktop)
//                    }
//                }
//            }
//        } title: {
//            Header(3) {
//                TranslatedString(
//                    dutch: "Wat mensen zeggen",
//                    english: "What people are saying"
//                )
//            }
//            .padding(bottom: 3.rem)
//        }
//        
//        .background(.white.withDarkColor(.black))
//    }
//    
//    struct TestimonialCard: HTML {
//        let testimonial: Testimonial
//        
//        var body: some HTML {
//            Card {
//                
//                a {
//                    VStack {
//                        HStack(alignment: .center) {
//                            Image(source: testimonial.avatarURL ?? "", description: "")
//                            .loading(.lazy)
//                            .size(width: .rem(3), height: .rem(3))
//                            .border(.radius(1.5.rem))
//                            .backgroundColor(.gray650.withDarkColor(.gray300))
//                            
//                            VStack(spacing: 0.rem) {
//                                div {
//                                    Header(5) {
//                                        HTMLText(testimonial.name ?? "")
//                                    }
//                                }
//                                
//                                div {
//                                    Header(6) {
//                                        HTMLText(testimonial.title)
//                                    }
//                                }
//                                .font(.weight(.normal))
//                                
//                                .color(.gray400.withDarkColor(.gray400))
//                            }
//                        }
//                        .padding(top: .extraSmall)
//                        
//                        
//                        Paragraph {
//                            HTMLText(testimonial.quote)
//                        }
//                    }
//                }
//                .color(.black.withDarkColor(.white))
//                .attribute("href", testimonial.source)
//                .inlineStyle("text-decoration-line", "none")
//                .display(.block)
//            }
//            .backgroundColor(.cardBackground)
//            .margin(top: 1.rem, right: 0, bottom: 2.rem, left: 0)
//            .margin(bottom: 1.rem, pseudo: .not(.lastChild))
//            
//            
//        }
//    }
//}
//
//extension Collection {
//    fileprivate func grouped(into numberOfGroups: Int) -> [[Element]] {
//        var groups: [[Element]] = []
//        for (offset, element) in self.enumerated() {
//            let index = offset.quotientAndRemainder(dividingBy: numberOfGroups).remainder
//            if index >= groups.count { groups.append([]) }
//            groups[index].append(element)
//        }
//        return groups
//    }
//}
//
//public struct Testimonial {
//    let name: String?
//    let title: String
//    let source: String
//    let avatarURL: String?
//    let quote: String
//    
//    public init(
//        name: String?,
//        title: String,
//        source: String,
//        avatarURL: String? = nil,
//        quote: String
//    ) {
//        self.avatarURL = avatarURL
//        self.quote = quote
//        self.name = name
//        self.source = source
//        self.title = title
//    }
//}
//
