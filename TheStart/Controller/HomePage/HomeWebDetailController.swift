//
//  HomeWebDetailController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/10/28.
//  Copyright © 2021 gansukanglin. All rights reserved.
//
 
import UIKit
import WebKit
import ObjectMapper
import SwiftyJSON
import MJRefresh
import AVFoundation
import AVKit
class HomeWebDetailController: BaseViewController ,Requestable,WKScriptMessageHandler,WKUIDelegate,UINavigationControllerDelegate {
    
    var urlString: String?
    
    var rank:Int = 0

    var score:Int = 0

    // 进度条
    lazy var progressView = UIProgressView()
    var player : AVAudioPlayer?
    var playVC:AVPlayerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ZYJColor.main
        self.title = "飞机大战"
        loadWebView()
         
    }
     func loadWebView() {
 
       // //print(urlString)
        var myRequest = URLRequest(url: URL.init(string: urlString!)!)
        //var myRequest = URLRequest(url: URL.init(string: (urlstr.urlEncoded()))!)
        myRequest.cachePolicy = .useProtocolCachePolicy
        myRequest.timeoutInterval = 60
        self.changeWebView.load(myRequest)
        self.view.addSubview(changeWebView)
 
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.playLocationMusic("plane.mp3")
        self.addPlayerView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //self.stopMusic()
        self.stopPlay()
    }
      
    
    func addPlayerView(){
        guard let url = Bundle.main.url(forResource: "plane", withExtension: "mp3") else {
            return
        }
        
        //通知拿到播放结束的时间节点并且继续play
        NotificationCenter.default.addObserver(self, selector: #selector(goBackFinished), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)

        self.playVC = AVPlayerViewController()
        self.playVC.player = AVPlayer(url: url)
       // self.playVC.view.frame = CGRect(x: 0, y: 68, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 68)
        self.playVC.showsPlaybackControls = true
        //self.view.addSubview(self.playVC.view)
        self.playVC.player?.play()
    }
    
    @objc func goBackFinished() {
        replay()
    }
    
    func replay() {
        self.playVC.player?.seek(to: CMTimeMake(value: 0, timescale: 1))
        self.playVC.player?.play()
    }
    
    func stopPlay() {
        self.playVC.player?.pause()
    }
    
     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func playLocationMusic(_ musicName : String){
            //1 获取资源的URL
            guard let url = Bundle.main.url(forResource: musicName, withExtension: nil) else { return }
            
            //0 判断和暂停/停止的对象是否同一首歌曲(继续播放的时候不会切歌)
            if player?.url == url{
                player?.play()
                return
            }
            
            //2 根据URL创建AVAudioPlayer对象
            guard let audioPlayer = try? AVAudioPlayer(contentsOf: url) else { return }
         
            self.player = audioPlayer
            
            //3 播放音乐
            audioPlayer.play()
        }
    
    func pauseMusic() {
          player?.pause()
      }
      
    func stopMusic(){
          player?.stop()
          player?.currentTime = 0
      }
    
    lazy var changeWebView: WKWebView = {
        let preferences = WKPreferences()
        // 开启js
        preferences.javaScriptEnabled = true
        // 创建WKWebViewConfiguration
        let configuration = WKWebViewConfiguration()
       //是否支持JavaScript
       configuration.preferences.javaScriptEnabled = true
       //不通过用户交互，是否可以打开窗口
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        // 设置WKWebViewConfiguration的WKPreferences
        configuration.preferences = preferences
        // 创建WKUserContentController
        let userContentController = WKUserContentController()
        // 配置WKWebViewConfiguration的WKUserContentController
        configuration.userContentController = userContentController
        // 给WKWebView与Swift交互起一个名字：callbackHandler，WKWebView给Swift发消息的时候会用到
        // 此句要求实现WKScriptMessageHandler协议
        configuration.userContentController.add(self, name: "callbackHandler")
         //不通过用户交互，是否可以打开窗口
       // webConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = false
        let webFrame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        let webView = WKWebView(frame: webFrame, configuration: configuration)
        // webView.backgroundColor = UIColor.blue
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.isOpaque = false
        webView.backgroundColor = ZYJColor.main
        webView.scrollView.backgroundColor = ZYJColor.main
//        webView.navigationDelegate = self
        // 此句要求实现WKNavigationDelegate协议
        webView.navigationDelegate = self
        return webView
    }()
    
    
    lazy var shareView: ShareView = {
        let sv = ShareView.getFactoryShareView { (platform, type) in
            self.shareInfoWithPlatform(platform: platform)
            
        }
        self.view.addSubview(sv!)
        return sv!
    }()

    func shareInfoWithPlatform(platform:JSHAREPlatform){
        let message = JSHAREMessage.init()
        
       // let dateString = DateUtils.dateToDateString(Date.init(), dateFormat: "yyy-MM-dd HH:mm:ss")
        
        let scoreStr = intToString(number: self.score);
        message.title = "我在启程时代“打飞机”获得了" + scoreStr + "分，快来比一比吧"
        message.text = "天亮前出发与梦想启程"
 
        message.platform = platform
        message.mediaType = .link;
        message.url = "https://apps.apple.com/cn/app/%E6%A9%99%E5%BF%83%E6%97%B6%E4%BB%A3/id1626455805"
        let imageLogo = UIImage.init(named: "logoIcon")
       
        message.image = imageLogo?.pngData()
        var tipString = ""
        JSHAREService.share(message) { (state, error) in
            if state == JSHAREState.success{
                tipString = "分享成功";
            }else if state == JSHAREState.fail{
                tipString = "分享失败";
            }else if state == JSHAREState.cancel{
                tipString = "分享取消";
            } else if state == JSHAREState.unknown{
                tipString = "Unknown";
            }else{
                tipString = "Unknown";
            }
             DispatchQueue.main.async(execute: {
                
                let tipView = UIAlertController.init(title: "", message: tipString, preferredStyle: .alert)
                tipView.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: { (action) in
     
                }))
                self.present(tipView, animated: true, completion: nil)

            })
        }
 
    }
      
     
}
extension HomeWebDetailController: WKNavigationDelegate {
    
    // 监听网页加载进度
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        decisionHandler(.allow)
    }
    
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        DialogueUtils.showWithStatus("详情加载")
     }
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DialogueUtils.dismiss()
      
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("\(message.name)" + "\(message.body)")
        let dict = message.body as! [String : Any];

 //        chatMode.text = data["msn"] as? String
 
 
        
        self.score = dict["score"] as! Int;
        self.rank = dict["rank"] as! Int ;
        
        self.shareView.show(withContentType: JSHAREMediaType(rawValue: 3)!)

     }
    
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        let alertView = UIAlertController.init(title: "提示", message: "加载失败", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title:"确定", style: .default) { okAction in
            _=self.navigationController?.popViewController(animated: true)
        }
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
    // MARK: 重置barView的位置
    func resetChatBarFrame() {

        UIApplication.shared.keyWindow?.endEditing(true)
        UIView.animate(withDuration: kKeyboardChangeFrameTime, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
   
 
    
}

 
