//
//  CheckTool.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/24.
//

import UIKit

func randomInRange(range: Range<Int>) -> Int {
       let count = UInt32(range.endIndex - range.startIndex) //定义随机数产生范围，endIndex为upper bounds，startIndex为low bounds
       return Int(arc4random_uniform(count)) + range.startIndex //返回一个Int类型的随机数
}

func isPhoneNum (test:String) -> Bool {

      let pattern = "^1[0-9]{10}$"

      if NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: test) {

          return true

      }
      return false
 }

func isUrl (test:String) -> Bool {

      let pattern = "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"

      if NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: test) {

          return true

      }
      return false
 }
 
func checkBankCardNumber(_ cardNumber: String?) -> Bool {
    var oddSum: Int = 0 // 奇数和
    var evenSum: Int = 0 // 偶数和
    var allSum: Int = 0 // 总和
    // 循环加和
    for i in 1...(cardNumber?.count ?? 0) {
        let theNumber = (cardNumber as NSString?)?.substring(with: NSRange(location: (cardNumber?.count ?? 0) - i, length: 1))
        var lastNumber = Int(theNumber ?? "") ?? 0
        if i % 2 == 0 {
            // 偶数位
            lastNumber *= 2
            if lastNumber > 9 {
                lastNumber -= 9
            }
            evenSum += lastNumber
        } else {
            // 奇数位
            oddSum += lastNumber
        }
    }
    allSum = oddSum + evenSum
    // 是否合法
    if allSum % 10 == 0 {
        return true
    } else {
        return false
    }
}

func validateIDCardNumber(sfz: String) -> Bool {
        let value = sfz.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        var length = 0
        if value == "" {
            return false
        } else {
            length = value.count
            if length != 15 && length != 18 {
                return false
            }
        }
        
        //省份代码
        let arearsArray = ["11","12", "13", "14",  "15", "21",  "22", "23",  "31", "32",  "33", "34",  "35", "36",  "37", "41",  "42", "43",  "44", "45",  "46", "50",  "51", "52",  "53", "54",  "61", "62",  "63", "64",  "65", "71",  "81", "82",  "91"]
        let valueStart2 = value.substring(to: value.index(value.startIndex, offsetBy: 2))
        var arareFlag = false
        if arearsArray.contains(valueStart2) {
            arareFlag = true
        }
        if !arareFlag {
            return false
        }
        var regularExpression = NSRegularExpression()
        
        var numberofMatch = Int()
        var year = 0
        switch (length) {
        case 15:
            year = Int(value.substring(with: value.index(value.startIndex, offsetBy: 5)..<value.index(value.startIndex, offsetBy: 9)))!
            if year%4 == 0 || (year%100 == 0 && year%4 == 0) {
                do {
                    regularExpression = try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$", options: .caseInsensitive) //检测出生日期的合法性
                } catch { }
            } else {
                do {
                    regularExpression =  try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$", options: .caseInsensitive) //检测出生日期的合法性
                    
                } catch { }
            }
            
            numberofMatch = regularExpression.numberOfMatches(in: value, options:NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, value.count))
            
            if (numberofMatch > 0) {
                return true
            } else {
                return false
            }
            
        case 18:
            year = Int(value.substring(with: value.index(value.startIndex, offsetBy: 6)..<value.index(value.startIndex, offsetBy: 10)))!
            if year%4 == 0 || (year%100 == 0 && year%4 == 0) {
                do {
                    regularExpression = try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$", options: .caseInsensitive) //检测出生日期的合法性
                } catch { }
            } else {
                do {
                    regularExpression =  try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$", options: .caseInsensitive) //检测出生日期的合法性
                    
                } catch { }
            }
            
            numberofMatch = regularExpression.numberOfMatches(in: value, options:NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, value.count))
            
            if(numberofMatch > 0) {
                
                let s =
                    (Int(value.substring(with: value.startIndex..<value.index(value.startIndex, offsetBy: 1)))! +
                        Int(value.substring(with: value.index(value.startIndex, offsetBy: 10)..<value.index(value.startIndex, offsetBy: 11)))!) * 7 +
                        (Int(value.substring(with: value.index(value.startIndex, offsetBy: 1)..<value.index(value.startIndex, offsetBy: 2)))! +
                            Int(value.substring(with: value.index(value.startIndex, offsetBy: 11)..<value.index(value.startIndex, offsetBy: 12)))!) * 9 +
                        (Int(value.substring(with: value.index(value.startIndex, offsetBy: 2)..<value.index(value.startIndex, offsetBy: 3)))! +
                            Int(value.substring(with: value.index(value.startIndex, offsetBy: 12)..<value.index(value.startIndex, offsetBy: 13)))!) * 10 +
                        (Int(value.substring(with: value.index(value.startIndex, offsetBy: 3)..<value.index(value.startIndex, offsetBy: 4)))! +
                            Int(value.substring(with: value.index(value.startIndex, offsetBy: 13)..<value.index(value.startIndex, offsetBy: 14)))!) * 5 +
                        (Int(value.substring(with: value.index(value.startIndex, offsetBy: 4)..<value.index(value.startIndex, offsetBy: 5)))! +
                            Int(value.substring(with: value.index(value.startIndex, offsetBy: 14)..<value.index(value.startIndex, offsetBy: 15)))!) * 8 +
                        (Int(value.substring(with: value.index(value.startIndex, offsetBy: 5)..<value.index(value.startIndex, offsetBy: 6)))! +
                            Int(value.substring(with: value.index(value.startIndex, offsetBy: 15)..<value.index(value.startIndex, offsetBy: 16)))!) * 4 +
                        (Int(value.substring(with: value.index(value.startIndex, offsetBy: 6)..<value.index(value.startIndex, offsetBy: 7)))! +
                            Int(value.substring(with: value.index(value.startIndex, offsetBy: 16)..<value.index(value.startIndex, offsetBy: 17)))!) *  2 +
                        Int(value.substring(with: value.index(value.startIndex, offsetBy: 7)..<value.index(value.startIndex, offsetBy: 8)))! * 1 +
                        Int(value.substring(with: value.index(value.startIndex, offsetBy: 8)..<value.index(value.startIndex, offsetBy: 9)))! * 6 +
                        Int(value.substring(with: value.index(value.startIndex, offsetBy: 9)..<value.index(value.startIndex, offsetBy: 10)))! * 3
                
                let Y = s%11
                var M = "F"
                let JYM = "10X98765432"
                M = JYM.substring(with: JYM.index(JYM.startIndex, offsetBy: Y)..<JYM.index(JYM.startIndex, offsetBy: Y + 1))
                if M == value.substring(with: value.index(value.startIndex, offsetBy: 17)..<value.index(value.startIndex, offsetBy: 18)) {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        default:
            return false
        }
        
    }
//case let .email(str):
//    predicateStr = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
//    currObject = str
//case let .phoneNum(str):
//    predicateStr = "^((13[0-9])|(15[^4,\\D]) |(17[0,0-9])|(18[0,0-9]))\\d{8}$"
//    currObject = str
//case let .carNum(str):
//    predicateStr = "^[A-Za-z]{1}[A-Za-z_0-9]{5}$"
//    currObject = str
//case let .username(str):
//    predicateStr = "^[A-Za-z0-9]{6,20}+$"
//    currObject = str
//case let .password(str):
//    predicateStr = "^[a-zA-Z0-9]{6,20}+$"
//    currObject = str
//case let .nickname(str):
//    predicateStr = "^[\\u4e00-\\u9fa5]{4,8}$"
//    currObject = str
//case let .URL(str):
//    predicateStr = "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"
//    currObject = str
//case let .IP(str):
//    predicateStr = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
//    currObject = str
//}
//
//let predicate =  NSPredicate(format: "SELF MATCHES %@" ,predicateStr)
//return predicate.evaluateWithObject(currObject)
