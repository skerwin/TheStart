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
let jiGuangID = "7235317f359e7603ad04e4c9";

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
 
        jshareInit()
        PaySDK.alipayAppid = aliPayAPPID
        WXApi.registerApp(weixinAPPID, universalLink: weixinUniversalLink)
        
        
        window?.backgroundColor = ZYJColor.main
        if getAcctount() != "" && getToken() != ""{
            self.window?.rootViewController = MainTabBarController()
        }else{
            self.window?.rootViewController = UIStoryboard.getNewLoginController()
        }
     
//        WXApi.checkUniversalLinkReady { step, resut in
//
//            print(step)
//            print(resut)
//            print("2134")
//        }
        
        window?.makeKeyAndVisible()
        
        return true
    }
    // MARK: UISceneSession Lifecycle

    func jshareInit(){
        let shareConfig = JSHARELaunchConfig.init()
        shareConfig.appKey = jiGuangID;
       // shareConfig.qqAppId = "1111415077"
      //  shareConfig.qqAppKey = "sjVMivqYmZz7NAQ3"
        shareConfig.weChatAppId = "wxce795feb2aac395a"
        shareConfig.weChatAppSecret = "b7c45a7cca0da236cb0e9be5254d73c8"
        shareConfig.universalLink = weixinUniversalLink
        JSHAREService.setup(with: shareConfig)
        JSHAREService.setDebug(true)
    }
    
    
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        
        JSHAREService.handleOpen(url)
        return PaySDK.instance.handleOpenURL(url)
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
         JSHAREService.handleOpen(url)
         return PaySDK.instance.handleOpenURL(url)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
         JSHAREService.handleOpen(url)
         return PaySDK.instance.handleOpenURL(url)
    }
    
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        JSHAREService.handleOpen(userActivity.webpageURL)
        
        return WXApi.handleOpenUniversalLink(userActivity, delegate: PaySDK.instance)
    }
    
 
 }

