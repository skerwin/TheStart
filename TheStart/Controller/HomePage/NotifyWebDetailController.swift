//
//  NotifyWebDetailController.swift
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

class NotifyWebDetailController: BaseViewController ,Requestable, UIWebViewDelegate {
    
    var urlString: String?
    // 进度条
    lazy var progressView = UIProgressView()
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ZYJColor.main
        self.title = "详情"
        //urlString = "http://gskl.gswjceo.com/file/20220328/16484378995102.doc?doc-convert/preview"
        loadWebView()
         
    }
     func loadWebView() {
 
       // print(urlString)
        var myRequest = URLRequest(url: URL.init(string: urlString!)!)
        //var myRequest = URLRequest(url: URL.init(string: (urlstr.urlEncoded()))!)
        myRequest.cachePolicy = .useProtocolCachePolicy
        myRequest.timeoutInterval = 60
        self.changeWebView.load(myRequest)
        self.view.addSubview(changeWebView)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - 懒加载
    
 
    
    lazy var changeWebView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        //初始化偏好设置属性：preferences
        webConfiguration.preferences = WKPreferences()
        //是否支持JavaScript
        webConfiguration.preferences.javaScriptEnabled = true
        //不通过用户交互，是否可以打开窗口
       // webConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = false
        let webFrame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        let webView = WKWebView(frame: webFrame, configuration: webConfiguration)
        // webView.backgroundColor = UIColor.blue
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.bounces = true
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.navigationDelegate = self
        
        
        return webView
    }()
      
     
}
extension NotifyWebDetailController: WKNavigationDelegate {
    
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

 
