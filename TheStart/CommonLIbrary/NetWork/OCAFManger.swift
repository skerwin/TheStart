//
//  OCAFManger.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/05/13.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import Alamofire
@objcMembers
class OCAFManger: NSObject {
    
    @objc public func show(){
        
    }
     @objc  public func uploadImage(url:String,filePath:String,success: @escaping (_ content:[String: Any]) -> Void, failure: @escaping (_ errorInfo: String?) -> Void){
        let fileUrl = URL.init(fileURLWithPath: filePath)
        var token = ""
        if stringForKey(key: Constants.token) != nil {
            token = stringForKey(key: Constants.token)!
        }
        let upUrlstr = URLs.getHostAddress() + url
        let headers: HTTPHeaders = [
            "Device-Type": "ios",
            "XX-Token": token
        ]
        
        var fileNamepara = ""
        if url == "/users/api/editAvatar" {
            fileNamepara = "avatar"
        }else{
            fileNamepara = "file"
        }
         AF.upload(multipartFormData: { multipartFormData in
             multipartFormData.append(fileUrl, withName: fileNamepara)
         }, to: upUrlstr, usingThreshold: MultipartFormData.encodingMemoryThreshold,method: .post, headers: headers, interceptor: nil, fileManager:.default).responseJSON { (response) in
            switch response.result {
            case .success:
                guard let dict = response.value else {
                    //failure("图片服务器出错")
                    //("图片上传出错")
                    return
                }
                let responseJson = JSON(dict)
                let responseData = responseJson[BerResponseConstants.responseData]
                print(upUrlstr)
                print(responseJson)
                if responseJson["code"].intValue == 1 {
                    
                  
                    
                    var paramsDictionary = Dictionary<String, AnyObject>()
                    
                    let imageId = responseData["id"].stringValue
                    if imageId != ""{
                        paramsDictionary["id"] = responseData["id"].stringValue as AnyObject
                    }else{
                        paramsDictionary["id"] = responseData["id"].intValue as AnyObject
                    }
                    
                    paramsDictionary["url"] = responseData["url"].stringValue as AnyObject
                    paramsDictionary["file_path"] = responseData["file_path"].stringValue as AnyObject
                    
                    success(paramsDictionary)
                }else{
                    let msg = responseJson["msg"].stringValue
                    failure(msg)
                   // print(content + msg)
                }
            case .failure:
                failure("图片服务器出错")
                print("图片上传出错")
            }
        }
    }

}
