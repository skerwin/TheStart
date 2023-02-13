//
//  AppDelegate.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/14.
//

import UIKit
import XHLaunchAd
import SwiftyJSON
import Alamofire

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
        
        UIApplication.shared.statusBarStyle = .lightContent
        window?.backgroundColor = ZYJColor.main
        if getAcctount() != "" && getToken() != ""{
            self.window?.rootViewController = MainTabBarController()
        }else{
            self.window?.rootViewController = UIStoryboard.getNewLoginController()
        }
//      WXApi.checkUniversalLinkReady { step, resut in
//           print(step)
//           print(resut)
//           print("2134")
//       }
        
        let imageAdconfiguration = XHLaunchImageAdConfiguration.default()
        XHLaunchAd.setLaunch(.launchImage)
        XHLaunchAd.setWaitDataDuration(5)

        let  Url = URL.init(string: (URLs.getHostAddress() + HomeAPI.boot_imgPath))
        print(Url!.absoluteString)
        var request: DataRequest?

        let token = ""
        let headers: HTTPHeaders = [
             "x-access-appid": "ty9fd2848a039ab554",
             "x-access-token": token
         ]
        request =  AF.request(Url!, method: .post, parameters: nil,encoding: JSONEncoding.default, headers: headers)

        request?.responseJSON(completionHandler: { (response) in
            let result = response.result
            switch result {
            case .success:
                guard let dict = response.value else {
                    print("数据请求出错")
                    return
                }
                let responseJson = JSON(dict)
                let responseData = responseJson[BerResponseConstants.responseData];
//
//
                let list:[ImageModel]  = getArrayFromJson(content: responseData)

                imageAdconfiguration.duration = 3;
                imageAdconfiguration.imageNameOrURLString = list.first!.pic;
                //imageAdconfiguration.openModel = "http://www.it7090.com"
                XHLaunchAd.imageAd(with: imageAdconfiguration, delegate: self)

                print(Url!.absoluteString)
                print(responseJson)
             case .failure:
                print("数据请求出错")
             }
        })

        
        
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
        JSHAREService.setDebug(false)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        //这个方法 应用前台在前台直接被杀死会执行 先退出后台在杀死不会执行，而且这个方法极短不要做计算处理
        setStringValueForKey(value: "" as String, key: Constants.UpdateVerion)
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        
        JSHAREService.handleOpen(url)
        let result = PaySDK.instance.handleOpenURL(url)
        return result
         
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        JSHAREService.handleOpen(url)
        let result = PaySDK.instance.handleOpenURL(url)
        return result
     }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let result = PaySDK.instance.handleOpenURL(url)
        JSHAREService.handleOpen(url)
        return result
         
    }
    
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        JSHAREService.handleOpen(userActivity.webpageURL)
        let result = WXApi.handleOpenUniversalLink(userActivity, delegate: PaySDK.instance)
        return result
     }
    
 
 }

