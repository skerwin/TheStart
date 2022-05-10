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
 
    
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        
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
