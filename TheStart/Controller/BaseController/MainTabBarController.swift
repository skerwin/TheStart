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
    
    
    let homePageController = HomePageMenuController()
 
    let mmallController = MmallController()
    
    let tipOffController = TipOffMenuPageController()
    
    //let controller = TipOffMenuPageController()
   // self.navigationController?.pushViewController(controller, animated: true)
    
    let mineController = UIStoryboard.getMineViewController()
 
    let goodsController = goodsListController()
    
    let messageController = ContactListController()
    
    var isClearInfo = false
    
    var selectedItemTag = 0
    
    var isLogin = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
     
        
        if #available(iOS 15.0, *) {
          
            self.tabBar.scrollEdgeAppearance = self.tabBar.standardAppearance
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.selectionIndicatorTintColor = ZYJColor.barColor
            appearance.backgroundColor = ZYJColor.barColor
            self.tabBar.standardAppearance = appearance;
            self.tabBar.scrollEdgeAppearance = self.tabBar.standardAppearance
 
            
            
        } else {
            
                UITabBar.appearance().isTranslucent = true
                UITabBar.appearance().backgroundColor = ZYJColor.barColor
                UITabBar.appearance().backgroundImage = UIImage()
                UITabBar.appearance().tintColor = ZYJColor.barColor
        }
        addChildViewControllers()
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        
    }
    
    private func addChildViewControllers() {
        
        addNavChildViewController(controller: homePageController, title: "首页",
                                  image: UIImage(named: "iconHome")!,
                                  selectedImage: UIImage(named: "iconHomeSelceted")!,
                                  tag: TabbarContentType.HomePage.rawValue)
        
        addNavChildViewController(controller: mmallController, title: "音乐馆",
                                      image: UIImage(named: "iconMusic")!,
                                      selectedImage: UIImage(named: "iconMusicSelceted")!,
                                      tag: TabbarContentType.Articl.rawValue)
        
        
        addNavChildViewController(controller: tipOffController, title: "部落",
                                  image: UIImage(named: "iconbuluo")!,
                                  selectedImage: UIImage(named: "iconbuluoSelceted")!,
                                  tag: TabbarContentType.Cases.rawValue)
        
     
        addNavChildViewController(controller: messageController, title: "消息",
                                          image: UIImage(named: "iconMsg")!,
                                          selectedImage: UIImage(named: "iconMsgSelceted")!,
                                          tag: TabbarContentType.Articl.rawValue)
 
        
        
      
 
        addNavChildViewController(controller: mineController, title: "我的",
                                  image: UIImage(named: "iconMine")!,
                                  selectedImage: UIImage(named: "iconMineSelected")!,
                                  tag: TabbarContentType.Mine.rawValue)
 
    }
    
    
    private func addNavChildViewController(controller: UIViewController, title: String, image: UIImage, selectedImage: UIImage, tag:Int) {
        controller.title = title
        if controller == homePageController || controller == tipOffController{
            controller.navigationItem.title = ""
        }
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
        //viewController.viewWillAppear(true)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.selectedItemTag = item.tag
        if selectedItemTag == TabbarContentType.HomePage.rawValue {
            homePageController.viewWillAppear(true)
        }
        if selectedItemTag == TabbarContentType.Cases.rawValue {
            tipOffController.viewWillAppear(true)
        }
    }
}

