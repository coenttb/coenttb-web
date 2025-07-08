//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 02/07/2025.
//

import Foundation
import Testing
import HTMLTestSupport
import Coenttb_Web_HTML

@Suite(
    "Tests",
    .snapshots(record: .failed)
)
struct Tests {
    @Test("Label and input with light- and darkmode color")
    func labelAndInputWithLightAndDarkmodeColor() {
        assertInlineSnapshot(
            of: HTMLDocument {
                CallToActionModule(
                    title: (content: "String", color: .black),
                    blurb: (content: "String", color: .blue)
                )
            },
            as: .html
        ) {
            """
            <!doctype html>
            <html lang="en">
              <head>
                <style>
            .row-gap-NKv2f3{row-gap:0.5rem}
            .flex-wrap-6YEaQ3{flex-wrap:wrap}
            .flex-direction-7gclL{flex-direction:column}
            .display-BvS8W3{display:flex}
            .padding-pRWYM{padding:4rem 2rem}
            .max-width-P6HnV{max-width:1280px}
            .margin-82zpd1{margin:0px auto}
            .color-K2J0r1{color:#121212}
            .line-height-auF6B{line-height:1.2}
            .font-weight-SywJI1{font-weight:700}
            .font-size-H64QF2{font-size:3rem}
            .margin-bottom-1rcXs4:not(:last-child){margin-bottom:0.75rem}
            .margin-top-rmfs01:not(:first-child){margin-top:1.75rem}
            .margin-QlFKs1{margin:0px}
            .max-width-3zifi{max-width:40rem}
            .color-XRqQ6{color:#3399ff}
            .line-height-9Qkso4{line-height:1.5}
            .font-weight-evfWi1{font-weight:normal}
            .font-variant-evfWi1{font-variant:normal}
            .font-style-evfWi1{font-style:normal}
            .font-stretch-evfWi1{font-stretch:normal}
            .font-size-dnNPN1{font-size:1rem}
            .font-family-TCJhi4{font-family:system-ui}
            .padding-right-QlFKs1{padding-right:0px}
            .padding-left-QlFKs1{padding-left:0px}
            .padding-top-QlFKs1{padding-top:0px}
            .padding-bottom-yQEjs3:not(:last-child){padding-bottom:0.5rem}
            only screen and (min-width: 832px){
              .align-items-GE99b{align-items:center}
              .padding-Pdq5F{padding:8rem}
              .text-align-GE99b{text-align:center}
              .margin-4mdLu{margin:0px auto}
            }
            @media (prefers-color-scheme: dark), print{
              .color-WCItz3{color:#121212}
              .color-4Jp5N2{color:#004477}
            }

                </style>
              </head>
              <body>
            <div>
              <div class="align-items-GE99b row-gap-NKv2f3 flex-wrap-6YEaQ3 flex-direction-7gclL display-BvS8W3 padding-Pdq5F padding-pRWYM max-width-P6HnV margin-82zpd1">
                <div class="text-align-GE99b">
                  <h2 class="color-WCItz3 color-K2J0r1 line-height-auF6B font-weight-SywJI1 font-size-H64QF2 margin-bottom-1rcXs4 margin-top-rmfs01 margin-QlFKs1">String
                  </h2>
                </div>
                <div class="text-align-GE99b">
                  <p class="max-width-3zifi margin-4mdLu color-4Jp5N2 color-XRqQ6 line-height-9Qkso4 font-weight-evfWi1 font-variant-evfWi1 font-style-evfWi1 font-stretch-evfWi1 font-size-dnNPN1 font-family-TCJhi4 line-height-9Qkso4 margin-QlFKs1 padding-right-QlFKs1 padding-left-QlFKs1 padding-top-QlFKs1 padding-bottom-yQEjs3">String
                  </p>
                </div>
              </div>
            </div>
              </body>
            </html>
            """
        }
    }
}
