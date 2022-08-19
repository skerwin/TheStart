//
//  DialogueUtils.swift
//  WisdomJapan
//
//  Created by zhaoyuanjing on 2017/09/15.
//  Copyright © 2017年 zhaoyuanjing. All rights reserved.
//

import Foundation

import UIKit
import SVProgressHUD

fileprivate enum HUDType: Int {
    case success
    case errorObject
    case errorString
    case info
    case loading
}

class DialogueUtils: NSObject {
    class func initHUD() {
        SVProgressHUD.setBackgroundColor(UIColor ( red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7 ))
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 14))
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.none)
        SVProgressHUD.setMaximumDismissTimeInterval(1)
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        SVProgressHUD.setGraceTimeInterval(1)
     }
    
    //成功
    class func showSuccess(withStatus string: String?) {
        self.progressHUDShow(.success, status: string)
    }
    
    //失败 ，NSError
    class func showError(withObject error: NSError) {
        self.progressHUDShow(.errorObject, status: nil, error: error)
    }
    
    //失败，String
    class func showError(withStatus string: String?) {
        self.progressHUDShow(.errorString, status: string)
    }
    
    //转菊花
    class func showWithStatus(_ string: String? = "正在加载") {
        self.progressHUDShow(.loading, status: string)
    }
    
    //警告
    class func showWarning(withStatus string: String?) {
        self.progressHUDShow(.info, status: string)
    }
    
    //dismiss消失
    class func dismiss() {
        SVProgressHUD.dismiss()
    }
    
    //私有方法
    fileprivate class func progressHUDShow(_ type: HUDType, status: String? = nil, error: NSError? = nil) {
        SVProgressHUD.setDefaultMaskType(.none)
        switch type {
        case .success:
            SVProgressHUD.showSuccess(withStatus: status)
            break
        case .errorObject:
            guard let newError = error else {
                SVProgressHUD.showError(withStatus: "Error:出错拉")
                return
            }
            
            if newError.localizedFailureReason == nil {
                SVProgressHUD.showError(withStatus: "Error:出错拉")
            } else {
                SVProgressHUD.showError(withStatus: error!.localizedFailureReason)
            }
            break
        case .errorString:
            SVProgressHUD.showError(withStatus: status)
            break
        case .info:
            SVProgressHUD.showInfo(withStatus: status)
            break
        case .loading:
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.show(withStatus: status)
            break
        }
    }
    
}
