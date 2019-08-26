//
//  PostViewController.swift
//  Phoneix
//
//  Created by Weee! on 2018/5/7.
//  Copyright © 2018年 Let's Say Weee!. All rights reserved.
//

import UIKit
import PassKit

class PostViewController: MainBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            let paymentButton = PKPaymentButton(paymentButtonType: .setUp, paymentButtonStyle: .white)
            paymentButton.addTarget(self, action: #selector(buy), for: .touchUpInside)
            view.addSubview(paymentButton)
            paymentButton.frame = CGRect(x: 100, y: 200, width: 50, height: 20)
        }
    }
    
    
    @objc func jump() {
        let passLibrary = PKPassLibrary()
        passLibrary.openPaymentSetup()
    }


    @objc func buy() {
        print("购买商品, 开始支付,设置所要购买商品的信息")
        
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.sayweee.testPay"
        request.countryCode = "US"
        request.currencyCode = "USD"
        request.supportedNetworks = [.amex, .masterCard, .visa]
        request.merchantCapabilities = [.capability3DS, .capabilityEMV, .capabilityCredit, .capabilityDebit]
        
        let price1 = NSDecimalNumber(mantissa: 10, exponent: -2, isNegative: true)
        let item1 = PKPaymentSummaryItem(label: "苹果6", amount: price1)
        
        let price2 = NSDecimalNumber(string: "10.0")
        let item2 = PKPaymentSummaryItem(label: "苹果8", amount: price2)
        
        var totalAmount = NSDecimalNumber.zero
        totalAmount = totalAmount.adding(price1)
        totalAmount = totalAmount.adding(price2)
        
        let total = PKPaymentSummaryItem(label: "Weee!", amount: totalAmount)
        request.paymentSummaryItems = [item1, item2, total]
        
        request.requiredBillingAddressFields = .all
        request.requiredShippingAddressFields = .all
        
        let priceFast1 = NSDecimalNumber(string: "18.0")
        let method1 = PKShippingMethod(label: "顺丰快递", amount: priceFast1)
        method1.detail = "24小时送到"
        method1.identifier = "顺丰"
        
        let priceFast2 = NSDecimalNumber(string: "0.0")
        let method2 = PKShippingMethod(label: "自提", amount: priceFast2)
        method2.detail = "上门自提"
        method2.identifier = "自提"
        
        request.shippingMethods = [method1, method2]
        request.shippingType = .storePickup
        
    //使用applicationData属性来存储一些在你的应用中关于这次支付请求的唯一标识信息，比如一个购物车的标识符。在用户授权支付之后，这个属性的哈希值会出现在这次支付的token中。
        request.applicationData = "buyID = 12345".data(using: .utf8)
        
        let contact = PKContact()
        var name = PersonNameComponents()
        name.givenName = "Jason"
        name.familyName = "Chen"
        contact.name = name
        
        let address = CNMutablePostalAddress()
        address.street = "1234 Laurel Street"
        address.city = "Atlanta"
        address.state = "GA"
        address.postalCode = "30303"
        contact.postalAddress = address
        contact.phoneNumber = CNPhoneNumber(stringValue: "123345678")
        contact.emailAddress = "qwe@w.com"

        request.shippingContact = contact
        
        if let paymentPane = PKPaymentAuthorizationViewController(paymentRequest: request) {
            paymentPane.delegate = self
            present(paymentPane, animated: true, completion: nil)
        }
    }
    

}



extension PostViewController: PKPaymentAuthorizationViewControllerDelegate {
    
    
    // 如果当用户授权成功, 就会调用这个方法
    // 参数一: 授权控制器
    // 参数二 : 支付对象
    // 参数三: 系统给定的一个回调代码块, 我们需要执行这个代码块, 来告诉系统当前的支付状态是否成功.
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        
//        NSError *error;
//        ABMultiValueRef addressMultiValue = ABRecordCopyValue(payment.billingAddress, kABPersonAddressProperty);
//        NSDictionary *addressDictionary = (__bridge_transfer NSDictionary *) ABMultiValueCopyValueAtIndex(addressMultiValue, 0);
//        NSData *json = [NSJSONSerialization dataWithJSONObject:addressDictionary options:NSJSONWritingPrettyPrinted error: &error];
//
//        // ... Send payment token, shipping and billing address, and order information to your server ...
//
//        PKPaymentAuthorizationStatus status;  // From your server
//        completion(status);
        
        // 一般在此处,拿到支付信息, 发送给服务器处理, 处理完毕之后, 服务器会返回一个状态, 告诉客户端,是否支付成功, 然后由客户端进行处理
        let isSuccess = true
        if isSuccess {
            completion(.success)
        } else {
            completion(.failure)
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        print("授权取消或者交易完成")
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
