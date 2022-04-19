//
//
//  DialogueUtils.swift
//  WisdomJapan
//
//  Created by zhaoyuanjing on 2017/09/15.
//  Copyright © 2017年 zhaoyuanjing. All rights reserved.
// 颜色生成辅助类

import Foundation
import UIKit

// 标题栏颜色
//let navigationBarColor = colorWithHexString(hex: "#28B944")

let navigationBarColor = UIColor.white

struct ZYJColor {
    // 34 140 252
    static let main = colorWithHexString(hex: "#0F0F11")
    static let mainText = colorWithHexString(hex: "#EBEBEB")
    static let barColor = colorWithHexString(hex: "#202322")
    static let blueTextColor = colorWithHexString(hex: "#6A90CA")
    static let backColor = colorWithHexString(hex: "616161")
    static let mainLine = colorWithHexString(hex: "e2effd")
    
    
   
    static let translucent = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5) // 半透明
    
    static let redColorButton = colorWithHexString(hex: "FF397F")
    
    static let chatLine = colorWithHexString(hex: "F0F0F0")
    
    static let testLine = colorWithHexString(hex: "DEDEDE")
    
    static let tableViewBg = colorWithHexString(hex: "#F0F0F0")
    static let tableViewSmallBlueBg = colorWithHexString(hex: "#FAFDFF")
    static let shadowColor = colorWithHexString(hex: "#C3E5F0")
    
    static let tableViewLine = colorWithHexString(hex: "DCF1EC")
    
    
    static let inputLineColor = colorWithHexString(hex: "#FEF2F2").withAlphaComponent(0.6)
    struct Line {

        static let grey = RGBA(r:240, g:240, b:240, a:1)
        static let grey_deep = colorWithHexString(hex: "898989") // 不同内容模块分割线
    }
    
    struct Background {
        //        static let grey = RGBA(r:240, g:241, b:242, a:1)
        static let grey = colorWithHexString(hex: "f8f8f8")
        static let grey_touch = RGBA(r:240, g:240, b:240, a:1)
    }
    
    struct Bar {
        static let white = colorWithHexString(hex: "ffffff")
        static let blue = RGBA(r: 31, g:109, b:238, a:1)
    }
    
    struct Button {
        static let disabled = RGBA(r:211, g:211, b:211, a:1)
        static let red = colorWithHexString(hex: "ff5959")
        static let blue = colorWithHexString(hex: "00acee")
        static let orange = colorWithHexString(hex: "ff984c")
    }
    
    struct Label {
        static let greyLabel = RGBA(r:83, g:83, b:83, a:1)
    }
    
    struct text {
        ///用于广告文字，表头、标题名称性文字
        static let black_deep = RGBA(r:27, g:27, b:27, a:1)
        ///用于激活状态/可编辑性文字，表头、栏目标题名称性文字
        static let grey_deep = RGBA(r:68, g:68, b:68, a:1)
        ///用于提示性文字，不可编辑性文字，未激活状态/查看性文字
        static let grey_light = RGBA(r:101, g:101, b:101, a:1)
        ///用于数字金额性文字
        static let red = RGBA(r:255, g:81, b:81, a:1)
        
        static let orange = colorWithHexString(hex: "cf534b")
    }
    
}
 
func colorWithHexString(hex:String) ->UIColor {
    var cString = hex.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
    if (cString.hasPrefix("#")) {
        let index = cString.index(cString.startIndex, offsetBy:1)
        cString = cString.substring(from: index)
    }
     if (cString.count != 6) {
        return UIColor.red
    }
     let rIndex = cString.index(cString.startIndex, offsetBy: 2)
    let rString = cString.substring(to: rIndex)
    let otherString = cString.substring(from: rIndex)
    let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
    let gString = otherString.substring(to: gIndex)
    let bIndex = cString.index(cString.endIndex, offsetBy: -2)
    let bString = cString.substring(from: bIndex)
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    Scanner(string: rString).scanHexInt32(&r)
    Scanner(string: gString).scanHexInt32(&g)
    Scanner(string: bString).scanHexInt32(&b)
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
 }

func RGBA (r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) -> UIColor {
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}
func RGBAOVER (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor (red: r, green: g, blue: b, alpha: a)
}


//
