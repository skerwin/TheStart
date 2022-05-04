//
//  UserModel.swift
//  BaiYi
//
//  Created by zhaoyuanjing on 2020/08/13.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper

struct UserModel: Mappable {
    
    var phone = ""
    var captcha = ""
    var password = ""
    var confirm_pwd = ""
    var nickname = ""
 
  
    
    mutating func mapping(map: Map) {
        
        
       
        phone <- map["phone"]
        captcha <- map["captcha"]
        password <- map["password"]
        confirm_pwd <- map["confirm_pwd"]
        nickname <- map["nickname"]
    }
    
    
    
    
    init?(map: Map) {
           
    }
    init?() {
           
    }
}
