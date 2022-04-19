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
    case Home = "Home",Channel = "Channel", Artic = "Artic",  Mine = "Mine", WardManagement = "WardManagement"
}

extension UIStoryboard {
    
    class func getStoryboardByType(type: StoryBoardType) -> UIStoryboard {
        //printLog("StoryboardName: \(type.rawValue)")
        let storyboard = UIStoryboard(name: type.rawValue, bundle: nil)
        return storyboard
    }
    
    class func getFindPersonController() -> FindPersonController
    {
        return getStoryboardByType(type: .Home).instantiateViewController(withIdentifier: "FindPersonController") as! FindPersonController
    }
    
    
    class func getMineViewController() -> MineViewController
    {
        return getStoryboardByType(type: .Home).instantiateViewController(withIdentifier: "MineViewController") as! MineViewController
    }
    
    
    
}

