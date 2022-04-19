//
//  MainTabBarController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/07/23.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import IQKeyboardManager

enum TabbarContentType: Int {
    case HomePage = 0,Articl,Cases, Chat,Mine,Login
}
@objcMembers
class MainTabBarController: UITabBarController,AccountAndPasswordPresenter {
    
    
    let homePageController = HomePageController()
    
    let messageController = MessageController()
    
    let mmallController = MmallController()
    
    let mineController = UIStoryboard.getMineViewController()
    
    
    
    
    var isClearInfo = false
    
    var selectedItemTag = 0
    
    var isLogin = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
     
        
        if #available(iOS 15.0, *) {
          
            self.tabBar.scrollEdgeAppearance = self.tabBar.standardAppearance
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = ZYJColor.main
            self.tabBar.standardAppearance = appearance;
            self.tabBar.scrollEdgeAppearance = self.tabBar.standardAppearance
 
            
            
        } else {
            
                UITabBar.appearance().isTranslucent = true
                UITabBar.appearance().backgroundColor = ZYJColor.main
                UITabBar.appearance().backgroundImage = UIImage()
                UITabBar.appearance().tintColor = UIColor.white
        }
        addChildViewControllers()
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        
    }
    
    private func addChildViewControllers() {
        
        addNavChildViewController(controller: homePageController, title: "首页",
                                  image: UIImage(named: "iconHome")!,
                                  selectedImage: UIImage(named: "iconHomeSelected")!,
                                  tag: TabbarContentType.HomePage.rawValue)
        addNavChildViewController(controller: messageController, title: "云学院",
                                  image: UIImage(named: "iconArctile")!,
                                  selectedImage: UIImage(named: "iconArctileSelected")!,
                                  tag: TabbarContentType.Articl.rawValue)
        addNavChildViewController(controller: mmallController, title: "医学专区",
                                  image: UIImage(named: "iconHome")!,
                                  selectedImage: UIImage(named: "iconHomeSelected")!,
                                  tag: TabbarContentType.Cases.rawValue)
        addNavChildViewController(controller: mineController, title: "我的",
                                  image: UIImage(named: "iconMine")!,
                                  selectedImage: UIImage(named: "iconMineSelected")!,
                                  tag: TabbarContentType.Mine.rawValue)
 
    }
    
    
    private func addNavChildViewController(controller: UIViewController, title: String, image: UIImage, selectedImage: UIImage, tag:Int) {
        controller.title = title
        controller.tabBarItem.image = image
        controller.tabBarItem.tag = tag
        controller.tabBarItem.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
        let navController = MainNavigationController(rootViewController: controller)
        addChild(navController)
        
    }
 
    
}
extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        return true
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        viewController.viewWillAppear(true)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.selectedItemTag = item.tag
 
    }
}

