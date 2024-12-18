//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 16/09/2024.
//


import Dependencies
import Foundation
import Languages
import Vapor
import CoenttbWebDependencies
import CoenttbWebHTML
import CoenttbMarkdown

//public struct PurchaseSubscriptions: HTML {
//    
//    @Dependency(\.serverRouter) var serverRouter
//    @Dependency(\.currentUser) var currentUser
//    
//    public init(){}
//    
//    public var body: some HTML {
//        let mainContentId = UUID().uuidString
//        let pricesContainerId = UUID().uuidString
//        let formContainerId = UUID().uuidString
//        let messageContainerId = UUID().uuidString
//        let priceId = Stripe.API.Subscription.Create.CodingKeys.priceId.rawValue
//        
//        VStack {
//            h1 { "Select a plan" }
//            div()
//                .id(pricesContainerId)
//            
//            div()
//                .id(formContainerId)
//                .display(.none)
//            
//            div()
//                .id(messageContainerId)
//                .display(.none)
//        }
//        .width(100.percent)
//        .maxWidth(20.rem, media: .desktop)
//        .maxWidth(24.rem, media: .mobile)
//        
//        script {"""
//            document.addEventListener('DOMContentLoaded', function() {
//                const pricesContainer = document.getElementById('\(pricesContainerId)');
//                const formContainer = document.getElementById('\(formContainerId)');
//                const messageContainer = document.getElementById('\(messageContainerId)');
//                
//                function showPrices() {
//                    fetch('\(serverRouter.url(for: .api(.v1(.stripe(.subscription(.config))))))')
//                        .then((response) => response.json())
//                        .then((data) => {
//                            pricesContainer.innerHTML = '';
//                            if (!data.prices || data.prices.length === 0) {
//                                pricesContainer.innerHTML = '<h3>No prices found</h3><p>Please contact support.</p>';
//                                return;
//                            }
//                            
//                            data.prices.forEach((price) => {
//                                const priceDiv = document.createElement('div');
//                                priceDiv.innerHTML = `
//                                    <span>
//                                        ${(price.unit_amount / 100).toFixed(2)} /
//                                        ${price.currency.toUpperCase()} /
//                                        ${price.recurring.interval}
//                                    </span>
//                                    <button onclick="selectPrice('${price.id}')">Select</button>
//                                `;
//                                pricesContainer.appendChild(priceDiv);
//                            });
//                        })
//                        .catch((error) => {
//                            console.error('Error:', error);
//                            pricesContainer.innerHTML = '<p>Error loading prices. Please try again later.</p>';
//                        });
//                }
//                
//                window.selectPrice = function(priceId) {
//                    pricesContainer.style.display = 'none';
//                    formContainer.style.display = 'block';
//                    formContainer.innerHTML = `
//                        \(String(decoding: subscriptionForm().render(), as: UTF8.self))
//                    `;
//                    
//                    const form = document.getElementById('subscription-form');
//                    form.addEventListener('submit', function(e) {
//                        e.preventDefault();
//                        createSubscription(priceId);
//                    });
//                    
//                    setupStripe();
//                }
//                
//                function createSubscription(priceId) {
//                    const form = document.getElementById('subscription-form');
//                    const formData = new FormData(form);
//                    const name = formData.get('name');
//                    
//                    fetch("\(serverRouter.url(for: .api(.v1(.stripe(.subscription(.create(.init())))))))", {
//                        method: 'POST',
//                        headers: {
//                            'Content-Type': 'application/x-www-form-urlencoded',
//                        },
//                        body: new URLSearchParams({
//                            name: name,
//                            priceId: priceId,
//                        }).toString()
//                    })
//                    .then((response) => response.json())
//                    .then((data) => {
//                        if (data.clientSecret) {
//                            confirmPayment(data.clientSecret, data.subscriptionId);
//                        } else {
//                            throw new Error('Subscription creation failed');
//                        }
//                    })
//                    .catch((error) => {
//                        console.error('Error:', error);
//                        showMessage('An error occurred. Please try again.');
//                    });
//                }
//                
//                function confirmPayment(clientSecret, subscriptionId) {
//                    stripe.confirmCardPayment(clientSecret, {
//                        payment_method: {
//                            card: cardElement,
//                            billing_details: {
//                                name: document.getElementById('name').value,
//                            },
//                        }
//                    }).then((result) => {
//                        if (result.error) {
//                            showMessage(`Payment failed: ${result.error.message}`);
//                        } else {
//                            showMessage('Success! Your subscription is active.');
//                            setTimeout(() => {
//                                window.location.href = '\(serverRouter.url(for: .account(.settings(.profile))))';
//                            }, 3000);
//                        }
//                    });
//                }
//                
//                function showMessage(message) {
//                    formContainer.style.display = 'none';
//                    messageContainer.style.display = 'block';
//                    messageContainer.innerHTML = `<p>${message}</p>`;
//                }
//                
//                let stripe, cardElement;
//                function setupStripe() {
//                    fetch('\(serverRouter.url(for: .api(.v1(.stripe(.subscription(.config))))))')
//                        .then((resp) => resp.json())
//                        .then((resp) => {
//                            stripe = Stripe(resp.publishableKey);
//                            const elements = stripe.elements();
//                            cardElement = elements.create('card');
//                            cardElement.mount('#card-element');
//                        });
//                }
//                
//                showPrices();
//            });
//        """}
//    }
//    
//    private func subscriptionForm() -> some HTML {
//        form {
//            VStack {
//                Input.default(Account.API.Update.CodingKeys.name)
//                    .type(.text)
//                    .placeholder(String.name.capitalizingFirstLetter().description)
//                    .value(currentUser?.name ?? "")
//                
//                div()
//                    .id("card-element")
//                
//                Button(
//                    tag: button
//                ) {
//                    String.subscribe.capitalizingFirstLetter()
//                }
//                .width(100.percent)
//                .type(.submit)
//                .display(.inlineBlock)
//            }
//        }
//        .id("subscription-form")
//    }
//}
//
