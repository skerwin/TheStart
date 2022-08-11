//
//  File.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/01.
//

import UIKit
import ObjectMapper

struct TipOffModel : Mappable {
    
 
    
    var id = 0
    var uid = 0
    
    var is_vip = 0
    
    var type = 1
    var title = ""
    var address = ""
    var content = ""
    var upLoadImg = ""
    var image_input = [String]()
    var nickname = ""
    var avatar = ""
    var clarify_id = 0
    var comment = 0
    var dianzan = 0
    var visit = 0
    var add_time = ""
    var is_collect = 0
    var is_dianzan = 0
    var images = [String]()
    var link_url = ""
    
    var clarify_count = 1
 
    
    var is_cai = 0
    var cai = 0
    var operType = ""
    
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        
        cai <- map["cai"]
        is_cai <- map["is_cai"]
        
        uid <- map["is_vip"]
        is_vip <- map["is_vip"]
        clarify_count <- map["clarify_count"]
        id <- map["id"]
        type <- map["type"]
        title <- map["title"]
        address <- map["address"]
        
        content <- map["content"]
        image_input <- map["image_input"]
        nickname <- map["nickname"]
        avatar <- map["avatar"]
        
        clarify_id <- map["clarify_id"]
        comment <- map["comment"]
        dianzan <- map["dianzan"]
        visit <- map["visit"]
        
        add_time <- map["add_time"]
        is_collect <- map["is_collect"]
        is_dianzan <- map["is_dianzan"]
        images <- map["images"]
        link_url <- map["link_url"]
        
     }
}
