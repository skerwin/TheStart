//
//  AlertPresenter.swift
 //
//  Created by YuliangTao on 16/3/22.
//  Copyright © 2016年 Berchina.Mobile. All rights reserved.
//

import Foundation
import UIKit
/**
 AlertController按钮类型的枚举
 
 - Sure:   确定按钮
 - Cancel: 取消那妞
 */
enum AlertButtonType: Int {
    case Sure = 0, Cancel
}

/**
 *  弹出对话框提供者
 */
protocol AlertPresenter : AnyObject {
    func getAlertController(message: String) -> UIAlertController
    func showAlertDialog(message: String, title: String, actionHandler: @escaping(_ buttonType: AlertButtonType) -> Void)
    func showSingleButtonAlertDialog(message: String, actionHandler: @escaping(_ buttonType: AlertButtonType) -> Void)
}

extension AlertPresenter where Self: UIViewController {

    
    /**
     得到AlertController实例
     
     - returns: AlertController实例
     */
    func getAlertController(message: String) -> UIAlertController {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        return alertController
    }
    
    /**
     获取AlertAction
     
     - parameter title:         显示的标题
     - parameter actionHandler: 按钮对应Action
     
     - returns: AlertAction实例
     */
    func getAlertAction(title: String, actionHandler: @escaping () -> Void) -> UIAlertAction {
        let alertAction = UIAlertAction(title: title, style: UIAlertAction.Style.default) { (UIAlertAction) -> Void in
            actionHandler()
        }
        return alertAction
    }
    
    func showAlertDialog(delegate: UIActionSheetDelegate?, titles: [String]) {
        let actionSheet = UIActionSheet()
        actionSheet.delegate = delegate
        for title in titles {
            actionSheet.addButton(withTitle: title)
        }
        actionSheet.cancelButtonIndex = actionSheet.addButton(withTitle: "取消")
        actionSheet.show(in: self.view)
    }
    
    /// 显示包含2个按钮的对话框
    func showAlertDialog(message: String, title: String, actionHandler: @escaping (AlertButtonType) -> Void) {
        let alertController = getAlertController(message: message)
        if !title.isEmpty {
            alertController.title = title
        }
        
        let sureButtonDefaultTitle = "确定"
        let sureAction = getAlertAction(title: sureButtonDefaultTitle) {
            actionHandler(AlertButtonType.Sure)
        }
        alertController.addAction(sureAction)
        
        let cancelButtonDefaultTitle = "取消"
        let cancelAction = getAlertAction(title: cancelButtonDefaultTitle) {
            actionHandler(AlertButtonType.Cancel)
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
     /// 显示单个按钮的对话框
    func showSingleButtonAlertDialog(message: String,actionHandler: @escaping (AlertButtonType) -> Void) {
        let alertController = getAlertController(message: message)
//        if title != "" {
//            alertController.title = title
//        }
        
        let sureButtonDefaultTitle = "确定"
        let sureAction = getAlertAction(title: sureButtonDefaultTitle) {
            actionHandler(AlertButtonType.Sure)
        }
        alertController.addAction(sureAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
//    func showAlertDialog(message: String, title: String = "",  actionHandler: @escaping (_ buttonType: AlertButtonType) -> Void) {
//
//    }
//
//    func showSingleButtonAlertDialog(message: String, actionHandler: @escaping (_ buttonType: AlertButtonType) -> Void) {
//
//    }
}
