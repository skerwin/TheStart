//
//  HomeAPI.swift
//  BossJob
//
//  Created by zhaoyuanjing on 2017/12/01.
//  Copyright © 2017年 zhaoyuanjing. All rights reserved.
//

import Foundation

struct HomeAPI {
    
    
    //    ************************登录注册************************
    
    
    static let imageUpLoadUrl       = "/common/getUpload"
    
    
    static let departmenListPath = "/system/getDepartmentList"
    static func departmenListPathAndParams() -> PathAndParams {
        return (departmenListPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
}
