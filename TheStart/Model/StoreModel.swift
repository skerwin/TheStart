//
//  StoreModel.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/08/28.
//

import Foundation
import UIKit
import ObjectMapper

struct StoreModel : Mappable {
    //shangcheng
    var id = 0
    var name = ""
    var address = ""
    var click = 0
    var tel = ""
    var image  = ""
    var prestige = 0
    var if_follow = 0
    var if_like = 0
    var if_perstige = 0
    var images = [String]()
    var h5_url = ""
    var reply_count = 0
    
    var we_chat = ""
    init?(map: Map) {
        
    }
    init?() {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        we_chat <- map["we_chat"]
        reply_count <- map["reply_count"]
        address <- map["address"]
        click <- map["click"]
        tel <- map["tel"]
        image <- map["image"]
        prestige <- map["prestige"]
        if_follow <- map["if_follow"]
        if_like <- map["if_like"]
        if_perstige <- map["if_perstige"]
        images <- map["images"]
        h5_url <- map["h5_url"]
   
     }
}
