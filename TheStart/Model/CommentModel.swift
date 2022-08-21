//
//  commentModel.swift
//  BaiYi
//
//  Created by zhaoyuanjing on 2020/08/12.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper

struct CommentModel: Mappable {
    
    var id = 0
    var rid = 0
    var ruid = 0
    var r_nickname = ""
    var comment = ""
    var add_time = ""
    var nickname = ""
    var avatar = ""
    var article_id = 0
    var dianzan = 0
    var uid = 0
    var pinglun_dianzan = 0
    var is_dianzan = 0
    var children_count = 0
    var children = [CommentModel]()
    
    init?(map: Map) {
           
    }
    init?() {
           
    }
    mutating func mapping(map: Map) {
                
        r_nickname <- map["r_nickname"]
        id <- map["id"]
        rid <- map["rid"]
        comment <- map["comment"]
     
        add_time <- map["add_time"]
        nickname <- map["nickname"]
        avatar <- map["avatar"]
        
        dianzan <- map["dianzan"]
        uid <- map["uid"]
        pinglun_dianzan <- map["pinglun_dianzan"]
         
        is_dianzan <- map["is_dianzan"]
        children_count <- map["children_count"]
        children <- map["children"]
     }
 

}
