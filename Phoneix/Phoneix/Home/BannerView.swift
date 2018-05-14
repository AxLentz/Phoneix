//
//  BannerView.swift
//  Phoneix
//
//  Created by Weee! on 2018/5/14.
//  Copyright © 2018年 Let's Say Weee!. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher


protocol BannerDelegate {
    
    func selectedItem(model: BannerModel)
    
    func scrollTo(index: Int)
}


class BannerView: UICollectionView {
    
    let disposeBag = DisposeBag()
    
    let imgURLArr = Variable([BannerModel]())
    
    var bannerDelegate: BannerDelegate?
    

    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        register(BannerCell.self, forCellWithReuseIdentifier: "BannerCell")
        contentOffset.x = screenWidth
        setupRx()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupRx() {
        imgURLArr
            .asObservable()
            .bind(to: rx.items(cellIdentifier: "BannerCell", cellType: BannerCell.self)) {
                row, model, cell in
                cell.imgView.kf.setImage(with: URL(string: model.img_url!))
        }.disposed(by: disposeBag)
        
        rx.setDelegate(self).disposed(by: disposeBag)
        
        rx.modelSelected(BannerModel.self).subscribe(onNext: { (model) in
            self.bannerDelegate?.selectedItem(model: model)
        }).disposed(by: disposeBag)
    }
    
}



// MARK: - UIScrollViewDelegate
extension BannerView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == CGFloat(imgURLArr.value.count - 1) * screenWidth {
            scrollView.contentOffset.x = screenWidth
        } else if scrollView.contentOffset.x == 0 {
            scrollView.contentOffset.x = CGFloat(imgURLArr.value.count - 2) * screenWidth
        }
        bannerDelegate?.scrollTo(index: Int(scrollView.contentOffset.x / screenWidth) - 1)
    }
}











































