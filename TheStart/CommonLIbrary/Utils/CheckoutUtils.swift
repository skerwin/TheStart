//
//  CheckoutUtils.swift
 //
//  Created by YuliangTao on 16/3/24.
//  Copyright © 2016年 Berchina.Mobile. All rights reserved.
//常用校验工具类

import Alamofire

// MARK: - 字符串的扩展
let codeLength = 5
let codeLibarary = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]

let UsernamePattern = "[A-Za-z0-9_]"
let PhonePattern = "^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$"
let EmailPattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
let IdNumberPattern = "(^\\d{15}$)|(^\\d{18}$)|(^\\d{17}(\\d|X|x)$)"
let PassWordPattern = "^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,16}"
let PassWordPatternPayAccount = "^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,20}"
///^(?:([A-Za-z]+):)?(\/{0,3})([0-9.\-A-Za-z]+)(?::(\d+))?(?:\/([^?#]*))?(?:\?([^#]*))?(?:#(.*))?$/
let urlPattern = "([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?"
//let urlPattern = "^http://([\\w-]+\\.)+[\\w-]+(/[\\w-./?%&=]*)?$"
//let faxPattern = "^(\\d{3,4}-)?\\d{7,8}$"
let weixinPattern = "[a-zA-Z][-_a-zA-Z0-9]{5,19}"
let numberPattern = "^\\d{10,}$"    //全部是数字

let faxPattern = "\\d{9,}$"

let enterpriseCode = "\\d{13,}$"

let allnameTypePattern = "^(([a-zA-Z\\u0800-\\u4e00\\u4e00-\\u9fa5]){2,20})$"
let shortnameTypePattern = "^(([a-zA-Z\\u0800-\\u4e00\\u4e00-\\u9fa5]){2,20})$"

let specicalPattern = "[-()（）—”“$&@%^*?+?=|{}?【】？??￥!！.<>/:;：；、,，。]"


struct CheckoutUtils {
    
    static func isMatch(content: String, pattern: String) -> Bool {
        let matcher = RegexHelper.init(pattern)
        return matcher.match(input: content, isMatchAll: false)
    }
    //用户名类型
   static func isValidUsername(username: String) -> Bool {
        let pattern = "[A-Za-z0-9_]"
        let matcher = RegexHelper.init(pattern)
        return matcher.match(input: username, isMatchAll: true)
    }
    
    //邮箱类型
    static func isValidEmail(Email: String) -> Bool {
        let matcher = RegexHelper.init(EmailPattern)
        return matcher.match(input: Email, isMatchAll: false)
    }
    
    //传真类型
    static func isValidFax(fax: String) -> Bool {
        let matcher = RegexHelper.init(faxPattern)
        return matcher.match(input: fax, isMatchAll: false)
    }
    
    //微信号类型
    static func isValidWeixin(weixin: String) -> Bool {
        let matcher = RegexHelper.init(weixinPattern)
        return matcher.match(input: weixin, isMatchAll: false)
    }
    
    //纯数字类型
    static func isValidNumber(number: String) -> Bool {
        let matcher = RegexHelper.init(numberPattern)
        return matcher.match(input: number, isMatchAll: false)
    }
    
    //各种name类型
    static func isValidName(name: String) -> Bool {
        let matcher = RegexHelper.init(allnameTypePattern)
        return matcher.match(input: name, isMatchAll: false)
    }
    //各种短name类型
    static func isValidshortname(name: String) -> Bool {
        let matcher = RegexHelper.init(shortnameTypePattern)
        return matcher.match(input: name, isMatchAll: false)
    }

    //各种特殊字符组织
    static func isValidSpecicalname(name: String) -> Bool {
        let matcher = RegexHelper.init(specicalPattern)
        return matcher.match(input: name, isMatchAll: false)
    }
    
    //url类型
    static func isValidURL(url: String) -> Bool {
        do {
          
            let regex = try NSRegularExpression(pattern: urlPattern, options: .caseInsensitive)
            return regex.firstMatch(in: url, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, url.count)) != nil
        } catch {
            return false
        }
    }
    /// 是否为手机号类型
    static func isMobile(mobile: String) -> Bool {
        do {
            let pattern = "^(1[3-9])\\d{9}$"
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            return regex.firstMatch(in: mobile, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, mobile.count)) != nil
        } catch {
            return false
        }
    }
 
     /// 是否为密码类型
    static func isPassword(pwd: String) -> Bool {
 
        let pattern = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,18}$"//"^[@A-Za-z0-9!#\\$%\\^&*\\.~_]{6,20}$"
        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.dotMatchesLineSeparators)
         if let _ = regex.firstMatch(in: pwd, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, pwd.count)) {
             return true
            
        }
        return false
    }
    
    /// 是否为密码类型
       static func isPasswordNOSpecial(pwd: String) -> Bool {
    
           let pattern = "[0-9A-Za-z]{6,18}$"//"^[@A-Za-z0-9!#\\$%\\^&*\\.~_]{6,20}$"
           let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.dotMatchesLineSeparators)
            if let _ = regex.firstMatch(in: pwd, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, pwd.count)) {
                return true
               
           }
           return false
       }
    
    static func isPostCode(postCode: String) -> Bool {
        do {
            let pattern = "[1-9]\\d{5}(?!\\d)"
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            return regex.firstMatch(in: postCode, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, postCode.count)) != nil
        } catch {
            return false
        }
    }
    
     //生成指定位数验证码
    static func verificationCode() -> String{
        var code = ""
        for _ in 0...codeLength {
            let index = Int(arc4random())%(codeLibarary.count - 1)
            let objStr = codeLibarary[index]
            code = code + objStr
        }
        return code
    }
}

//正则表达式扩展
struct RegexHelper {
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        regex = try! NSRegularExpression(pattern: pattern,
                                         options: NSRegularExpression.Options.caseInsensitive)
    }
    
    func match(input: String, isMatchAll: Bool) -> Bool {
        let inputCount = input.count
        
        
        if let matches = regex?.matches(in: input,
                                                options: NSRegularExpression.MatchingOptions.reportCompletion,
                                                range: NSMakeRange(0, inputCount)) {
            if isMatchAll {
                return matches.count == inputCount
            } else {
                return matches.count > 0
            }
        } else {
            return false
        }
    }
}

