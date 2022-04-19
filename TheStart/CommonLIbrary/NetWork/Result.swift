//
//  Result.swift
 //
//  Created by YuliangTao on 16/2/26.
//  Copyright © 2016年 Berchina.Mobile. All rights reserved.
//  结果返回工具类，引用地址:https://github.com/lingoer/SwiftyCharms/

import Foundation

enum ResponseResult<T> {
    case Success(T)
    case Failure(T)
}

func ==<T: Equatable>(lhs: ResponseResult<T>, rhs: ResponseResult<T>) -> Bool {
    if case (.Success(let l), .Success(let r)) = (lhs, rhs) {
        return l == r
    }
    
    return false
}

extension ResponseResult {
    
    static func unit(x: T) -> ResponseResult<T> {
        return .Success(x)
    }
 
    func flatMap<U>(f:(T) throws-> ResponseResult<U>) -> ResponseResult<U> {
        switch self {
        case .Success(let value):
            do {
                return try f(value)
            } catch let e {
                return .Failure(e as! U)
            }
            
        case .Failure(let e):
            return .Failure(e as! U)
        }
    }
 
}
