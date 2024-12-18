//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 10/09/2024.
//

import Foundation
import CoenttbWebHTML
import Foundation
import CoenttbWebHTML
import Foundation
import CoenttbWebHTML

public struct StripePaymentElement: HTML {
    let configUrl: String
    let createPaymentIntentUrl: String
    let returnUrl: String
    
    public init(configUrl: String, createPaymentIntentUrl: String, returnUrl: String) {
        self.configUrl = configUrl
        self.createPaymentIntentUrl = createPaymentIntentUrl
        self.returnUrl = returnUrl
    }
    
    public var body: some HTML {
        HTMLGroup {
            form {
                
                // Elements will create authentication element here
                div()
                .id("link-authentication-element")
                
                // Elements will create form elements here
                div()
                .id("payment-element")
                
                button {
                    "Pay now"
                }
                .id("submit")
                
                // Display error message to your customers here
                div()
                .id("error-message")
            }
            .id("payment-form")
            
            // Messages will be displayed here
            div()
            .id("messages")
            .attribute("role", "alert")
            .attribute("style", "display: none;")
            
            script {
                """
                document.addEventListener('DOMContentLoaded', async () => {
                  // Load the publishable key from the server
                  const { publishableKey } = await fetch('\(configUrl)').then((r) => r.json());
                  if (!publishableKey) {
                    addMessage('No publishable key returned from the server. Please check `.env` and try again');
                    alert('Please set your Stripe publishable API key in the .env file');
                  }
                  const stripe = Stripe(publishableKey, {
                    apiVersion: '2020-08-27',
                  });

                  // Create a PaymentIntent on the server
                  const { error: backendError, clientSecret } = await fetch('\(createPaymentIntentUrl)').then((r) => r.json());
                  if (backendError) {
                    addMessage(backendError.message);
                  }

                  // Initial theme detection
                  let appearance = window.matchMedia('(prefers-color-scheme: dark)').matches
                    ? { theme: 'night' }
                    : { theme: 'stripe' };

                  // Initialize Stripe Elements with the current appearance
                  let elements = stripe.elements({ clientSecret, appearance });
                  let paymentElement = elements.create('payment');
                  paymentElement.mount('#payment-element');

                  // Create and mount the linkAuthentication Element
                  const linkAuthenticationElement = elements.create("linkAuthentication");
                  linkAuthenticationElement.mount("#link-authentication-element");

                  // Handle form submission
                  const form = document.getElementById('payment-form');
                  let submitted = false;
                  form.addEventListener('submit', async (e) => {
                    e.preventDefault();
                    if (submitted) { return; }
                    submitted = true;
                    form.querySelector('button').disabled = true;

                    const { error: stripeError } = await stripe.confirmPayment({
                      elements,
                      confirmParams: {
                        return_url: '\(returnUrl)',
                      }
                    });

                    if (stripeError) {
                      addMessage(stripeError.message);
                      submitted = false;
                      form.querySelector('button').disabled = false;
                      return;
                    }
                  });

                  // Function to update Elements appearance
                  function updateAppearance() {
                    const newAppearance = window.matchMedia('(prefers-color-scheme: dark)').matches
                      ? { theme: 'night' }
                      : { theme: 'stripe' };
                    if (JSON.stringify(newAppearance) !== JSON.stringify(appearance)) {
                      appearance = newAppearance;
                      elements.update({ appearance });
                    }
                  }

                  // Listen for changes in color scheme preference
                  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', updateAppearance);

                  function addMessage(message) {
                    const messageDiv = document.querySelector("#messages");
                    messageDiv.style.display = "block";
                    messageDiv.textContent = message;
                  }
                });
                """
            }
        }
    }
}
