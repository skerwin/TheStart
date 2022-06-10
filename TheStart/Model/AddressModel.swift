//
//  AddressModel.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/25.
//


import Foundation
import UIKit
import ObjectMapper

struct AddressModel : Mappable {
    
    
    
    //shangcheng
    var id = 0
    var real_name = ""
    var phone = ""
    var province = ""
    var city = ""
    var district  = ""
    var detail = ""
    var post_code = 0
    var is_default = 0
    
    
    
    
    var label = ""
    var level = ""
    var code = ""
    var children = [AddressModel]()
    var name = ""
    
    
    
    
    init?(map: Map) {
        
    }
    init?() {
        
    }
    
    mutating func mapping(map: Map) {
        
        
        id <- map["id"]
        real_name <- map["real_name"]
        phone <- map["phone"]
        province <- map["province"]
        city <- map["city"]
        district <- map["district"]
        detail <- map["detail"]
        
        post_code <- map["post_code"]
        is_default <- map["is_default"]
 
        name <- map["label"]
        label <- map["label"]
        level <- map["level"]
        code <- map["code"]
        children <- map["children"]
     }
}
