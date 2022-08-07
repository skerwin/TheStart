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
    var pay_type = 1
    var name = ""
    var price = ""
    var order_type = 0
    var vip_free = 0
    
    //xin
    
    var goods_id = 0
    var order_status = 0
    var goods_name = ""
    
    var uid = 0
    var pay_time = 0
    var province = ""
    var city = ""
    var district = ""
    var detail = ""
    var order_sn = ""
    var post_code = ""
    
    
    var is_del = 0
    
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        
        is_del <- map["is_del"]
        vip_free <- map["vip_free"]
        
        uid <- map["uid"]
        pay_time <- map["pay_time"]
        province <- map["province"]
        city <- map["city"]
        district <- map["district"]
        detail <- map["detail"]
        order_sn <- map["order_sn"]
        post_code <- map["post_code"]
 
        
        goods_id <- map["goods_id"]
        order_status <- map["order_status"]
        goods_name <- map["goods_name"]
        
        
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
