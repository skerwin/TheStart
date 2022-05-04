//
//  BerResponseCode.swift
 //
//  Created by YuliangTao on 16/3/22.
//  Copyright © 2016年 Berchina.Mobile. All rights reserved.

import Foundation

/**
 *  网络请求响应的Constants
 */
struct BerResponseConstants {
    
    static let responseTimestamp = "responseTimestamp"
    static let responseCode = "status"
    static let errorCode = "errorCode"
    
    static let responseData = "data"
    static let desc = "msg"
    static let error = "error"
    static let errorMessage = "errorMessage"
    static let token = "token"
    
    static let networkNotConnectedTips = "数据异常，或网络不可用"
    static let noPermissionTips = "你的账号在其他设备登录或者个人信息异常，请重新登录"
    
    enum Code: String {
        case Success = "200", TokenFailure = "10001",uploadSuccess = "201", NetworkNotConnected = "100888", NoPermission = "999999", NoBankCard = "800005", PassWordCode = "210016", TokenDeleted = "1002"
    }
     
    static func isNetworkNotConnectedError(responseCode: String) -> Bool {
        if responseCode == Code.NetworkNotConnected.rawValue {
            return true
        }
        
        return false
    }
}
