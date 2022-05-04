//
//  AddressModel.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/30.
//

import UIKit
import ObjectMapper

struct AddressModel : Mappable {
    
 
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
        name <- map["label"]
        label <- map["label"]
        level <- map["level"]
        code <- map["code"]
        children <- map["children"]
     }
}
