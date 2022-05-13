//
//  PayModel.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/13.
//
 
import Foundation
import UIKit
import ObjectMapper

struct PayModel : Mappable {
    
 
    
    //wexin
    var appid = ""
    var noncestr = ""
    var package = ""
    var partnerid = ""
    var prepayid = ""
    var timestamp:UInt32 = 0
    var sign = ""
 
    
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        appid <- map["appid"]
        noncestr <- map["noncestr"]
        package <- map["package"]
        partnerid <- map["partnerid"]
        prepayid <- map["prepayid"]
        timestamp <- map["timestamp"]
        sign <- map["sign"]
    }
}
