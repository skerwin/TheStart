//
//  WebSocketManager.swift
//  Wtb
//
//  Created by sorath on 2019/1/10.
//  Copyright © 2019 sorath. All rights reserved.
//

import UIKit
import Starscream

//对websocket的单例处理，监听进入前后台，以及设置重连、断开、回调、网络检测、心跳等机制
//注意：1.目前设置的心跳包重连时间是7s
//注意：2.目前连接1s后进行登录操作
//注意：3.错误重连次数为10次，成功连接后次数归0

let websocketUrl = "ws://122.114.14.227:20003"

import Reachability
class WebSocketManager: NSObject {
    static let instance = WebSocketManager()
    var reConnectTime = 0 //设置重连次数
    let reConnectMaxTimes = 10  //最大重连次数
    
    var reLoginTime:Int = 0 //设置重新登录次数
    let reLoginMaxTimes:Int = 10  //最大重新登录次数

    var reachability: Reachability! //判断网络连接
    var timer:Timer = Timer.init()
    
    var socket:WKWebSocket!
  
    var onText:((String)->Void)?
    
    var onData:((Data)->Void)?
    
    //对回调的管理
    func managerBlock(){
        //连接成功后，连接次数归0
        socket.onConnect = {[weak self] in
            self?.reConnectTime = 0
        }
        
//        socket.onData = {(data) in
//
//        }
//
//        socket.onText = {(text) in
//
//        }
        
        //失败的重连
        socket.onDisconnect = {[weak self](error) in
            self?.socketReconnect()
        }
    }
    
    func setOntext(onTextBlock:((String)->Void)?){
        socket.onText = onTextBlock
     }

    func openSocket(){
        let paramsStr = "?type=login&token=" + getToken()
 
        //print(websocketUrl + paramsStr)
        
        socket = WKWebSocket.init()
        socket.initOpen(url: websocketUrl + paramsStr)
        
        //设置block
        managerBlock()

        //连接
        socket.connect()

         //心跳
        setHeartBeat()

        //设置进入前后台通知
        setNotication()


    }
    
    func sendMessage(msg:String){
        self.socket.socketWrite(string: msg)
    }
    
    
    deinit {
        socketDisConnect()
        NotificationCenter.default.removeObserver(self)
    }
    
    class func shared() -> WebSocketManager{
        instance.socketReconnect()
        return instance
    }

    
}



//MARK: - noti/timer
extension WebSocketManager{
    
    private func setNotication(){
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        do {
            reachability = try Reachability.init()
            networkStatusListener()
        } catch {
            //print("Unable to create Reachability")
            return
        }
        
    }
    
  
    //开始监听
    private func networkStatusListener() {
        // 1、设置网络状态消息监听 2、获得网络Reachability对象
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: Notification.Name.reachabilityChanged,object: reachability)
        do{
            // 3、开启网络状态消息监听
            try reachability.startNotifier()
        }catch{
            //print("could not start reachability notifier")
        }
    }
    
    // 主动检测网络状态
    @objc func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability // 准备获取网络连接信息
        if reachability.connection != .unavailable { // 判断网络连接状态
            //如果有网络变化，则尝试重新建立连接
            socketReconnect()
        }
    }
    //设置心跳包
    private func setHeartBeat(){
        //定时器，7s维持心跳包
        timer = Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(heartBeat), userInfo: nil, repeats: true)
    }
    //心跳
    @objc func heartBeat(){
        if socket.isConnected {
            socket.socketHeartBeat()
        }else{
            //socketReconnect()
        }
    }
}

//MARK: - action
extension WebSocketManager{
    //进入后台,断开链接
    @objc func appDidBecomeActive(){
        socketDisConnect()
    }
    
    //进入前台,重新连接
    @objc func appwillEnterForeground(){
        socketReconnect()
    }
}

//MARK: - re/close
extension WebSocketManager{
    //重新连接
    func socketReconnect() {
        //如果socket正在连接，则取消
        if socket.isConnected {
            return
        }
        //判断网络情况，如果网络正常，可以执行重连
        if reachability.connection != .unavailable {
            //设置重连次数，解决无限重连问题
            reConnectTime =  reConnectTime + 1
            if reConnectTime < reConnectMaxTimes {
                //添加重连延时执行，防止某个时间段，全部执行
                let time: TimeInterval = 2.0
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                    if self.socket.isConnected == false {
                        //重新连接，并且重新登录
                        self.socket.connect()
                    }
                }
            } else {
                //提示重连失败
                DialogueUtils.showSuccess(withStatus: "重连次数过多")
             }
        } else {
             DialogueUtils.showSuccess(withStatus: "无网络连接")
         }
    }
     //socket主动断开，放在app进入后台时，数据进入缓存。app再进入前台，app出现卡死的情况
    func socketDisConnect() {
        if socket.isConnected {
            socket.closeConnect()
        }
    }
 }




//checkNetWork() //初始化网络

////重新登录
//func reLogin(){
//    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//        self.socket.socketLogin()
//    }
//}

//func  checkNetWork(){
//    do {
//        reachability = try Reachability.init()
//    } catch {
//        //print("Unable to create Reachability")
//        return
//    }
//
//    // 检测网络连接状态
//    if reachability.connection == .wifi{
//        //print("网络连接：wifi")
//    }
//    else if reachability.connection == .cellular{
//
//    }
//    else if reachability.connection == .unavailable{
//        //print("网络连接：不可用")
//    }
//    else {
//        //print("网络连接：不可用")
//    }
//}
////MARK: - analyze
//extension WebSocketManager{
//    //处理websocket 返回的数据，并且决定是否分发
//    private func analyzeResult(jsonText:String,needOutGiving:((Bool)->Void)){
//        let map = [String : Any]()
//        //String.getDictionaryFromJSONString(jsonString: jsonText)
//
//        if map["msgType"] is Int {
//            let msgType = map["msgType"] as! Int
//            //当type不为登录结果时分发（不能识别类型时也直接分发）
//            if msgType == WKSocketMSGType.login.rawValue {
//                //对登录结果的处理，失败时重新登录，最多10次
//                if let result = map["result"] as? Bool{
//                    if result == false{
//                        //登录失败、设置重新登录
//                        if reLoginTime < reLoginMaxTimes{
//                            reLogin()
//                            reLoginTime = reLoginTime + 1
//                        }
//
//                    }else{
//                        //登录成功,次数归0
//                        reLoginTime = 0
//                    }
//                }
//                //登录s返回数据不需要前端处理，不分发
//                needOutGiving(false)
//            }else{
//                //能识别为其他类型，分发
//                needOutGiving(true)
//                return
//            }
//        }else{
//            //不能识别类型时也直接分发
//            needOutGiving(true)
//            return
//        }
//
//    }
//}
//处理返回数据
//        socket.onText = { [weak self] (text) in
//            self?.analyzeResult(jsonText: text, needOutGiving: { (isNeeded) in
//                if isNeeded{
//                    if self?.onText != nil{
//                        self?.onText!(text)
//                    }
//                }
//            })
//
//        }
