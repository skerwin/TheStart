//
//  AudioModel.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/05.
//

import Foundation
import UIKit
import ObjectMapper

struct AudioModel : Mappable {
    
    var uid = 0
    var id = 0
    var price = ""
    var audio_path = ""
    var image = ""
    var name = ""
    
    var link = ""
    var imagesUrl = ""
    var images = [String]()
    var code = ""
    var info = ""
 
    var userCollect = 0
    var browse = 0
    var order_count = 0
    
    var vip_free = -1
    var if_order = 0
    
    
    
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        
        if_order <- map["if_order"]
        uid <- map["uid"]
        userCollect <- map["userCollect"]
        browse <- map["browse"]
        order_count <- map["order_count"]
        
        code <- map["code"]
        info <- map["info"]
        id <- map["id"]
        price <- map["price"]
        audio_path <- map["audio_path"]
        image <- map["image"]
        name <- map["name"]
        link <- map["link"]
        images <- map["images"]
        vip_free <- map["vip_free"]
    }
}
