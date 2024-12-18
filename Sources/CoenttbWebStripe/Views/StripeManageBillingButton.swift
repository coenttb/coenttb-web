//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 17/09/2024.
//

import Foundation
import CoenttbWebHTML


public struct StripeManageBillingFeature<Button: HTML>: HTML {
    
    let form_id: String
    let createCustomerPortalSession: URL
    let button: Button
    
    public init(
        form_id: String = UUID().uuidString,
        createCustomerPortalSession: URL,
        @HTMLBuilder button: () -> Button
    ) {
        self.createCustomerPortalSession = createCustomerPortalSession
        self.form_id = form_id
        self.button = button()
    }
    
    public var body: some HTML {
        form {
            button
            .type(.submit)
            
            script {"""
                document.addEventListener('DOMContentLoaded', function() {
                    const form = document.getElementById('\(form_id)');
                    
                    form.addEventListener('submit', async function(event) {
                        event.preventDefault();
                        
                        try {
                            const response = await fetch(form.action, {
                                method: form.method,
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded',
                                    'Accept': 'application/json'
                                },
                                body: new URLSearchParams(new FormData(form))
                            });

                            if (!response.ok) {
                                throw new Error('Network response was not ok');
                            }

                            const responseData = await response.json();
                            
                            if (responseData.data && typeof responseData.data === 'string') {
                                // Redirect to the URL returned by the server
                                window.location.href = responseData.data;
                            } else {
                                throw new Error('Invalid response format');
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
            """}
        }
        .id(form_id)
        .action(createCustomerPortalSession.absoluteString)
        .method(.post)
    }
}
