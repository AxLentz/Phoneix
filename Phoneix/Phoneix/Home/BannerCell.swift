//
//  BannerCell.swift
//  Phoneix
//
//  Created by Weee! on 2018/5/14.
//  Copyright © 2018年 Let's Say Weee!. All rights reserved.
//

import UIKit

class BannerCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imgView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imgView = UIImageView(frame: self.frame)
}
