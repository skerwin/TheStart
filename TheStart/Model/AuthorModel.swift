//
//  AuthorModel.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/05.
//


import Foundation
import UIKit
import ObjectMapper

struct AuthorModel : Mappable {
    
 
    var id = 0
    var uid = 0
    var is_vip = 0
    
    
    var nickname = ""
    var real_name = ""
    
    var gender = ""
    var work = 0
    
    var audio_num = 1
    var work_name = ""
    
    var avatar = ""
    
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        id <- map["id"]
        uid <- map["uid"]
        is_vip <- map["is_vip"]
        nickname <- map["nickname"]
        real_name <- map["real_name"]
        
        gender <- map["gender"]
        work <- map["work"]
        
        audio_num <- map["audio_num"]
        work_name <- map["work_name"]
        
        avatar <- map["avatar"]
 
    }
}
