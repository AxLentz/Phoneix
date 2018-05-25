//
//  BannerModel.swift
//  Phoneix
//
//  Created by Weee! on 2018/5/14.
//  Copyright © 2018年 Let's Say Weee!. All rights reserved.
//

import Foundation
import ObjectMapper

struct BannerModel: Mappable {
    
    var img_url: String?
    
    var detail: String?
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        img_url   <-  map["img_url"]
        detail    <-  map["detail"]
    }

}
