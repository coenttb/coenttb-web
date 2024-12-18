//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 16/09/2024.
//

import Dependencies
import Foundation
import CoenttbWebHTML


public struct SubscriptionsOverview: HTML {

    let fetchSubscriptions:URL
    let cancelURL:URL

    public init(fetchSubscriptions: URL, cancelURL: URL) {
        self.fetchSubscriptions = fetchSubscriptions
        self.cancelURL = cancelURL
    }
    
    public var body: some HTML {
        
        div()
            .id("subscriptions")
        
        script {"""
           document.addEventListener('DOMContentLoaded', async () => {
             const subscriptionsDiv = document.querySelector('#subscriptions');
             try {
               const response = await fetch('\(fetchSubscriptions.absoluteString)');
               if (!response.ok) {
                 throw new Error(`HTTP error! status: ${response.status}`);
               }
               const data = await response.json();
               if (!data.data || !Array.isArray(data.data)) {
                 throw new Error('Unexpected response format');
               }

               subscriptionsDiv.innerHTML = data.data.map((subscription) => {
                 let last4 = subscription.defaultPaymentMethod?.card?.last4 || 'Not available';
        
                 const cancelUrl = new URL('\(cancelURL.absoluteString)');
                 cancelUrl.searchParams.set('subscriptionId', subscription.id);
                    
                 return `
                   <hr>
                   <h4>
                     <a href="https://dashboard.stripe.com/test/subscriptions/${subscription.id}">
                       ${subscription.id}
                     </a>
                   </h4>

                   <p>
                     Status: ${subscription.status}
                   </p>

                   <p>
                     Card last4: ${last4}
                   </p>
                   <small>${last4 === 'Not available' ? 'Last4 is not available. This might be because the webhook hasn\\'t processed yet or there\\'s no default payment method set.' : ''}</small>

                   <p>
                     Current period end: ${new Date(subscription.currentPeriodEnd * 1000)}
                   </p>

                   // <a href="cancelUrl"> Cancel </a><br />
                   <button onclick="cancelSubscription('${cancelUrl}')">Cancel</button><br />
                 `;
               }).join('<br />');
             } catch (error) {
               console.error('Error fetching subscriptions:', error);
               subscriptionsDiv.innerHTML = `<p>Error loading subscriptions: ${error.message}</p>`;
             }
           });
        
            async function cancelSubscription(cancelUrl) {
             try {
               const response = await fetch(cancelUrl, {
                 method: 'POST'
               });
               if (!response.ok) {
                 throw new Error(`HTTP error! status: ${response.status}`);
               }
               // Reload the page on successful cancellation
               window.location.reload();
             } catch (error) {
               console.error('Error cancelling subscription:', error);
               alert('Failed to cancel subscription: ' + error.message);
             }
           }
        """}
    }
}
