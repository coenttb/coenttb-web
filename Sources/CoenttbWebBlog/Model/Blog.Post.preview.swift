//
//  File.swift
//  coenttb-nl-server
//
//  Created by Coen ten Thije Boonkkamp on 20/08/2024.
//

import CoenttbMarkdown
import CoenttbWebHTML
import Date
import Dependencies
import Foundation
import Languages

extension [CoenttbWebBlog.Blog.Post] {
    public static let preview: [CoenttbWebBlog.Blog.Post] = [
        .init(
            id: .init(),
            index: 1,
            publishedAt: .now,
            image: HTMLEmpty(),
            title: TranslatedString(
                dutch: "Een blik op AI en gegevensbescherming: Wat betekent de GDPR voor AI-projecten?",
                english: "A Look at AI and Data Protection: What Does the GDPR Mean for AI Projects?"
            ).description,
            hidden: .preview,
            blurb: """
            \(
                TranslatedString(
                    dutch: """
                    AI verandert de manier waarop we gegevens verwerken en analyseren, maar brengt ook complexe juridische vragen met zich mee, vooral op het gebied van privacy. In deze blog onderzoekt Coen ten Thije Boonkkamp hoe de GDPR zich verhoudt tot de opkomst van AI. Van praktische richtlijnen tot uitdagende grijze gebieden, deze blog biedt inzichten voor juristen, ontwikkelaars en beleidsmakers die AI op een conforme manier willen implementeren.
                    """,
                    english: """
                    Artificial Intelligence (AI) is reshaping how we process and analyze data, but it also raises challenging legal questions, particularly around privacy. In this blog post, Coen ten Thije Boonkkamp explores the intersection of AI and the General Data Protection Regulation (GDPR). From practical guidelines to navigating gray areas, this post provides insights for legal professionals, developers, and policymakers seeking to implement AI in a compliant way.
                    """
                )
            )
            """,
            estimatedTimeToComplete: 12.minutes,
            permission: .free
        )
    ]
}
