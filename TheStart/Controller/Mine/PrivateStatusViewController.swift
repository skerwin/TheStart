//
//  PrivateStatusViewController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/08/17.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import WebKit
class PrivateStatusViewController: BaseViewController {

    
    var htmlString = ""
    
    var userAgreemrnt = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "隐私声明"
//        if userAgreemrnt{
//            //urlString = stringForKey(key: "user_agreement")!
//        }else{
//            //urlString = stringForKey(key: "privacy_url")!
//        }
        loadWebView()

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    lazy var changeWebView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        //初始化偏好设置属性：preferences
        webConfiguration.preferences = WKPreferences()
        //是否支持JavaScript
        webConfiguration.preferences.javaScriptEnabled = false
        //不通过用户交互，是否可以打开窗口
       // webConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = false
        
        let webFrame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        let webView = WKWebView(frame: webFrame, configuration: webConfiguration)
        // webView.backgroundColor = UIColor.blue
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.bounces = true
        webView.scrollView.showsVerticalScrollIndicator = true
        webView.scrollView.showsHorizontalScrollIndicator = true
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        
        
        return webView
    }()

    
    func html2String(content: String) -> String{
        
        let str = String.localizedStringWithFormat("<html><meta content=\"width=device-width, initial-scale=1.0, maximum-scale=3.0, user-scalable=0; \" name=\"viewport\" /><body style=\"overflow-wrap:break-word;word-break:break-all;white-space: normal; font-size:16px; color:#000000; \">%@</body></html>", content)
        //return str
        return str
        
    }
    func loadWebView() {
        
//        var myRequest = URLRequest(url: URL.init(string: urlString)!)
//        myRequest.cachePolicy = .useProtocolCachePolicy
//        myRequest.timeoutInterval = 60
        self.changeWebView.loadHTMLString(html2String(content: htmlString), baseURL: nil)
        //self.changeWebView.load(myRequest)
        
    }
}

extension PrivateStatusViewController: WKNavigationDelegate {
    
    // 监听网页加载进度
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
    }
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
       }
    
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
     }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
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
 
}
//             /** WKWebView  的简单使用，读取本地html文件 */
//             let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - navigationHeaderAndStatusbarHeight))
//             // addSubview   大家都懂，我就不解释了
//             view.addSubview(webView)
//             // 禁止顶部下拉和底部上拉效果，适用在  不让webview 有多余的滚动   设置后，滚动范围跟网页内容的高度相同
//             webView.scrollView.bounces = false
//             /** 加载本地html文件 */
//             //从主Bundle获取 HTML 文件的 url
//             let bundleStr = Bundle.main.url(forResource: "priavate", withExtension: "html")
//             webView.loadFileURL(bundleStr!, allowingReadAccessTo: Bundle.main.bundleURL)
