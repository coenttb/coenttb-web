//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 28/08/2024.
//

import CoenttbWebHTML
import Dependencies
import Foundation
import HTML
import Languages
import CoenttbWebTranslations

extension Route.Subscribe {
    public struct View: HTML {
        
        let form_id: String
        let caption: String
        let newsletterSubscribeAction: URL
        
        public init(
            form_id: String = UUID().uuidString,
            caption: String,
            newsletterSubscribeAction: URL
        ) {
            self.form_id = form_id
            self.caption = caption
            self.newsletterSubscribeAction = newsletterSubscribeAction
        }
        
        public var body: some HTML {
            PageModule(theme: .newsletterSubscription) {
                VStack {
                    Paragraph {
                        HTMLText(caption)
                    }
                    .textAlign(.center)
                    
                    NewsletterSubscriptionForm(form_id: form_id, newsletterSubscribeAction: newsletterSubscribeAction)
                }
                .maxWidth(30.rem, media: .desktop)
                .flexContainer(
                    direction: .column,
                    wrap: .wrap,
                    justification: .center,
                    itemAlignment: .center,
                    rowGap: .length(0.5.rem)
                )
            }
            title: {
                Header(4) {
                    String.subscribe_to_my_newsletter.capitalizingFirstLetter()
                }
            }
            .flexContainer(
                justification: .center,
                itemAlignment: .center
            )
        }
    }
}

extension PageModule.Theme {
    public static var newsletterSubscription: Self {
        Self(
            topMargin: 0.rem,
            bottomMargin: .large,
            leftRightMargin: .medium,
            leftRightMarginDesktop: .large,
            itemAlignment: .center
        )
    }
}

public struct NewsletterSubscriptionForm: HTML {
    let form_id: String
    let newsletterSubscribeAction: URL
    
    public init(form_id: String = UUID().uuidString, newsletterSubscribeAction: URL) {
        self.form_id = form_id
        self.newsletterSubscribeAction = newsletterSubscribeAction
    }
    
    public var body: some HTML {
        form {
            VStack {
                Input.default(CoenttbWebNewsletter.API.Subscribe.Request.CodingKeys.email)
                    .type(.email)
                    .value("")
                    .placeholder(
                        "\(String.type_your_email.capitalizingFirstLetter())..."
                    )

                div {
                    Button(
                        tag: button
                    ) {
                        "\(String.subscribe.capitalizingFirstLetter())"
                    }
                    .color(.secondary)
                    .type(.submit)
                    .display(.inlineBlock)
                }
                .flexContainer(
                    justification: .center,
                    itemAlignment: .center,
                    media: .desktop
                )
                
                div()
                    .id("\(form_id)-message")
            }
        }
        .id(form_id)
        .method(.post)
        .action(newsletterSubscribeAction.absoluteString)

        script {
            """
            document.addEventListener('DOMContentLoaded', function() {
                const form = document.getElementById("\(form_id)");
                const formContainer = form;

                form.addEventListener('submit', async function(event) {
                    event.preventDefault();

                    const formData = new FormData(form);
                    const email = formData.get('\(CoenttbWebNewsletter.API.Subscribe.Request.CodingKeys.email.rawValue)');

                    try {
                        const response = await fetch(form.action, {
                            method: form.method,
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                                'Accept': 'application/json'
                            },
                            body: new URLSearchParams({ \(CoenttbWebNewsletter.API.Subscribe.Request.CodingKeys.email.rawValue): email }).toString()
                        });


                        if (!response.ok) {
                            throw new Error('Network response was not ok');
                        }

                        const data = await response.json();

                        if (data.success) {
                            formContainer.innerHTML = `\(String(decoding: successSection.render(), as: UTF8.self))`;
                        } else {
                            throw new Error(data.message || 'Subscription failed');
                        }
            
                    } catch (error) {
                        console.error('Error:', error);
                        const messageDiv = document.createElement('div');
                        messageDiv.textContent = 'An error occurred. Please try again.';
                        messageDiv.style.color = 'red';
                        messageDiv.style.textAlign = 'center';
                        messageDiv.style.marginTop = '10px';
                        form.appendChild(messageDiv);
                    }
                });
            });
            """
        }
    }
    
    @HTMLBuilder
    var successSection: some HTML {
        VStack {
            Header(3) {
                "Successfully subscribed"
            }
            .color(.green)
            
            Paragraph {
                "Thank you for subscribing to our newsletter!"
            }
        }
        .textAlign(.center, media: .desktop)
    }
}
