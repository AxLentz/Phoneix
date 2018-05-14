//
//  HomeViewController.swift
//  Phoneix
//
//  Created by Weee! on 2018/5/7.
//  Copyright © 2018年 Let's Say Weee!. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

class HomeViewController: MainBaseViewController {
    
    lazy var bannerView = BannerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 230))
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let btn = UIButton(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
//        btn.backgroundColor = .red
//        view.addSubview(btn)
//        btn.rx.tap.subscribe(onNext: { (_) in
//            print("hello")
//        }, onError: nil, onCompleted: nil) {
//            print("world")
//        }
        
//        let a = btn.rx.tap.subscribe { (_) in
//            print("hello")
//        }
        
        view.addSubview(bannerView)
        bannerView.bannerDelegate = self

    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBanner()
    }
    
    
    func loadBanner() {
        let provider = MoyaProvider<MyService>()
//        provider.request(.banner(zipcode: "95008")) { (result) in
//            switch result {
//            case let .success(moyaResponse):
//                let data = moyaResponse.data
//                let json = JSON(data)
//                print(json)
//
//
//                let statusCode = moyaResponse.statusCode
//                print(statusCode)
//            case let .failure(error):
//                print(error)
//            }
//        }
        
        
    }
    

}



extension HomeViewController: BannerDelegate {
    
    func selectedItem(model: BannerModel) {
        print(model.img_url!)
    }
    
    func scrollTo(index: Int) {
        print(index)
    }
}
















































