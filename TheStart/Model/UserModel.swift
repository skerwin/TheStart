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
    
    var uid = 0
    var phone = ""
    var captcha = ""
    var password = ""
    var confirm_pwd = ""
    var nickname = ""
    var vip_time = ""
    
    var is_vip = 0
    
    
    var gender = ""
    var birthday = ""
    
    var work = ""
    var avatar = ""
    var now_money = 0
    var brokerage_pric = ""
    var addres = ""
    var expire_time = 0
    var coins = ""
    var times = 0
    var is_shiming = 0
    var real_name = ""
    var card_id = ""
    var front_img = ""
    var back_img = ""
  
    var shiming_remark = ""
    var shiming_time = 0
    var is_audio = 0
    var video_type = 0
    var video_path = ""
    
    var shiming_status = -2
    var audio_status = -2
    var images = [String]()
    var imagesUrl = ""
    
    
    var logo = ""
    var audio_remark = ""
    var vip = 0
    var vip_id = 0
    var vip_icon = ""
    var vip_name = ""
    
    var avatar_check = ""
    
    //卡信息
    var shiming_work = 0
    var shiming_company = ""
    var music_num = 0
    var introduce = ""
    var bank_name = ""
    var bank_realname = ""
    var bank_code = ""
    var address = ""
    
    //音乐人信息
     var work_name = ""
    var shiming_work_name = ""
    
    var collection_count = 0
    var if_collection = 0
    
    
    var if_open = 0
    
    var audio_score = 0
    var integral = 0
    
    
    mutating func mapping(map: Map) {
        
        
        audio_score <- map["audio_score"]
        integral <- map["integral"]
        
        
        vip_time <- map["vip_time"]
        if_open <- map["if_open"]
        if_collection <- map["if_collection"]
        is_vip <- map["is_vip"]
        collection_count <- map["collection_count"]
        
        music_num <- map["music_num"]
        work_name <- map["work_name"]
        shiming_work_name <- map["shiming_work_name"]
        address <- map["address"]
        
        shiming_work <- map["shiming_work"]
        shiming_company <- map["shiming_company"]
        music_num <- map["music_num"]
        introduce <- map["introduce"]
        bank_name <- map["bank_name"]
        bank_realname <- map["bank_realname"]
        bank_code <- map["bank_code"]
 
        avatar_check <- map["avatar_check"]
        
        phone <- map["phone"]
        captcha <- map["captcha"]
        password <- map["password"]
        confirm_pwd <- map["confirm_pwd"]
        nickname <- map["nickname"]
        
        uid <- map["uid"]
        gender <- map["gender"]
        birthday <- map["birthday"]
        work <- map["work"]
        avatar <- map["avatar"]
        now_money <- map["now_money"]
        brokerage_pric <- map["brokerage_pric"]
        addres <- map["addres"]
        expire_time <- map["expire_time"]
        coins <- map["coins"]
        times <- map["times"]
        is_shiming <- map["is_shiming"]
        real_name <- map["real_name"]
        card_id <- map["card_id"]
        front_img <- map["front_img"]
        back_img <- map["back_img"]
        shiming_status <- map["shiming_status"]
        shiming_remark <- map["shiming_remark"]
        shiming_time <- map["confirm_pwd"]
        is_audio <- map["is_audio"]
        video_type <- map["video_type"]
        video_path <- map["video_path"]
        audio_status <- map["audio_status"]
        images <- map["images"]
        logo <- map["logo"]
        audio_remark <- map["audio_remark"]
        vip <- map["vip"]
        vip_id <- map["vip_id"]
        vip_icon <- map["vip_icon"]
        vip_name <- map["vip_name"]
    }
    
    
    
    
    init?(map: Map) {
           
    }
    init?() {
           
    }
}
