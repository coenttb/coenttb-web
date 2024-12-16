import Dependencies
import Foundation
import CoenttbWebHTML
import MemberwiseInit
import MacroCodableKit

public struct SubscribeFeature<Button:HTML>: HTML {
    
    let currentUserName: String?
    let button: Button
    let priceId: String
    
//    fetch("\(serverRouter.url(for: .api(.v1(.stripe(.subscription(.create(.init())))))))", {
    let fetchConfig:URL
    let createSubscription:URL
    let redirect: URL
    
    
    
    public init(
        priceId: String,
        currentUserName: String?,
        fetchConfig:URL,
        createSubscription:URL,
        redirect: URL,
        @HTMLBuilder button: () -> Button
    ) {
        self.priceId = priceId
        self.currentUserName = currentUserName
        self.fetchConfig = fetchConfig
        self.createSubscription = createSubscription
        self.redirect = redirect
        self.button = button()
    }
    
    public var body: some HTML {
        let containerId = "subscribe-container-\(priceId)"
        let formContainerId = "form-container-\(priceId)"
        let messageContainerId = "message-container-\(priceId)"
        let errorContainerId = "error-container-\(priceId)"
        let buttonId = "subscribe-button-\(priceId)"
        
        VStack {
            div()
                .id(formContainerId)
                .display(.none)
            
            div()
                .id(errorContainerId)
                .display(.none)
                .color(.red)
            
            div()
                .id(messageContainerId)
                .display(.none)
            
            button
            .id(buttonId)
            .onClick("handleSubscribeAction('\(priceId)')")
        }
        .id(containerId)
        
        script {"""
            let isFormVisible = false;
            
            function handleSubscribeAction(priceId) {
                if (!isFormVisible) {
                    showSubscriptionForm(priceId);
                } else {
                    submitSubscriptionForm(priceId);
                }
            }
            
            function showSubscriptionForm(priceId) {
                const formContainer = document.getElementById('form-container-' + priceId);
                formContainer.style.display = 'block';
                formContainer.innerHTML = `
                    \(String(html: subscriptionForm()))
                `;
                
                setupStripe();
                isFormVisible = true;
                
                const button = document.getElementById('subscribe-button-' + priceId);
                button.textContent = 'Submit';
            }
            
            function submitSubscriptionForm(priceId) {
                const formContainer = document.getElementById('form-container-' + priceId);
                const form = formContainer.querySelector('#subscription-form');
                if (!form) {
                    console.error('Form element not found');
                    return;
                }
                const formData = new FormData(form);
                const name = formData.get('name');
                
                createSubscription(priceId, name);
            }
            
            function createSubscription(priceId, name) {
                fetch("\(createSubscription.absoluteString)", {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: new URLSearchParams({
                        name: name,
                        priceId: priceId,
                    }).toString()
                })
                .then((response) => response.json())
                .then((data) => {
                    if (data.clientSecret) {
                        confirmPayment(data.clientSecret, priceId);
                    } else if (data.error === 'existing_subscription') {
                        showMessage('You already have an active subscription.', priceId);
                    } else {
                        throw new Error(data.message || 'Subscription creation failed');
                    }
                })
                .catch((error) => {
                    console.error('Error:', error);
                    showError(error.message, priceId);
                });
            }
            
            function confirmPayment(clientSecret, priceId) {
                stripe.confirmCardPayment(clientSecret, {
                    payment_method: {
                        card: cardElement,
                        billing_details: {
                            name: document.getElementById('name').value,
                        },
                    }
                }).then((result) => {
                    if (result.error) {
                        showError(result.error.message, priceId);
                    } else {
                        showMessage('Success! Your subscription is active.', priceId);
                        setTimeout(() => {
                            window.location.href = '\(redirect.absoluteString)';
                        }, 3000);
                    }
                });
            }
            
            function showMessage(message, priceId) {
                const formContainer = document.getElementById('form-container-' + priceId);
                const messageContainer = document.getElementById('message-container-' + priceId);
                const button = document.getElementById('subscribe-button-' + priceId);
                const errorContainer = document.getElementById('error-container-' + priceId);
                
                formContainer.style.display = 'none';
                messageContainer.style.display = 'block';
                messageContainer.innerHTML = `<p>${message}</p>`;
                button.style.display = 'none';
                errorContainer.style.display = 'none';
                
                isFormVisible = false;
            }
            
            function showError(message, priceId) {
                const errorContainer = document.getElementById('error-container-' + priceId);
                errorContainer.style.display = 'block';
                errorContainer.innerHTML = `<p>${message}</p>`;
                
                // Ensure the form and button are still visible
                const formContainer = document.getElementById('form-container-' + priceId);
                const button = document.getElementById('subscribe-button-' + priceId);
                formContainer.style.display = 'block';
                button.style.display = 'block';
                button.textContent = 'Try Again';
            }
            
            let stripe, cardElement;
            function setupStripe() {
                fetch('\(fetchConfig.absoluteString)')
                    .then((resp) => resp.json())
                    .then((resp) => {
                        stripe = Stripe(resp.publishableKey);
                        const elements = stripe.elements();
                        cardElement = elements.create('card');
                        cardElement.mount('#card-element');
                    });
            }
        """}
    }
    
    private func subscriptionForm() -> some HTML {
        form {
            VStack {
                Input.default(SubscriptionFormData.CodingKeys.name)
                    .type(.text)
                    .placeholder(String.name.capitalizingFirstLetter().description)
                    .value(currentUserName ?? "")
                
                div()
                    .id("card-element")
            }
        }
        .id("subscription-form")
    }
}


@MemberwiseInit(.public)
@Codable
public struct SubscriptionFormData: Hashable {
   @CodingKey("email")
    @Init(default: "")
    public let email: String?
    
   @CodingKey("name")
    @Init(default: "")
    public let name: String?
    
   @CodingKey("password")
    @Init(default: "")
    public let password: String?
}
