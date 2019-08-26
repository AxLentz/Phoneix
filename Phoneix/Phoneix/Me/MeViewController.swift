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
//        let protectionSpace = URLProtectionSpace.init(host: "192.168.31.112",
//                                                      port: 112,
//                                                      protocol: "http",
//                                                      realm: nil,
//                                                      authenticationMethod: nil)
//
//        var credential: URLCredential? = URLCredentialStorage.shared.defaultCredential(for: protectionSpace)
        
//        applePayButton.enabled = Stripe.deviceSupportsApplePay()
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
        if Stripe.canSubmitPaymentRequest(paymentRequest) {
            if let auth = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) {
                auth.delegate = self
                present(auth, animated: true, completion: nil)
            } else {
                print("Apple Pay returned a nil PKPaymentAuthorizationViewController - make sure you've configured Apple Pay correctly, as outlined at https://stripe.com/docs/mobile/apple-pay")
            }
        } else {
            print("stripe cant Submit")
        }
    }
    
    
    func buildPaymentRequest() -> PKPaymentRequest {
        let paymentRequest = Stripe.paymentRequest(withMerchantIdentifier: "merchant.com.sayweee.testPay",
                                                   country: "US",
                                                   currency: "USD")
        paymentRequest.requiredBillingAddressFields = .postalAddress
        paymentRequest.requiredShippingAddressFields = .postalAddress
        paymentRequest.supportedNetworks = [.amex, .masterCard, .visa, .chinaUnionPay]
        
        paymentRequest.merchantCapabilities = .capability3DS //[.capability3DS, .capabilityEMV, .capabilityCredit, .capabilityDebit]
        

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
    
    
    var paymentSucceeded = false
}



//extension MeViewController: STPAuthenticationContext {
//
//    func authenticationPresentingViewController() -> UIViewController {
//        return self
//    }
//
//    func prepareAuthenticationContextForPresentation(completion: @escaping STPVoidBlock) {
//        if presentedViewController != nil {
//            dismiss(animated: true) {
//                completion()
//            }
//        } else {
//            completion()
//        }
//    }
//}


//extension MeViewController: STPPaymentContextDelegate {
//    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
//
//    }
//
//    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
//
//    }
//
//    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
//
//    }
//
//
//    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
//        print("didCreatePaymentResult")
//    }
//}


extension MeViewController: PKPaymentAuthorizationViewControllerDelegate {
    
    
    
    
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        
        if controller.presentingViewController != nil {
            if #available(iOS 11.0, *) {
                completion(.success)
            } else {
                completion(.failure)
            }
        } else {
            self.finish()
        }
        
        
//        STPAPIClient.shared().createSource(with: payment) { (source, error) in
//            if error != nil {
//                print("createSource\(error)")
//                completion(.failure)
//            }
//        }
        

        
        STPAPIClient.shared().createToken(with: payment) { (token, error) in
            if error != nil {
                print("createToken\(error)")
                completion(.failure)
            } else {
                let applePayParams = STPPaymentMethodCardParams()
                applePayParams.token = token?.stripeID
                let paymentMethodParams = STPPaymentMethodParams(card: applePayParams,
                                                                 billingDetails: nil,
                                                                 metadata: nil)
                STPAPIClient.shared().createPaymentMethod(with: paymentMethodParams, completion: { (paymentMethod, error) in
                    if error != nil {
                        print("createPaymentMethod\(error)")
                        completion(.failure)
                    } else {
                        print(paymentMethod?.stripeId ?? "nil")
                        //_createAndConfirmPaymentIntentWithPaymentMethod
                    }
                })
            }
        }
    
        
    }

    
    
    func createAndConfirmPaymentIntentWithPaymentMethod(paymentMethod: STPPaymentMethod, completion: (PKPaymentAuthorizationStatus) -> ()) {
        // sent to server check
        print(paymentMethod.stripeId)
    }
    
    
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        // Dismiss payment authorization view controller
        dismiss(animated: true, completion: {
            self.finish()
        })
    }
    
    
    func finish() {
        if (paymentSucceeded) {
            // Show a receipt page...
        } else {
            // Present error to customer...
        }
    }
    
    
    
}
