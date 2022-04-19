//
//  LoadingPresenter.swift
 //
//  Created by YuliangTao on 16/3/22.
//  Copyright © 2016年 Berchina.Mobile. All rights reserved.
//

import Foundation
import JGProgressHUD

let defaultDelay = 3.0

/**
 *  透明提示框(HUD)提供者
 */
protocol LoadingPresenter {
    func showLoadingHUD()
    func showLoadingHUD(text: String)
    func showErrorMessageHUD(text: String)
    func showCustomImageHUD(imageName: String)
    func showDeterminateHUD()
    func showOnlyTextHUD(text: String)
}

extension LoadingPresenter where Self: UIViewController {

    /**
     显示带文字的菊花透明加载框
     
     - parameter text: 文字描述
     */
    func showLoadingHUD(text: String) {
        let HUD = JGProgressHUD(style: .dark)
        HUD.textLabel.text = text
        HUD.show(in: self.view)
    }
    
    func showLoadingHUD() {
        let HUD = JGProgressHUD(style: .dark)
        HUD.show(in: self.view)
    }
    
    func showErrorMessageHUD(text: String) {
        let HUD = JGProgressHUD(style: .dark)
        HUD.textLabel.text = text
        HUD.indicatorView = JGProgressHUDErrorIndicatorView()
        HUD.show(in: self.view)
        HUD.dismiss(afterDelay: defaultDelay)
    }
    
    func showCustomImageHUD(imageName: String) {
        let HUD = JGProgressHUD(style: .dark)
        HUD.indicatorView = JGProgressHUDImageIndicatorView(image: UIImage(named: imageName)!)
        HUD.show(in: self.view)
        HUD.dismiss(afterDelay: defaultDelay)
    }
    
    func showDeterminateHUD() {
        let HUD = JGProgressHUD(style: .dark)
        HUD.indicatorView = JGProgressHUDPieIndicatorView.init()
        //HUD.indicatorView = JGProgressHUDPieIndicatorView(hudStyle: HUD.style)
        HUD.show(in: self.view)
    }
    
    func showOnlyTextHUD(text: String) {
        let HUD = JGProgressHUD(style: .dark)
        HUD.textLabel.text = text
        HUD.indicatorView = nil
        HUD.show(in: self.view)
        HUD.dismiss(afterDelay: 1.5)
    }
    
    func dismissHUD() {
        for view in self.view.subviews {
            if view.isKind(of: JGProgressHUD.self){
                if let _ = (view as! JGProgressHUD).indicatorView {
                    view.removeFromSuperview()
                }
            }
        }
    }
}
