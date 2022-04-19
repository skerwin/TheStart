//
//  httpRequest.swift
//  WisdomJapan
//
//  Created by zhaoyuanjing on 2017/09/15.
//  Copyright © 2017年 zhaoyuanjing. All rights reserved.
//
import Foundation
import SwiftyJSON
import Alamofire
/**
 *  网络请求统一入口
 */


typealias FSResponseSuccess = (_ response: String) -> Void
typealias FSResponseFail = (_ error: String) -> Void
typealias FSNetworkStatus = (_ NetworkStatus: Int32) -> Void
typealias FSProgressBlock = (_ progress: Int32) -> Void

struct HttpRequest {
    // 参考地址： http://qiita.com/k-yamada@github/items/569c4c97f0b8e4605e04
    
    static func restfulRequest(methodType: HTTPMethod,
                               pathAndParams: PathAndParams,
                               urlStr: String = "",
                               completionHandler: @escaping (_ responseResult: ResponseResult<JSON>) -> Void){
        
        let requestPath = pathAndParams.0
        let parameters  = pathAndParams.1
       
       
        let  Url = URL.init(string: URLs.getHostAddress() + requestPath)
 

        var request: DataRequest?
//         print("请求数据：")
//         print(Url!.absoluteString)
//         let parametersJson = JSON(parameters!)
//         print(parametersJson)
        var token = ""
        if stringForKey(key: Constants.token) != nil {
            token = stringForKey(key: Constants.token)!
        }
        ////        构造header
        let headers: HTTPHeaders = [
            "XX-Api-Version": "1.0.0",
            "XX-Device-Type": "iphone",
            "Token": token
        ]
        switch methodType {
        case .get, .delete:
            request =  AF.request(Url!, method: methodType,encoding: JSONEncoding.default, headers: headers)
        case .post, .put:
            request =  AF.request(Url!, method: methodType, parameters: parameters,encoding: JSONEncoding.default, headers: headers)
            
        default:
            break
        }
        request?.responseJSON(completionHandler: { (response) in
            let result = response.result
            switch result {
            case .success:
                guard let dict = response.value else {
                    DialogueUtils.dismiss()
                    completionHandler(.Failure(JSON(["code":"100888"])))
                    return
                }
                let responseJson = JSON(dict)
//                print(Url!.absoluteString)
//                print(responseJson)

                
                completionHandler(.Success(responseJson))
            case .failure:
                completionHandler(.Failure(JSON(["code":"100888"])))
                 DialogueUtils.dismiss()
               // completionHandler(.Failure(Error.self as! Error))
            }
        })
    }
    
    
    static func getRequest(pathAndParams: PathAndParams, completionHandler: @escaping (_ responseResult: ResponseResult<JSON>) -> Void) {
        restfulRequest(methodType: .get, pathAndParams: pathAndParams, completionHandler: completionHandler)
    }
    
    static func postRequest(pathAndParams: PathAndParams, completionHandler: @escaping (_ responseResult: ResponseResult<JSON>) -> Void) {
        restfulRequest(methodType: .post, pathAndParams: pathAndParams, completionHandler: completionHandler)
    }
    
    static func postRequestSpecical(url:String ,pathAndParams: PathAndParams, completionHandler: @escaping (_ responseResult: ResponseResult<JSON>) -> Void) {
        restfulRequest(methodType: .post, pathAndParams: pathAndParams,urlStr: url, completionHandler: completionHandler)
    }
    
    
    static func putRequest(pathAndParams: PathAndParams, completionHandler: @escaping (_ responseResult: ResponseResult<JSON>) -> Void) {
        restfulRequest(methodType: .put, pathAndParams: pathAndParams, completionHandler: completionHandler)
    }
    
    static func deleteRequest(pathAndParams: PathAndParams, completionHandler: @escaping (_ responseResult: ResponseResult<JSON>) -> Void) {
        restfulRequest(methodType: .delete, pathAndParams: pathAndParams, completionHandler: completionHandler)
    }
    
    
    static func uploadImage(url:String,filePath:String,success: @escaping (_ content:JSON) -> Void, failure: @escaping (_ errorInfo: String?) -> Void){
        let fileUrl = URL.init(fileURLWithPath: filePath)
        var token = ""
        if stringForKey(key: Constants.token) != nil {
            token = stringForKey(key: Constants.token)!
        }
        let upUrlstr = URLs.getHostAddress() + url
        let headers: HTTPHeaders = [
            "Device-Type": "ios",
            "Token": token
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
//                print(upUrlstr)
//                print(responseJson)
                if responseJson["code"].intValue == 1 {
                    success(responseData)
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




