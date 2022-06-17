//
//  AppDelegate.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/14.
//

import UIKit


let weixinAPPID = "wxce795feb2aac395a";
let aliPayAPPID = "aliPay2021003109634497";
let weixinUniversalLink = "https://www.gskanglin.cn/thestart/";

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
 
        
        PaySDK.alipayAppid = aliPayAPPID
        WXApi.registerApp(weixinAPPID, universalLink: weixinUniversalLink)
        
        
        window?.backgroundColor = ZYJColor.main
        if getAcctount() != "" && getToken() != ""{
            self.window?.rootViewController = MainTabBarController()
        }else{
            self.window?.rootViewController = UIStoryboard.getNewLoginController()
        }
        
        window?.makeKeyAndVisible()
        
        return true
    }
    // MARK: UISceneSession Lifecycle

   
    
    
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
         return PaySDK.instance.handleOpenURL(url)
        //return WXApi.handleOpen(url, delegate: PaySDK.instance)
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
         return PaySDK.instance.handleOpenURL(url)
        //return WXApi.handleOpen(url, delegate: PaySDK.instance)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
         return PaySDK.instance.handleOpenURL(url)
    }
    
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        WXApi.handleOpenUniversalLink(userActivity, delegate: PaySDK.instance)
    }
}

