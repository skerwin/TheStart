//
//  ContactModel.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/18.
//

import Foundation
import ObjectMapper

struct ContactModel : Mappable {
    
 
    var id = 0
    var uid = 0
    var to_uid = 0

    var msn = ""
    var add_time = ""
    var type = 0
    
    var msn_type = 0
    var nickname = ""
    var avatar = ""
    
    var count = 0
    
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        uid <- map["uid"]
        to_uid <- map["to_uid"]
        msn <- map["msn"]
        add_time <- map["add_time"]
        type <- map["type"]
        msn_type <- map["msn_type"]
        nickname <- map["nickname"]
        avatar <- map["avatar"]
        count <- map["count"]
    }
}
