//
//
//  DialogueUtils.swift
//  WisdomJapan
//
//  Created by zhaoyuanjing on 2017/09/15.
//  Copyright © 2017年 zhaoyuanjing. All rights reserved.
//
//

import Foundation
import SwiftyJSON
import ObjectMapper

/**
 将传入的JSON对象转成数组
 
 - parameter arrayName: 数组的key
 - parameter content:   JSON对象
 
 - returns: ObjectMapper转换后的数组
 */
func getArrayFromJsonByArrayName<T: Mappable>(arrayName: String, content: JSON) -> [T] {
    var array = [T]()
    let arrayJson = content[arrayName].arrayValue
    let count = arrayJson.count
    for index in 0..<count {
          let model = Mapper<T>().map(JSONObject: arrayJson[index].rawValue)
         array.append(model!)
    }
    return array
}

func getArrayFromJson<T: Mappable>(content: JSON) -> [T] {
    var array = [T]()
    let arrayJson = content.arrayValue
    let count = arrayJson.count
    for index in 0..<count {
        let model = Mapper<T>().map(JSONObject: arrayJson[index].rawValue)
        array.append(model!)
    }
    return array
}

func getObjectFormJsonByObjectName<T: Mappable>(objectName: String, content: JSON) -> T? {
    let model = Mapper<T>().map(JSONObject: content[objectName].rawValue)
    return model
}

/// 转换Dictionary成一个Json对象
func convertDictionary2JSONObject(dictionary: NSDictionary) -> AnyObject {
    var data: NSData!
    data = try! JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
    let jsonObject = try! JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments)
    return jsonObject as AnyObject
}
