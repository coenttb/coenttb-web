//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 20/09/2024.
//

import Foundation
import Dependencies
@preconcurrency import StripeKit
import Vapor

extension StripeKit.Event {
    public func summarize() -> String {
        String.summarize(event: self)
    }
}

extension String {
    public static func summarize(event: StripeKit.Event) -> Self {
        var summary = """
        -------------STRIPE-EVENT-------------
        Event Type: \(event.type?.rawValue ?? "Unknown")
        ID: \(event.id)
        API Version: \(event.apiVersion ?? "N/A")
        Created: \(event.created?.description ?? "N/A")
        Livemode: \(event.livemode?.description ?? "N/A")
        Pending Webhooks: \(event.pendingWebhooks?.description ?? "N/A")
        Account: \(event.account ?? "N/A")
        
        """
        
        if let request = event.request {
            summary += """
            Request:
              ID: \(request.id ?? "N/A")
              Idempotency Key: \(request.idempotencyKey ?? "N/A")
            
            """
        }
        
        summary += "Object Data:\n"
        
        switch event.data?.object {
        case .account(let account):
            summary += "  Account ID: \(account.id)"
        case .application(let app):
            summary += "  Application ID: \(app.id)"
        case .applicationFee(let fee):
            summary += "  Application Fee ID: \(fee.id), Amount: \(fee.amount ?? 0)"
        case .balance(let balance):
            summary += "  Balance: Available: \(balance.available?.description ?? "N/A"), Pending: \(balance.pending?.description ?? "N/A")"
        case .bankAccount(let bankAccount):
            summary += "  Bank Account ID: \(bankAccount.id), Last 4: \(bankAccount.last4 ?? "N/A")"
        case .capability(let capability):
            summary += "  Capability ID: \(capability.id), Status: \(capability.status?.rawValue ?? "N/A")"
        case .card(let card):
            summary += "  Card ID: \(card.id), Last 4: \(card.last4 ?? "N/A")"
        case .charge(let charge):
            summary += "  Charge ID: \(charge.id), Amount: \(charge.amount ?? 0), Status: \(charge.status?.rawValue ?? "N/A")"
        case .checkoutSession(let session):
            summary += "  Checkout Session ID: \(session.id), Status: \(session.status?.rawValue ?? "N/A")"
        case .coupon(let coupon):
            summary += "  Coupon ID: \(coupon.id), Amount Off: \(coupon.amountOff ?? 0), Percent Off: \(coupon.percentOff ?? 0)"
        case .creditNote(let creditNote):
            summary += "  Credit Note ID: \(creditNote.id ?? "no id"), Amount: \(creditNote.amount ?? 0)"
        case .customer(let customer):
            summary += "  Customer ID: \(customer.id), Email: \(customer.email ?? "N/A")"
        case .dispute(let dispute):
            summary += "  Dispute ID: \(dispute.id), Status: \(dispute.status?.rawValue ?? "N/A")"
        case .file(let file):
            summary += "  File ID: \(file.id), Purpose: \(file.purpose?.rawValue ?? "N/A")"
        case .invoice(let invoice):
            summary += "  Invoice ID: \(invoice.id ?? "no id"), Total: \(invoice.total ?? 0)"
        case .invoiceItem(let invoiceItem):
            summary += "  Invoice Item ID: \(invoiceItem.id ?? "no id"), Amount: \(invoiceItem.amount ?? 0)"
        case .issuingAuthorization(let auth):
            summary += "  Issuing Authorization ID: \(auth.id), Status: \(auth.status?.rawValue ?? "N/A")"
        case .issuingCard(let card):
            summary += "  Issuing Card ID: \(card.id), Status: \(card.status?.rawValue ?? "N/A")"
        case .issuingCardHolder(let holder):
            summary += "  Issuing Cardholder ID: \(holder.id), Status: \(holder.status?.rawValue ?? "N/A")"
        case .issuingDispute(let dispute):
            summary += "  Issuing Dispute ID: \(dispute.id), Status: \(dispute.status?.rawValue ?? "N/A")"
        case .issuingTransaction(let transaction):
            summary += "  Issuing Transaction ID: \(transaction.id), Amount: \(transaction.amount ?? 0)"
        case .mandate(let mandate):
            summary += "  Mandate ID: \(mandate.id), Status: \(mandate.status?.rawValue ?? "N/A")"
        case .paymentIntent(let intent):
            summary += "  Payment Intent ID: \(intent.id), Amount: \(intent.amount ?? 0), Status: \(intent.status?.rawValue ?? "N/A")"
        case .paymentLink(let link):
            summary += "  Payment Link ID: \(link.id), Status: \(link.active?.description ?? "N/A")"
        case .paymentMethod(let method):
            summary += "  Payment Method ID: \(method.id), Type: \(method.type?.rawValue ?? "N/A")"
        case .payout(let payout):
            summary += "  Payout ID: \(payout.id), Amount: \(payout.amount ?? 0), Status: \(payout.status?.rawValue ?? "N/A")"
        case .person(let person):
            summary += "  Person ID: \(person.id), First Name: \(person.firstName ?? "N/A"), Last Name: \(person.lastName ?? "N/A")"
        case .plan(let plan):
            summary += "  Plan ID: \(plan.id), Nickname: \(plan.nickname ?? "N/A")"
        case .price(let price):
            summary += "  Price ID: \(price.id), Unit Amount: \(price.unitAmount ?? 0)"
        case .product(let product):
            summary += "  Product ID: \(product.id), Name: \(product.name ?? "N/A")"
        case .promotionCode(let code):
            summary += "  Promotion Code ID: \(code.id), Code: \(code.code ?? "N/A")"
        case .quote(let quote):
            summary += "  Quote ID: \(quote.id), Status: \(quote.status?.rawValue ?? "N/A")"
        case .refund(let refund):
            summary += "  Refund ID: \(refund.id), Amount: \(refund.amount ?? 0), Status: \(refund.status?.rawValue ?? "N/A")"
        case .reportRun(let run):
            summary += "  Report Run ID: \(run.id), Status: \(run.status?.rawValue ?? "N/A")"
        case .reportType(let type):
            summary += "  Report Type ID: \(type.id), Name: \(type.name ?? "N/A")"
        case .review(let review):
            summary += "  Review ID: \(review.id), Status: \(review)"
        case .setupIntent(let intent):
            summary += "  Setup Intent ID: \(intent.id), Status: \(intent.status?.rawValue ?? "N/A")"
        case .scheduledQueryRun(let run):
            summary += "  Scheduled Query Run ID: \(run.id), Status: \(run.status?.rawValue ?? "N/A")"
        case .subscription(let sub):
            summary += "  Subscription ID: \(sub.id), Status: \(sub.status?.rawValue ?? "N/A")"
        case .subscriptionSchedule(let schedule):
            summary += "  Subscription Schedule ID: \(schedule.id), Status: \(schedule.status?.rawValue ?? "N/A")"
        case .taxRate(let rate):
            summary += "  Tax Rate ID: \(rate.id), Percentage: \(rate.percentage ?? 0)"
        case .topup(let topup):
            summary += "  Top-up ID: \(topup.id), Amount: \(topup.amount ?? 0), Status: \(topup.status?.rawValue ?? "N/A")"
        case .transfer(let transfer):
            summary += "  Transfer ID: \(transfer.id), Amount: \(transfer.amount ?? 0)"
        case .verificationSession(let session):
            summary += "  Verification Session ID: \(session.id), Status: \(session.status?.rawValue ?? "N/A")"
        case .cashBalance(let balance):
            summary += "  Cash Balance: Available: \(balance.available?.description ?? "N/A")"
        case .configuration(let config):
            summary += "  Configuration ID: \(config.id)"
        case .discount(let discount):
            summary += "  Discount ID: \(discount.id), Amount Off: \("discount.amountOff ?? 0"), Percent Off: \("discount.percentOff ?? 0")"
        case .earlyFraudWarniing(let warning):
            summary += "  Early Fraud Warning ID: \(warning.id), Fraud Type: \(warning.fraudType?.rawValue ?? "N/A")"
        case .reader(let reader):
            summary += "  Reader ID: \(reader.id), Status: \(reader.status ?? "N/A")"
        case .taxId(let taxId):
            summary += "  Tax ID: \(taxId.id), Type: \(taxId.type?.rawValue ?? "N/A")"
        case .testClock(let clock):
            summary += "  Test Clock ID: \(clock.id), Status: \(clock.status?.rawValue ?? "N/A")"
        case .none:
            summary += "  No object data available"
        case .some(.applicationFeeRefund(let applicationFeeRefund)):
            summary += "  Application Fee refund: \(applicationFeeRefund.id) \(applicationFeeRefund)"
        @unknown default:
            summary += "  Unknown event object type"
        }
        
        summary += "\n--------------------------------------"
        
        return summary
    }
}




