//
//  GoodsModel.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/25.
//

 
import UIKit
import ObjectMapper

struct GoodsModel : Mappable {
    
    var id = 0
    var goods_name = ""
    var price = ""
    var description = ""
    var image = ""
    var content = ""
    
    var add_time = ""
   
    
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        id <- map["id"]
        goods_name <- map["goods_name"]
        price <- map["price"]
        description <- map["description"]
        image <- map["image"]
        content <- map["content"]
        add_time <- map["add_time"]
     }
}
//marketTest
