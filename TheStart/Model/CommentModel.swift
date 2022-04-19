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
    
    var full_name = ""
    var create_time = 0.0
    var child_list = [CommentModel]()
    var format_create_time = ""
    var id = 0
    var user_id = 0
    var parent_id = 0
    var content = ""
    var table_name = ""
    var is_report = 0
    
    var dislike_count = 0
    var like_count = 0
    var object_id = 0
    
    
 
 
    init?(map: Map) {
           
    }
    init?() {
           
    }
    mutating func mapping(map: Map) {
        
        
        
        dislike_count <- map["dislike_count"]
        like_count <- map["like_count"]
        object_id <- map["object_id"]
        
        is_report <- map["is_report"]
        table_name <- map["table_name"]
        id <- map["id"]
        
        
        parent_id <- map["parent_id"]
        user_id <- map["user_id"]
       
        
        full_name <- map["full_name"]
        create_time <- map["create_time"]
        child_list <- map["child_list"]
        
        
        format_create_time <- map["format_create_time"]
        content <- map["content"]
         
        
     }
 

}
