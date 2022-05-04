//
//  URL.swift
//  BossJob
//
//  Created by zhaoyuanjing on 2017/11/03.
//  Copyright © 2017年 zhaoyuanjing. All rights reserved.
//

import Foundation
struct URLs {
    
    
    enum Environment: Int {
         case SIT        = 1 // 测试环境
         case UAT        = 2 // 试运行环境
         case Product    = 3 // 生产环境
     }

    static var currentEnvironment       = Environment.SIT
    static let currentEnvironmentKey    = "http://122.114.14.227"
    static let sitHostAddress           = "http://122.114.14.227"
    static let productHostAddress       = "http://122.114.14.227"
    
    
//    static func getAPIIp() -> String {
//        return "http://product.gskanglin.cn/api"
//    }
    
    static func getHostAddress() -> String {
         
        switch currentEnvironment {
           case Environment.Product:
              return productHostAddress
           case Environment.SIT:
              return sitHostAddress
           default: // 默认sit
              return sitHostAddress
        }
    }
     /// 当前的网络环境
    static func getCurrentEnvironment() -> Environment {
        if objectForKey(key: currentEnvironmentKey) == nil { // 默认 sit
            return .SIT
        }
        let currentEnvironmentIntValue = objectForKey(key: currentEnvironmentKey) as! Int
        switch currentEnvironmentIntValue {
        case Environment.Product.rawValue:
            return .Product
        case Environment.SIT.rawValue:
            return .SIT
         default: // 默认sit
            return .SIT
        }
    }
}
