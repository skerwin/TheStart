//
//  ImageModel.swift
//  BaiYi
//
//  Created by zhaoyuanjing on 2020/11/06.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import ObjectMapper

struct ImageModel : Mappable {
    
 
    var id = 0
    var filename = ""
    var file_path = ""

    var preview_url = ""
    var url = ""
    var name = ""
    
    var link = ""
    var pic = ""
    
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        
        pic <- map["pic"]
        link <- map["link"]
        id <- map["id"]
        filename <- map["filename"]
        file_path <- map["file_path"]
        url <- map["url"]
        name <- map["name"]
        preview_url <- map["preview_url"]
        
 
    }
}
