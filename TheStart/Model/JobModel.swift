//
//  JobModel.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/04.
//

import Foundation
import UIKit
import ObjectMapper

struct JobModel : Mappable {
    
    var type = 0
    var id = 0
    var title = ""
    var salary = 0
    var salary_value = ""
    var mobile = ""
    
    
    var avatar = ""
    var nickname = ""
    var is_shiming = 1
    var add_time = ""
    var wechat = ""
    
    var cate_id = 0
    var cate_name = ""
    var images = [String]()
    var imagesURL = ""
    var video = [String]()
    var videoURL = ""
    var name = ""
    var city = ""
    var gender = ""
 
    var address = ""
    var phone = ""
    var detail = ""
    
    var cate = ""
    var work_name = ""
    
    var uid = 0
    var is_collect = 0
    
    var is_vip = 0
    
    
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        
        is_vip <- map["is_vip"]
        work_name <- map["work_name"]
        videoURL <- map["videoURL"]
        cate <- map["cate"]
        video <- map["video"]
        uid <- map["uid"]
        is_collect <- map["is_collect"]
        cate_name <- map["cate_name"]
        cate_id <- map["cate_id"]
        images <- map["images"]
        name <- map["name"]
        city <- map["city"]
        gender <- map["gender"]
        address <- map["address"]
        phone <- map["phone"]
        detail <- map["detail"]
      
        
        
        
        id <- map["id"]
        title <- map["title"]
        salary <- map["salary"]
        salary_value <- map["salary_value"]
        mobile <- map["mobile"]
        avatar <- map["avatar"]
        nickname <- map["nickname"]
        is_shiming <- map["is_shiming"]
        add_time <- map["add_time"]
        wechat <- map["wechat"]
         
 
    }
}
