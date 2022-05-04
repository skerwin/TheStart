//
//  DictModel.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/03.
//

import Foundation
import UIKit
import ObjectMapper

struct DictModel : Mappable {
    
 
    var id = 0
    var title = ""
    var child = [DictModel]()
    var salary = ""
    
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        child <- map["child"]
        salary <- map["salary"]
 
    }
}
