//
//  UIColor+Extension.swift
//  BossJob
//
//  Created by zhaoyuanjing on 2017/09/26.
//  Copyright © 2017年 zhaoyuanjing. All rights reserved.
//

import Foundation
import UIKit


 extension String {

    /// 获取字符串的长度
    func charLength() -> Int {
        return self.count
    }
    //字符串本地化
     func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
      /**
     获取字符串的size
     */
    func getStringSize(width: CGFloat, fontSize: CGFloat) -> CGSize {
        let size  = self.boundingRect( with: CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:[NSAttributedString.Key.font:UIFont.systemFont(ofSize: fontSize)], context:nil).size
        return size
    }
    //判读是否为空
    
    func isEmptyStr() -> Bool{
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces).count == 0 ? true : false
    }
    
    //将原始的url编码为合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    //将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
    
    //判断是否是空“”
    func isLengthEmpty() -> Bool{
        return self == "" ? true : false
    }
    
    func authInfo() -> Bool{
        if (self.isLengthEmpty()) || (self.isEmptyStr()) || self == "请填写" || self == "请选择" || self == "请输入"{
            return false
        }
        return true
    }
    
    /// 判断是不是Emoji
    ///
    /// - Returns: true false
    func containsEmoji()->Bool{
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F,
                 0x1F300...0x1F5FF,
                 0x1F680...0x1F6FF,
                 0x2600...0x26FF,
                 0x2700...0x27BF,
                 0xFE00...0xFE0F:
                return true
            default:
                continue
            }
        }

        return false
    }

/// 判断是不是Emoji
    ///
    /// - Returns: true false
    func hasEmoji()->Bool {

        let pattern = "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"
        let pred = NSPredicate(format: "SELF MATCHES %@",pattern)
        return pred.evaluate(with: self)
    }
    
    
    func isContainsEmoji()->Bool {
        if containsEmoji() || hasEmoji(){
            return true
        }else{
            return false
        }
        
     }

/// 判断是不是九宫格
    ///
    /// - Returns: true false
    func isNineKeyBoard()->Bool{
        let other : NSString = "➋➌➍➎➏➐➑➒"
        let len = self.count
        for i in 0 ..< len {
            if !(other.range(of: self).location != NSNotFound) {
                return false
            }
        }

        return true
    }


    /// 然后是去除字符串中的表情
    ///
    /// - Parameter text: text
    func disable_emoji(text : NSString)->String{
        do {
            let regex = try NSRegularExpression(pattern: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]", options: NSRegularExpression.Options.caseInsensitive)

            let modifiedString = regex.stringByReplacingMatches(in: text as String, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, text.length), withTemplate: "")

            return modifiedString
        } catch {
            //print(error)
        }
        return ""
    }
    
    
    
    var html2AttributedString: NSAttributedString? {
          do {
              return try NSAttributedString(data: Data(utf8),
                                            options: [.documentType: NSAttributedString.DocumentType.html,
                                                      .characterEncoding: String.Encoding.utf8.rawValue],
                                            documentAttributes: nil)
          } catch {
              //print("error: ", error)
              return nil
          }
      }
    
    
      var html2String: String {
        return html2AttributedString?.string.removeHeadAndTailSpacePro ?? ""
      }
    
    /*
     *去掉首尾空格
     */
    var removeHeadAndTailSpace:String {
        let whitespace = NSCharacterSet.whitespaces
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉首尾空格 包括后面的换行 \n
     */
    var removeHeadAndTailSpacePro:String {
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉所有空格
     */
    var removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    /*
     *去掉首尾空格 后 指定开头空格数
     */
    func beginSpaceNum(num: Int) -> String {
        var beginSpace = ""
        for _ in 0..<num {
            beginSpace += " "
        }
        return beginSpace + self.removeHeadAndTailSpacePro
    }
    
    
    func getAttributedString() -> NSMutableAttributedString {
        return  NSMutableAttributedString(string:self)
    }
    
    
    func containsStr(find: String) -> Bool{
           return self.range(of: find) != nil
       }

    func containsIgnoringCase(find: String) -> Bool{
           return self.range(of: find, options: .caseInsensitive) != nil
    }
     
   
     
    //
}
