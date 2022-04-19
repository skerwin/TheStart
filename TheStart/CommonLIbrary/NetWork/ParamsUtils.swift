//
//  ParamsUtils.swift
 //
//  Created by YuliangTao on 16/2/26.
//  Copyright © 2016年 Berchina.Mobile. All rights reserved.
//

import Foundation

typealias PathAndParams = (String, Dictionary<String, AnyObject>?)

/// 获取通用的请求Dictionary[主要是针对POST和PUT的HTTP请求方法]
func getRequestParamsDictionary(paramsDictionary: Dictionary<String, AnyObject>?) -> Dictionary<String, AnyObject> {
 
    var commonDictionary: Dictionary<String, AnyObject>
    if paramsDictionary != nil{
        commonDictionary = convertDictionary2JSONObject(dictionary: paramsDictionary! as NSDictionary) as! Dictionary<String, AnyObject>
    }else{
        commonDictionary = convertDictionary2JSONObject(dictionary: [:] as NSDictionary) as! Dictionary<String, AnyObject>
    }
    
    //需要body头的时候用这个
//    var commonDictionary = getCommonParamsDictionary()
//    if paramsDictionary != nil{
//        commonDictionary["data"] = convertDictionary2JSONObject(dictionary: paramsDictionary! as NSDictionary)
//    }else{
//        commonDictionary["data"] = convertDictionary2JSONObject(dictionary: [:] as NSDictionary)
//    }
    return commonDictionary
}


///  获取通用的请求Dictionary[主要是针对GET和DELETE的HTTP请求方法]
func getCommonParamsDictionary() -> Dictionary<String, AnyObject> {
    var commonDictionary: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
//    if let userId = stringForKey(key: Constants.userid) {
//        commonDictionary["userid"] = userId as AnyObject
//    }else{
//        commonDictionary["userid"] = "" as AnyObject
//    }
//    commonDictionary["userType"] = stringForKey(key: Constants.userType) as AnyObject
      return commonDictionary
}



//

func getCommonParamsUrl() -> String {
    let parameters: [String: AnyObject] = getCommonParamsDictionary()
    var components: [(String, String)] = []
    for key in parameters.keys.sorted(by: <) {
        let value = parameters[key]!
       // components += queryComponents(key, value)
        components += queryComponents(key: key, value as AnyObject)
    }
    
    return (components.map { "\($0)=\($1)" } as [String]).joined(separator: "&")
}

/**
 Creates percent-escaped, URL encoded query string components from the given key-value pair using recursion.
 
 - parameter key:   The key of the query component.
 - parameter value: The value of the query component.
 
 - returns: The percent-escaped, URL encoded query string components.
 */
public func queryComponents(key: String, _ value: AnyObject) -> [(String, String)] {
    var components: [(String, String)] = []
    
    if let dictionary = value as? [String: AnyObject] {
        for (nestedKey, value) in dictionary {
            components += queryComponents(key: "\(key)[\(nestedKey)]", value)
        }
    } else if let array = value as? [AnyObject] {
        for value in array {
            components += queryComponents(key: "\(key)[]", value)
        }
    } else {
        components.append((escape(string: key), escape(string: "\(value)")))
    }
    
    return components
}

public func escape(string: String) -> String {
    let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
    let subDelimitersToEncode = "!$&'()*+,;="
    
    var allowedCharacterSet = NSCharacterSet.urlQueryAllowed
     allowedCharacterSet.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)
    
    var escaped = ""
    
    //==========================================================================================================
    //
    //  Batching is required for escaping due to an internal bug in iOS 8.1 and 8.2. Encoding more than a few
    //  hundred Chinense characters causes various malloc error crashes. To avoid this issue until iOS 8 is no
    //  longer supported, batching MUST be used for encoding. This introduces roughly a 20% overhead. For more
    //  info, please refer to:
    //
    //      - https://github.com/Alamofire/Alamofire/issues/206
    //
    //==========================================================================================================
    
   // escaped = string.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet) ?? string
    escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
    return escaped
}

