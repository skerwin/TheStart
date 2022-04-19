//
//  AccountManagerable.swift
//  BossJob
//
//  Created by zhaoyuanjing on 2017/09/27.
//  Copyright © 2017年 zhaoyuanjing. All rights reserved.
//

import Foundation

struct UserAccount {
    var account: String   //  账号
    var password: String  //  密码
    var userId: Int  //  用户唯一id
    var token: String     //  单点登录（超时重新登录用）
    var mobile: String    //  手机号
    
    var photo: String    //  图片
    
    var name: String    //  name
    
    var companyId: String
    
    //实际项目按需使用
}

protocol AccountAndPasswordPresenter: class {
    
    var isLogin: Bool { get set }
    /// 把用户最基本信息进行保存
    func saveBerAccountAndLoginState(userAccount: UserAccount)
    /// 把用户名和密码进行保存
    func saveAccountAndPassword(account: String,password: String,token:String,userid:Int)
    /// 退出帐号
    func logoutAccount(account: String)
    
}

 extension AccountAndPasswordPresenter {
    
    var isLogin: Bool {
        get {
            return boolForKey(key: Constants.isLogin)
        }
        set {
            setValueForKey(value: newValue as AnyObject, key: Constants.isLogin)
        }
    }
    
    func saveBerAccountAndLoginState(userAccount: UserAccount) {
        // 对密码进行Keychain存储
        
        setValueForKey(value: userAccount.account as AnyObject, key: Constants.loginId);
        setValueForKey(value: userAccount.userId as AnyObject, key: Constants.userid)
        setValueForKey(value: userAccount.password as AnyObject, key: Constants.password)
        
      
 
        setValueForKey(value: userAccount.name as AnyObject, key: Constants.name)
        setValueForKey(value: userAccount.photo as AnyObject, key: Constants.photo)
 
        isLogin = true
        
        
//        SSKeychain.setPassword(userAccount.password, forService: keychainServiceName, account: userAccount.account)
//        // 对memberId和token存储进UserDefaults
//        setValueForKey(value: userAccount.memberId as AnyObject, key: Constants.userid)
//        setValueForKey(value: userAccount.token as AnyObject, key: Constants.token)
//
    }
    func saveAccountAndPassword(account: String,password: String,token:String,userid:Int) {
        
            setValueForKey(value: account as AnyObject, key: Constants.account)
            setValueForKey(value: password as AnyObject, key: Constants.password)
            setValueForKey(value: token as AnyObject, key: Constants.token)
            setValueForKey(value: userid as AnyObject, key: Constants.userid)
    }
    
    func logoutAccount(account: String) {
        //      SSKeychain.deletePassword(forService: keychainServiceName, account: account)
        removeValueForKey(key: Constants.token)
        removeValueForKey(key: Constants.userid)
        removeValueForKey(key: Constants.account)
        removeValueForKey(key: Constants.password)
        
        
        removeValueForKey(key: Constants.isCheck)
        removeValueForKey(key: Constants.avatar)
        
        removeValueForKey(key: Constants.truename)
        removeValueForKey(key: Constants.nickname)
        removeValueForKey(key: Constants.gender)
        removeValueForKey(key: Constants.ExemptionAgreement)
        removeValueForKey(key: Constants.live_status)
        removeValueForKey(key: Constants.IMUserSig)
        
        
        
        isLogin = false
    }
    func changeRoleAccount(account: String) {
        logoutAccount(account: "")
        removeValueForKey(key: Constants.loginId)
       
        isLogin = false
    }
    
}

