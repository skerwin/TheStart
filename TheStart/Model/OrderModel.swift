//
//  OrderModel.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/24.
//
 
import Foundation
import UIKit
import ObjectMapper

struct OrderModel : Mappable {
    
 
    
    //wexin
    var paid = 0
    var order_id = ""
    var add_time = ""
    var image = ""
    var audio_id = 0
    var id  = 0
    var pay_type = ""
    var name = ""
    var price = ""
    var order_type = 0
 
    
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        paid <- map["paid"]
        order_id <- map["order_id"]
        add_time <- map["add_time"]
        image <- map["image"]
        audio_id <- map["audio_id"]
        id <- map["id"]
        pay_type <- map["pay_type"]
        
        name <- map["name"]
        price <- map["price"]
        order_type <- map["order_type"]
    }
}
