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
    
    var id = 0
    var name = ""
    var mobile = ""
    var avatar = ""
    var sex = 0
    var password = ""
    var balance = ""
    var create_time = 0.0
    var user_status = 0.0
    var user_login = ""
    var user_nickname = ""
    var user_email = ""
    var user_realname = ""
    var hospital = ""
    var department_id = 0
    var professional_id = 0
    var qualification_type = 0
    var qualifications = 0
    var qualifications_two = 0
    var id_card = ""
    var check_status = 0
    var reasons = ""
    var user_follow_count = 0
    var user_fans_count = 0
    var msg_count = 0
    var record_count = 0
   
    var need_pwd = 0
    var avatar_url = ""
    var department_text = ""
    var professional_text = ""
    var qualifications_url = ""
    var qualificationstwo_url = ""
    var qualifications_two_url = ""
    
    var token = ""
    var im_code = ""
    
    var fans_count = 0
    var format_fans_count = ""
    
    
    var province_id = 0
    var city_id = 0
    var district_id = 0
    var list_order = 0
    var recommend = 0
    var is_collect = 0  //是否关注该医生
    var score = ""
    var intro = ""
    var major = ""
    var resume = ""
    var work_experience = ""
    var achievement = ""
    var department_name = ""
    var professional_name = ""
    var province_name = ""
    var city_name = ""
    var district_name = ""
    
    
    var majorHeight:CGFloat = 0
    var resumeHeight:CGFloat = 0
    var work_experienceHeight:CGFloat = 0
    var achievementHeight:CGFloat = 0
    
    var poster_img = "" //海报图片地址
    var live_status = 0
    var new_registration = ""
    
    
    var like_count = 0
    var format_like_count = ""
    
    var favorite_count = 0
    var format_favorite_count = ""
    
    var group_count = 0
    var format_group_count = ""
    
    
    var pub_count = 0
    var format_pub_count = ""
    
    mutating func mapping(map: Map) {
        
        
        
        favorite_count <- map["favorite_count"]
        format_favorite_count <- map["format_favorite_count"]
        group_count <- map["group_count"]
        format_group_count <- map["format_group_count"]
        pub_count <- map["pub_count"]
        format_pub_count <- map["format_pub_count"]
        
        
        
        
        
        format_like_count <- map["format_like_count"]
        
        
        
        poster_img <- map["poster_img"]
        
        live_status <- map["live_status"]
        new_registration <- map["new_registration"]
        
        province_id <- map["province_id"]
        city_id <- map["city_id"]
        district_id <- map["district_id"]
        list_order <- map["list_order"]
        recommend <- map["recommend"]
        is_collect <- map["is_collect"]
        score <- map["score"]
        intro <- map["intro"]
        major <- map["major"]
        resume <- map["resume"]
        work_experience <- map["work_experience"]
        achievement <- map["achievement"]
        department_name <- map["department_name"]
        professional_name <- map["professional_name"]
        province_name <- map["province_name"]
        city_name <- map["city_name"]
        district_name <- map["district_name"]
        
        id <- map["id"]
        name <- map["name"]
        mobile <- map["mobile"]
        avatar <- map["avatar"]
        sex <- map["sex"]
        token <- map["token"]
        avatar <- map["avatar"]
        avatar_url <- map["avatar_url"]
        password <- map["password"]
        balance <- map["balance"]
        create_time <- map["create_time"]
        user_status <- map["user_status"]
        user_login <- map["user_login"]
        user_nickname <- map["user_nickname"]
        user_email <- map["user_email"]
        hospital <- map["hospital"]
        department_id <- map["department_id"]
        professional_id <- map["professional_id"]
        qualification_type <- map["qualification_type"]
        qualifications <- map["qualifications"]
        id_card <- map["id_card"]
        check_status <- map["check_status"]
        reasons <- map["reasons"]
        user_follow_count <- map["user_follow_count"]
        user_fans_count <- map["user_fans_count"]
        msg_count <- map["msg_count"]
        record_count <- map["record_count"]
        like_count <- map["like_count"]
        need_pwd <- map["need_pwd"]
        department_text <- map["department_text"]
        professional_text <- map["professional_text"]
        token <- map["token"]
        qualifications_url <- map["qualifications_url"]
        qualificationstwo_url <- map["qualificationstwo_url"]
        user_realname <- map["user_realname"]
        im_code <- map["im_code"]
        qualifications_two_url <- map["qualifications_two_url"]
 
        fans_count <- map["fans_count"]
        format_fans_count <- map["format_fans_count"]
    }
    
    
    
    
    init?(map: Map) {
           
    }
    init?() {
           
    }
}
