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

     
        var Url:URL!
        if methodType == .get{
            Url = URL.init(string: requestPath)
        }else{
            Url = URL.init(string: URLs.getHostAddress() + requestPath)
        }
      
 
         var request: DataRequest?
         print("请求数据：")
         print(Url!.absoluteString)
         let parametersJson = JSON(parameters!)
         print(parametersJson)
        var token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJxaWNoZW5nLnhpZXlha291LmNuIiwiYXVkIjoicWljaGVuZy54aWV5YWtvdS5jbiIsImlhdCI6MTY0MjQxMDI1MSwibmJmIjoxNjQyNDEwMjUxLCJleHAiOjE3MzcxMDQ2NTEsImp0aSI6eyJpZCI6MSwidHlwZSI6InVzZXIifX0.9W6TZ85LJp1SLXPEHmzuwbvBiMsFfJP_lCuT0oYodcc"
//        if stringForKey(key: Constants.token) != nil {
//            token = stringForKey(key: Constants.token)!
//        }
        let headers: HTTPHeaders = [
            "Authori-zation": token
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
                print(Url!.absoluteString)
                print(responseJson)
                if requestPath.containsStr(find: HomeAPI.salaryPath){
                    XHNetworkCache.save_asyncJsonResponse(toCacheFile: dict, andURL: HomeAPI.salaryPath) { (result) in
                     }
                }else if requestPath.containsStr(find: HomeAPI.workCategoryPath){
                    XHNetworkCache.save_asyncJsonResponse(toCacheFile: dict, andURL: HomeAPI.workCategoryPath) { (result) in
                     }
                    
                }
                
                 completionHandler(.Success(responseJson))
            case .failure:
                completionHandler(.Failure(JSON(["code":"100888"])))
                 DialogueUtils.dismiss()
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
    
    static func uploadImage(url:String,filePath:[URL],success: @escaping (_ content:JSON) -> Void, failure: @escaping (_ errorInfo: String?) -> Void){
        
        let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJxaWNoZW5nLnhpZXlha291LmNuIiwiYXVkIjoicWljaGVuZy54aWV5YWtvdS5jbiIsImlhdCI6MTY0MjQxMDI1MSwibmJmIjoxNjQyNDEwMjUxLCJleHAiOjE3MzcxMDQ2NTEsImp0aSI6eyJpZCI6MSwidHlwZSI6InVzZXIifX0.9W6TZ85LJp1SLXPEHmzuwbvBiMsFfJP_lCuT0oYodcc"
         
        let upUrlstr = URLs.getHostAddress() + url
        let headers: HTTPHeaders = [
            "Authori-zation": token
        ]
        
         AF.upload(multipartFormData: { multipartFormData in
 
//             let data = "5".data(using: String.Encoding.utf8)!
//             multipartFormData.append(data, withName: "count")
             var count = 0
             for fileUrl in filePath {
                 print(fileUrl)
                 multipartFormData.append(fileUrl, withName: "file\(count)", fileName: "image_\(count).png", mimeType: "image/png")
                 count = count + 1
             }
 
         }, to: upUrlstr, usingThreshold: MultipartFormData.encodingMemoryThreshold,method: .post, headers: headers, interceptor: nil, fileManager:.default).responseJSON { (response) in
 
            switch response.result {
            case .success:
                guard let dict = response.value else {
                    failure("图片服务器出错")
                    return
                }
                let responseJson = JSON(dict)
                let responseData = responseJson[BerResponseConstants.responseData]
                print(upUrlstr)
                print(responseJson)
                if responseJson["status"].intValue == 200 {
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
    
    
    
    
    
    
    static func uploadImage2(url:String,filePath:[Data],success: @escaping (_ content:JSON) -> Void, failure: @escaping (_ errorInfo: String?) -> Void){
        //let fileUrl = URL.init(fileURLWithPath: filePath)
        let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJxaWNoZW5nLnhpZXlha291LmNuIiwiYXVkIjoicWljaGVuZy54aWV5YWtvdS5jbiIsImlhdCI6MTY0MjQxMDI1MSwibmJmIjoxNjQyNDEwMjUxLCJleHAiOjE3MzcxMDQ2NTEsImp0aSI6eyJpZCI6MSwidHlwZSI6InVzZXIifX0.9W6TZ85LJp1SLXPEHmzuwbvBiMsFfJP_lCuT0oYodcc"
         
        let upUrlstr = URLs.getHostAddress() + url
        let headers: HTTPHeaders = [
            "Authori-zation": token
        ]
        
         AF.upload(multipartFormData: { multipartFormData in
             
             var count = 0
             for fileUrl in filePath {
 
                 multipartFormData.append(fileUrl, withName: "file\(count)",fileName: "image_\(count).png", mimeType: "image/png")
                 count = count + 1
             }
             
 
         }, to: upUrlstr, usingThreshold: MultipartFormData.encodingMemoryThreshold,method: .post, headers: headers, interceptor: nil, fileManager:.default).responseJSON { (response) in
            let dict = response.value
             let responseJson = JSON(dict)
             let responseData = responseJson[BerResponseConstants.responseData]
             print(upUrlstr)
             print(responseJson)
             
            switch response.result {
            case .success:
                guard let dict = response.value else {
                    failure("图片服务器出错")
                    return
                }
                let responseJson = JSON(dict)
                print(responseJson)
                let responseData = responseJson[BerResponseConstants.responseData]
              
                if responseJson["status"].intValue == 200 {
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




