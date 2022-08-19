//
//  UIStoryboard+Extension.swift
//  O2OManager
//
//  Created by zhaoyuanjing on 16/8/23.
//  Copyright © 2016年 Berchina. All rights reserved.
//

import Foundation
import UIKit

enum StoryBoardType: String {
    case Home = "Home",Message = "Message", Artic = "Artic",  Mine = "Mine", WardManagement = "WardManagement"
}

extension UIStoryboard {
    
    class func getStoryboardByType(type: StoryBoardType) -> UIStoryboard {
        //printLog("StoryboardName: \(type.rawValue)")
        let storyboard = UIStoryboard(name: type.rawValue, bundle: nil)
        return storyboard
    }
  
    
    class func getMineViewController() -> MineViewController
    {
        return getStoryboardByType(type: .Home).instantiateViewController(withIdentifier: "MineViewController") as! MineViewController
    }
    
    class func getFeedBackController() -> FeedBackController
    {
        return getStoryboardByType(type: .Home).instantiateViewController(withIdentifier: "FeedBackController") as! FeedBackController
    }
    
    class func getPersonsInfoController() -> PersonsInfoController
    {
        return getStoryboardByType(type: .Home).instantiateViewController(withIdentifier: "PersonsInfoController") as! PersonsInfoController
    }
    class func getViewController() -> ViewController
    {
        return getStoryboardByType(type: .Home).instantiateViewController(withIdentifier: "ViewController") as! ViewController
    }
    
    class func getMessageController() -> MessageController
    {
        return getStoryboardByType(type: .Message).instantiateViewController(withIdentifier: "MessageController") as! MessageController
    }
    
    class func getNewLoginController() -> NewLoginController
    {
        return getStoryboardByType(type: .Home).instantiateViewController(withIdentifier: "NewLoginController") as! NewLoginController
    }
    
    class func getGetBackPasswordController() -> GetBackPasswordController
    {
        return getStoryboardByType(type: .Home).instantiateViewController(withIdentifier: "GetBackPasswordController") as! GetBackPasswordController
    }
    
    class func getAuthenController() -> AuthenController
    {
        return getStoryboardByType(type: .Home).instantiateViewController(withIdentifier: "AuthenController") as! AuthenController
    }
    
    class func getSettiingControllerTable() -> SettiingControllerTable
    {
        return getStoryboardByType(type: .Home).instantiateViewController(withIdentifier: "SettiingControllerTable") as! SettiingControllerTable
    }
    
    
    
    class func getMyToPubController() -> MyToPubController
    {
        return getStoryboardByType(type: .Home).instantiateViewController(withIdentifier: "MyToPubController") as! MyToPubController
    }
    
    class func getPayViewController() -> PayViewController
    {
        return getStoryboardByType(type: .Home).instantiateViewController(withIdentifier: "PayViewController") as! PayViewController
    }
    
    class func getCashierDeskController() -> CashierDeskController
    {
        return getStoryboardByType(type: .Home).instantiateViewController(withIdentifier: "CashierDeskController") as! CashierDeskController
    }
    class func getGoodsCashDeskController() -> GoodsCashDeskController
    {
        return getStoryboardByType(type: .Home).instantiateViewController(withIdentifier: "GoodsCashDeskController") as! GoodsCashDeskController
    }
    
    
    class func getAuthenSuuccessController() -> AuthenSuuccessController
    {
        return getStoryboardByType(type: .Home).instantiateViewController(withIdentifier: "AuthenSuuccessController") as! AuthenSuuccessController
    }
    
    class func getaddressDetailController() -> addressDetailController
    {
        return getStoryboardByType(type: .Home).instantiateViewController(withIdentifier: "addressDetailController") as! addressDetailController
    }
    
    class func getFreeOpenVipController() -> FreeOpenVipController
    {
        return getStoryboardByType(type: .Home).instantiateViewController(withIdentifier: "FreeOpenVipController") as! FreeOpenVipController
    }
    
    
    
    
}

