//
//  BaseViewController.swift
//  BossJob
//
//  Created by zhaoyuanjing on 2017/09/26.
//  Copyright © 2017年 zhaoyuanjing. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDCycleScrollView


class BaseViewController: UIViewController,AlertPresenter,LoadingPresenter,AccountAndPasswordPresenter{
    
    let item = UIBarButtonItem(title: "", style: .plain, target: BaseViewController.self, action: nil)

    var page = 1
    var limit = 10
    var pagenum = 10
    
//    override func loadView() {
//        super.loadView()
//        self.edgesForExtendedLayout = []
//    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //去掉导航栏箭头旁边的字
        self.view.backgroundColor = ZYJColor.main
        self.navigationItem.backBarButtonItem = item;
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenChange(note:)), name: NSNotification.Name(rawValue: Constants.TokenChangeRefreshNotification), object: nil)
     }
    
    @objc func tokenChange(note: NSNotification){
        self.logoutAccount(account: "")
        self.showSingleButtonAlertDialog(message: "您的账号登录时间已过期，请重新登录") { [self] (type) in 
            //let requestParams = HomeAPI.logoutPathAndParam()
            //self.getRequest(pathAndParams: requestParams,showHUD:false)
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.getNewLoginController()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        
        DialogueUtils.dismiss()
    }
    func onFailure(responseCode: String, description: String, requestPath: String) {
        DialogueUtils.dismiss()
        showOnlyTextHUD(text: description)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.resignFirstResponder()
    }
    
    
    //收键盘注册点击事件
    func backKeyBoard(){
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(self.handleTap(sender:))))
    }
    
    
    //对应方法
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            //  你的textfield.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
 
}
