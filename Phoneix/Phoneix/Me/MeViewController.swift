//
//  MeViewController.swift
//  Phoneix
//
//  Created by Weee! on 2018/5/7.
//  Copyright © 2018年 Let's Say Weee!. All rights reserved.
//

import UIKit
import Stripe

class MeViewController: MainBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let protectionSpace = URLProtectionSpace.init(host: "192.168.31.112",
                                                      port: 112,
                                                      protocol: "http",
                                                      realm: nil,
                                                      authenticationMethod: nil)
        
        var credential: URLCredential? = URLCredentialStorage.shared.defaultCredential(for: protectionSpace)
        
        setupPayment()
    }

    func setupPayment() {
        if !PKPaymentAuthorizationViewController.canMakePayments() {
            print("当前设备不支付Apple Pay")
        }
//        else if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: [.amex, .masterCard, .visa, .chinaUnionPay]) {
//            print("Wallet没有添加该支付网络的储蓄卡/信用卡")
//            let paymentButton = PKPaymentButton(paymentButtonType: .setUp, paymentButtonStyle: .whiteOutline)
//            paymentButton.addTarget(self, action: #selector(jump), for: .touchUpInside)
//            view.addSubview(paymentButton)
//            paymentButton.frame = CGRect(x: 100, y: 200, width: 50, height: 20)
//        }
        else {
            let paymentButton = UIButton(type: .system)//PKPaymentButton(paymentButtonType: .setUp, paymentButtonStyle: .white)
            paymentButton.addTarget(self, action: #selector(buy), for: .touchUpInside)
            view.addSubview(paymentButton)
            paymentButton.frame = CGRect(x: 100, y: 200, width: 50, height: 20)
            paymentButton.backgroundColor = .red
        }
    }

    
    @objc func jump() {
        let passLibrary = PKPassLibrary()
        passLibrary.openPaymentSetup()
    }
    
    
    @objc func buy() {
        let paymentRequest = buildPaymentRequest()
//        if Stripe.canSubmitPaymentRequest(paymentRequest) {
            if let auth = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) {
                auth.delegate = self
                present(auth, animated: true, completion: nil)
            } else {
                print("Apple Pay returned a nil PKPaymentAuthorizationViewController - make sure you've configured Apple Pay correctly, as outlined at https://stripe.com/docs/mobile/apple-pay")
            }
//        } else {
//            print("stripe cant Submit")
//        }
    }
    
    
    func buildPaymentRequest() -> PKPaymentRequest {
        let paymentRequest = Stripe.paymentRequest(withMerchantIdentifier: "merchant.com.sayweee.testPay",
                                                   country: "US",
                                                   currency: "USD")
        paymentRequest.requiredBillingAddressFields = .postalAddress
        paymentRequest.requiredShippingAddressFields = .postalAddress
        
        let priceFast1 = NSDecimalNumber(string: "18.0")
        let method1 = PKShippingMethod(label: "顺丰快递", amount: priceFast1)
        method1.detail = "24小时送到"
        method1.identifier = "顺丰"
        let priceFast2 = NSDecimalNumber(string: "0.0")
        let method2 = PKShippingMethod(label: "自提", amount: priceFast2)
        method2.detail = "上门自提"
        method2.identifier = "自提"
        paymentRequest.shippingMethods = [method1, method2]
        
        let price1 = NSDecimalNumber(mantissa: 10, exponent: -2, isNegative: true)
        let item1 = PKPaymentSummaryItem(label: "苹果6", amount: price1)
        let price2 = NSDecimalNumber(string: "10.0")
        let item2 = PKPaymentSummaryItem(label: "苹果8", amount: price2)
        var totalAmount = NSDecimalNumber.zero
        totalAmount = totalAmount.adding(price1)
        totalAmount = totalAmount.adding(price2)
        let total = PKPaymentSummaryItem(label: "Weee!", amount: totalAmount)
        paymentRequest.paymentSummaryItems = [item1, item2, total]
        return paymentRequest
    }
}




extension MeViewController: PKPaymentAuthorizationViewControllerDelegate {
    
    
    
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        
        STPAPIClient.shared().createToken(with: payment) { (token, error) in
            if (error != nil) {
                completion(.failure)
            } else {
                // We could also send the token.stripeID to our backend to create
                // a payment method and subsequent payment intent
                self.createPaymentMethodForApplePayToken(token: token!, completion: completion)
            }
        }
    }
    

    func createPaymentMethodForApplePayToken(token: STPToken, completion: @escaping (PKPaymentAuthorizationStatus) -> ()) {
        let applePayParams = STPPaymentMethodCardParams()
        applePayParams.token = token.stripeID
        let paymentMethodParams = STPPaymentMethodParams(card: applePayParams, billingDetails: nil, metadata: nil)
        
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: "")
        paymentIntentParams.paymentMethodParams = paymentMethodParams
        
        STPAPIClient.shared().createPaymentMethod(with: paymentMethodParams) { (paymentMethod, error) in
            if (error != nil) {
                completion(.failure)
            } else {
                STPAPIClient.shared().confirmPaymentIntent(with: paymentIntentParams) { (paymentIntent, error) in
                    print(paymentIntent?.stripeId)
                }
            }
        }
    }
    
    
    func createAndConfirmPaymentIntentWithPaymentMethod(paymentMethod: STPPaymentMethod, completion: (PKPaymentAuthorizationStatus) -> ()) {
        // sent to server check
        print(paymentMethod.stripeId)
    }
    
    
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        
    }
    
    
    
}
