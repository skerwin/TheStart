//
//  UIColor+Extension.swift
//  BossJob
//
//  Created by zhaoyuanjing on 2017/09/27.
//  Copyright © 2017年 zhaoyuanjing. All rights reserved.
//

import Foundation

extension NSObject {
    
    public class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
     }
    
    /**
     如果数字是奇数
     */
    public func isNumberOdd(number: Int) -> Bool {
        return (number & 1) != 0
    }
    
    
    public func intToString(number: Int) -> String {
        return String.init(number)
    }
    
    public func int2str(num:Int)-> String {
       return  "\(String(describing: num))"
    }
}
