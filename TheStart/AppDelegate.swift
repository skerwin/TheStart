//
//  AppDelegate.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/14.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window?.backgroundColor = ZYJColor.main
        self.window?.rootViewController =  MainTabBarController()
        window?.makeKeyAndVisible()
        
        return true
    }
    // MARK: UISceneSession Lifecycle

   


}

