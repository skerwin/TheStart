//
//  DepartmentModel.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/25.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit
 
import ObjectMapper

struct DepartmentModel : Mappable {
    
    var id = 0
    var parent_id = 0
    var name = ""
    var is_collect = 0
    var child = [DepartmentModel]()
    
    var isSeleted = false
    
    
 
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        parent_id <- map["parent_id"]
        child <- map["children"]
        is_collect <- map["is_collect"]
        
    }
}
