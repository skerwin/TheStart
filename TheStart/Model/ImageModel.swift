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
    var url = ""
    var name = ""
    var preview_url = ""
    
    var picurl = ""
    
    
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        id <- map["id"]
        filename <- map["filename"]
        file_path <- map["file_path"]
        //url <- map["url"]
        name <- map["name"]
        preview_url <- map["preview_url"]
        picurl <- map["picurl"]
        
 
    }
}
