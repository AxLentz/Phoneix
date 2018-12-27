//
//  BannerView.swift
//  Phoneix
//
//  Created by Weee! on 2018/5/14.
//  Copyright © 2018年 Let's Say Weee!. All rights reserved.
//

import UIKit
import Kingfisher


protocol BannerDelegate {
    
    func selectedItem(model: BannerModel)
    
    func scrollTo(index: Int)
}


class BannerView: UICollectionView {
    
    var bannerDelegate: BannerDelegate?
    
    var imgURLArr: [BannerModel]?

    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        register(BannerCell.self, forCellWithReuseIdentifier: "BannerCell")
        contentOffset.x = screenWidth
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}



// MARK: - UIScrollViewDelegate
extension BannerView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        bannerDelegate?.scrollTo(index: Int(scrollView.contentOffset.x / screenWidth) - 1)
    }
}











































