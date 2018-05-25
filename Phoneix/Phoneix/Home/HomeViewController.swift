//
//  HomeViewController.swift
//  Phoneix
//
//  Created by Weee! on 2018/5/7.
//  Copyright © 2018年 Let's Say Weee!. All rights reserved.
//

import UIKit
import Moya


class HomeViewController: MainBaseViewController {
    
    lazy var bannerView: BannerView = {
        let view = BannerView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = .red
        view.bannerDelegate = self
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.addSubview(bannerView)
        bannerView.snp.makeConstraints { (make) in
            make.top.equalTo(statusBarHeight + navigationBarHeight)
            make.left.right.equalTo(view)
            make.height.equalTo(screenWidth / 1.875)
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBanner()
    }
    
    
    func loadBanner() {
        let provider = MoyaProvider<MyService>()
        provider.request(.banner(zipcode: "95008")) { (result) in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
      
                

                let statusCode = moyaResponse.statusCode
                print(statusCode)
            case let .failure(error):
                print(error)
            }
        }
        
        
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
















































