//
//  WeChatTools.swift
//  WeChatDemo
//
//  Created by wangxiaole on 2018/12/10.
//  Copyright © 2018年 wangxiaole. All rights reserved.
//

import UIKit

/* ============================== UserDefaults ============================== */
fileprivate let kWechatAccount = "wechatAccount"
fileprivate let kWechatPassword = "wechatPassword"
fileprivate let kWechatUserId = "wechatUserId"

class WeChatTools: NSObject {
    // 当前聊天的userId
    var currentChatUserId: String?
 
    static let shared: WeChatTools = {
        let tools = WeChatTools()
 
        return tools
    }()
}

// MARK:- 登录相关
extension WeChatTools {
    // MARK: 手动登录
    func login(with account: String, pwd: String, errorBlock:@escaping (Error?) -> ()) {
 
    }
    // MARK: 自动登录
    func autoLogin() -> (Bool) {
        // 取出账号和密码
        var account: String?
        var pwd: String?
        self.readCurrentUser { (myAccount, myPwd) in
            account = myAccount
            pwd = myPwd
        }
        if account == nil || pwd == nil { // 没有保存账号或密码
            //print("没有保存账号或密码")
            return false
        } else {    // 自动登录
            //print("启用自动登录")
 
            return true
        }
    }
}

// MARK:- 信息操作
extension WeChatTools {
    // MARK: 获取当前用户的userId
    func getCurrentUserId() -> String {
         return "userId"
    }
}
 

// MARK:- 一些处理
extension WeChatTools {
    // MARK: 存储用户信息
    func storeCurrentUser(_ account: String, _ password: String) {
        // 存储账号和密码
        UserDefaults.standard.set(account, forKey: kWechatAccount)
        UserDefaults.standard.set(password, forKey: kWechatPassword)
    }
    // MARK: 读取用户信息
    func readCurrentUser(info:@escaping (String?, String?)->Void) {
        // 取出账号和密码
        let account = UserDefaults.standard.string(forKey: kWechatAccount)
        let pwd = UserDefaults.standard.string(forKey: kWechatPassword)
        info(account, pwd)
    }
    // MARK: 跳转到用户界面
    func trans2UserVC() {
//        UIApplication.shared.keyWindow?.rootViewController = UserViewController()
    }
}
// MARK:- 历史记录
extension WeChatTools {
    // MARK:- 从本地获取
    func getLocalMsgs(userId: String?, message: ImMessageModel? = nil) -> [ImMessageModel]? {
        guard let userId = userId else { return nil }
        var imModels: [ImMessageModel] = []
        for i in 0..<12 {
            let msg = ImMessageModel()
            msg.message = "测试测试测试[微笑]www.baidu.com[微笑]"
            msg.fromUserId = userId
            if i == 1 {
                msg.msgType = "image"
            } else if i == 2 {
                msg.msgType = "text"
            }else{
                msg.msgType = "text"
            }
            imModels.append(msg)
        }
        
        for i in 0..<12 {
            let msg = ImMessageModel()
            msg.message = "15640921307"
            msg.fromUserId = WeChatTools.shared.getCurrentUserId()
            if i == 1 {
                msg.msgType = "image"
            } else if i == 2 {
                msg.msgType = "text"
            } else {
                msg.msgType = "text"
                msg.message = "测试测试测试测试测试测试[酷]测试测试测试测试测试测试测试测[微笑]试测试测试测试测试测试测试测试"
            }
            imModels.append(msg)
        }
        
        return imModels
        // sdk 取出来对话信息
        //        let session = NIMSession.init(userId, type: .P2P)
        //        return NIMSDK.shared().conversationManager.messages(in: session, message: message, limit: 10)
    }
    
 }

