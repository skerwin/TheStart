//
//  UIViewUtils.swift
//  gank.io
//
//  Created by YuliangTao on 16/1/30.
//  Copyright © 2016年 Berchina.Mobile. All rights reserved.
//  UIView的工具类

import Foundation
import UIKit

func getViewByLoadNibNamedFirst(name: String) -> UIView {
    let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as! UIView
    return view
}

/**
 给view添加手势点击事件
 
 - parameter view:       需要添加手势监听的view
 - parameter target:     目标view
 - parameter actionName: 触发器的名称
 */
func addGestureRecognizerToView(view: UIView, target: AnyObject, actionName: String) {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: target, action: NSSelectorFromString(actionName))
    view.isUserInteractionEnabled = true
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
}
func addGestureRecognizerIgnoreTableView(view: UIView, target: AnyObject, actionName: String) {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: target, action: NSSelectorFromString(actionName))
    view.isUserInteractionEnabled = true
    tap.cancelsTouchesInView = true
    view.addGestureRecognizer(tap)
}
func getFooterBottomButton(title:String = "保存",BottomView:UIView?,leading:CGFloat = 30,height:CGFloat = 50) -> UIButton {
    let footViewBtn:UIButton = UIButton(type:UIButton.ButtonType.custom)
    footViewBtn.backgroundColor = ZYJColor.main
    if BottomView == nil{
         footViewBtn.frame = CGRect.init(x: leading, y: 30, width: screenWidth - 2*leading, height: 48)
    }else{
        footViewBtn.frame = CGRect.init(x: leading, y: ((BottomView?.frame.size.height)! - height)/2, width: (BottomView?.frame.size.width)! - 2*leading, height: height)
     }
    footViewBtn.setTitle(title, for:.normal)
    footViewBtn.setTitleColor(UIColor.white, for: .normal)
    footViewBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
    footViewBtn.layer.cornerRadius = 10
    footViewBtn.layer.masksToBounds = true

    return footViewBtn
}
