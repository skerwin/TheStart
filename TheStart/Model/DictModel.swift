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
    
    var price = ""
    var give_money = ""
    
    var image = ""
    
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        image <- map["image"]
        id <- map["id"]
        title <- map["title"]
        child <- map["child"]
        salary <- map["salary"]
        
        price <- map["price"]
        give_money <- map["give_money"]
 
    }
}
