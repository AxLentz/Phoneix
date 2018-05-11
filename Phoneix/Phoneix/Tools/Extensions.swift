//
//  Extensions.swift
//  Phoneix
//
//  Created by Weee! on 2018/5/10.
//  Copyright © 2018年 Let's Say Weee!. All rights reserved.
//

import UIKit


extension Bundle {
    
    var nameSpace: String {
        return Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
    }
}

extension UIColor {
    
    convenience init(argb color: UInt32) {
        self.init(red: CGFloat((color >> 16) & 0xFF) / CGFloat(0xFF),
                  green: CGFloat((color >> 8) & 0xFF) / CGFloat(0xFF),
                  blue: CGFloat(color & 0xFF) / CGFloat(0xFF),
                  alpha: CGFloat(color >> 24) / CGFloat(0xFF))
    }
}
