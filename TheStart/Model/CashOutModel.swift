//
//  CashOutModel.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/26.
//

import Foundation
import UIKit
import ObjectMapper

struct CashOutModel : Mappable {
    
 
    
    //wexin
    var id = 0
    var uid = 0
    var bank_name = ""
    var bank_code = ""
    var bank_realname = ""
    
    var extract_price = ""
    var add_time = ""
    
    var status = -2
 
    
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        id <- map["id"]
        uid <- map["uid"]
        bank_name <- map["bank_name"]
        bank_code <- map["bank_code"]
        bank_realname <- map["bank_realname"]
        extract_price <- map["extract_price"]
        add_time <- map["add_time"]
        status <- map["status"]
    }
}
