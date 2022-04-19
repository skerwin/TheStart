//
//  Requestable.swift
//  WisdomJapan
//
//  Created by zhaoyuanjing on 2017/09/15.
//  Copyright © 2017年 zhaoyuanjing. All rights reserved.
//

import SwiftyJSON
import Foundation

enum HttpMethodType {
    case GET
    case POST
    case PUT
    case DELETE
}

/**
 *  网络请求相关提供者
 */
protocol Requestable {
    func isNetworkConnected()
    
    func postRequestCache(pathAndParams: PathAndParams, showHUD: Bool, needCache: Bool) //带cache的post 请求
    
    func postRequest(pathAndParams: PathAndParams, showHUD: Bool)
    func getRequest(pathAndParams: PathAndParams, showHUD: Bool, needCache: Bool)
    func putRequest(pathAndParams: PathAndParams, showHUD: Bool)
    func deleteRequest(pathAndParams: PathAndParams, showHUD: Bool)
    
    /**
     服务器处理成功时调用此方法
     
     - parameter requestPath:    请求的路径
     - parameter responseResult: responseData包装的JSON对象
     */
    func onResponse(requestPath: String, responseResult: SwiftyJSON.JSON, methodType: HttpMethodType)
    func onResponse(requestPath: String, responseResult: SwiftyJSON.JSON, methodType: HttpMethodType, responseTimestamp: String, needCache: Bool)
    
    /**
     网络请求错误执行此方法
     
     - parameter responseCode: 返回错误码
     - parameter description:  错误描述
     */
    func onFailure(responseCode: String, description: String, requestPath: String)
    func onFailure(responseCode: String, description: String)
}
extension Requestable where Self: UIViewController {
    
    func isNetworkConnected() {}
    
    func postRequest(pathAndParams: PathAndParams, showHUD: Bool = false) {
        if showHUD { DialogueUtils.showWithStatus() }
        HttpRequest.postRequest(pathAndParams: pathAndParams) { (responseResult) -> Void in
            self.processResponseResult(requestPath: pathAndParams.0, responseResult: responseResult, methodType: .POST)
        }
    }
    
    func postRequestCache(pathAndParams: PathAndParams, showHUD: Bool, needCache: Bool) {
        if showHUD { DialogueUtils.showWithStatus() }
        HttpRequest.postRequest(pathAndParams: pathAndParams) { (responseResult) -> Void in
            self.processResponseResult(requestPath: pathAndParams.0, responseResult: responseResult, methodType: .POST, needCache: needCache)
        }
    }
    
    func postRequestSpecical(url:String = "chat",pathAndParams: PathAndParams, showHUD: Bool = false) {
        if showHUD { DialogueUtils.showWithStatus() }
        HttpRequest.postRequestSpecical(url: url ,pathAndParams: pathAndParams) { (responseResult) -> Void in
            self.processResponseResult(requestPath: pathAndParams.0, responseResult: responseResult, methodType: .POST)
        }
    }
    
    
    func getRequest(pathAndParams: PathAndParams, showHUD: Bool = false, needCache: Bool = false) {
        if showHUD { DialogueUtils.showWithStatus() }
        HttpRequest.getRequest(pathAndParams: pathAndParams) { (responseResult) -> Void in
            self.processResponseResult(requestPath: pathAndParams.0, responseResult: responseResult, methodType: .GET)
        }
    }
    
   
    
    func putRequest(pathAndParams: PathAndParams, showHUD: Bool) {
        
    }
    
    func deleteRequest(pathAndParams: PathAndParams, showHUD: Bool) {
        
    }
    
    func onResponse(requestPath: String, responseResult: SwiftyJSON.JSON, methodType: HttpMethodType) {}
    
    func onResponse(requestPath: String, responseResult: SwiftyJSON.JSON, methodType: HttpMethodType, responseTimestamp: String, needCache: Bool = false) {
        onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
    }
    
    func onFailure(responseCode: String, description: String) {}
    
    func onFailure(responseCode: String, description: String, requestPath: String = "") {
        onFailure(responseCode: responseCode, description: description)
    }
    
    
    
    /**
     处理网络请求返回的结果
     - parameter requestPath:    请求的路径
     - parameter responseResult: 返回的结果枚举
     */
    func processResponseResult(requestPath: String, responseResult: ResponseResult<SwiftyJSON.JSON>, methodType: HttpMethodType, needCache: Bool = false) {
        switch responseResult {
        case .Success(let responseJSON):
            DialogueUtils.dismiss()
            let responseCode = String.init(responseJSON[BerResponseConstants.responseCode].intValue)
            
            if responseCode == BerResponseConstants.Code.Success.rawValue {
                let responseData = responseJSON[BerResponseConstants.responseData]
                self.onResponse(requestPath: requestPath, responseResult: responseData, methodType: methodType)
            }else if  responseCode == BerResponseConstants.Code.TokenFailure.rawValue{
                //发出退出消息 清空本地缓存
               
                 NotificationCenter.default.post(name:  NSNotification.Name(rawValue: Constants.TokenChangeRefreshNotification), object: nil)
            }else if responseCode == BerResponseConstants.Code.TokenDeleted.rawValue{
                //发出退出消息 清空本地缓存
                 NotificationCenter.default.post(name:  NSNotification.Name(rawValue: Constants.TokenChangeDeleteNotification), object: responseJSON[BerResponseConstants.desc].stringValue)
            }
            else {
                var desc = responseJSON[BerResponseConstants.desc].stringValue
                if desc.isEmpty {
                    desc = "接口出错啦"
                }
                self.onFailure(responseCode: responseCode, description: desc, requestPath: requestPath)
            }
        case .Failure( _):
            // let responseCode = responseJSON[BerResponseConstants.responseCode]
            //  DialogueUtils.dismiss()
            self.onFailure(responseCode:BerResponseConstants.Code.NetworkNotConnected.rawValue, description: BerResponseConstants.networkNotConnectedTips, requestPath: requestPath)
        }
    }
 
    
    func EeternalProcessResponseResult(requestPath: String, responseResult: ResponseResult<SwiftyJSON.JSON>, methodType: HttpMethodType, needCache: Bool = false) {
        switch responseResult {
        case .Success(let responseJSON):
            DialogueUtils.dismiss()
            let responseCode = responseJSON["showapi_res_code"].intValue
            if responseCode == 0 {
                
                let responseBody = responseJSON["showapi_res_body"]
                
                let responseBodyCode = responseBody["showapi_res_code"].intValue
                if responseBodyCode == 0 {
                    
                    self.onResponse(requestPath: requestPath, responseResult: responseBody, methodType: methodType)
                }else{
                    self.onFailure(responseCode:BerResponseConstants.Code.NetworkNotConnected.rawValue, description: BerResponseConstants.networkNotConnectedTips, requestPath: requestPath)
                }
 
            }else {
                self.onFailure(responseCode:BerResponseConstants.Code.NetworkNotConnected.rawValue, description: BerResponseConstants.networkNotConnectedTips, requestPath: requestPath)
            }
        case .Failure( _):
            // let responseCode = responseJSON[BerResponseConstants.responseCode]
            //  DialogueUtils.dismiss()
            self.onFailure(responseCode:BerResponseConstants.Code.NetworkNotConnected.rawValue, description: BerResponseConstants.networkNotConnectedTips, requestPath: requestPath)
        }
    }
}
 
