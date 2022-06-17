//
//  MineViewController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/07/29.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

//import IQKeyboardManagerSwift
import SwiftyJSON
import ObjectMapper
import SDCycleScrollView
import UIKit

class MineViewController: BaseTableController,Requestable{
    
    
    @IBOutlet weak var guideCellBgView: UIView!
    
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isAuthon: UIImageView!
     
    @IBOutlet weak var pubView: UIView!
    @IBOutlet weak var collectView: UIView!
    @IBOutlet weak var VipCenterVIew: UIView!
    
    @IBOutlet weak var myorderView: UIView!
    
    var usermodel = UserModel()
    @IBOutlet weak var authLabel: UILabel!
    
    
    @IBOutlet weak var huiyuanLabel: UILabel!
    @IBOutlet weak var xingbiLabel: UILabel!
    var rightBarButton:UIButton!
    
    var lefttBarButton:UIButton!
    
    func createRightNavItem() {
        
        rightBarButton = UIButton.init()
        let bgview = UIView.init()
 
        rightBarButton.frame = CGRect.init(x: 0, y: 6, width: 70, height: 28)
        rightBarButton.setTitle("设置", for: .normal)
        bgview.frame = CGRect.init(x: 0, y: 0, width: 65, height: 44)
        
        rightBarButton.addTarget(self, action: #selector(rightNavBtnClic(_:)), for: .touchUpInside)
      
        rightBarButton.setTitleColor(.black, for: .normal)
        //rightBarButton.backgroundColor = colorWithHexString(hex: "#228CFC")
        rightBarButton.layer.masksToBounds = true
        rightBarButton.layer.cornerRadius = 5;
        rightBarButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
     
        bgview.addSubview(rightBarButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: bgview)
        
        
        lefttBarButton = UIButton.init()
        let bgview2 = UIView.init()
 
        lefttBarButton.frame = CGRect.init(x: 0, y: 6, width: 70, height: 28)
        lefttBarButton.setTitle("消息", for: .normal)
        bgview2.frame = CGRect.init(x: 0, y: 0, width: 65, height: 44)
        
        lefttBarButton.addTarget(self, action: #selector(leftNavBtnClic(_:)), for: .touchUpInside)
      
        lefttBarButton.setTitleColor(.black, for: .normal)
        //rightBarButton.backgroundColor = colorWithHexString(hex: "#228CFC")
        lefttBarButton.layer.masksToBounds = true
        lefttBarButton.layer.cornerRadius = 5;
        lefttBarButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
     
        bgview2.addSubview(lefttBarButton)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: bgview2)
        
     }

    @objc func leftNavBtnClic(_ btn: UIButton){
        let messageController = ContactListController()

        self.navigationController?.pushViewController(messageController, animated: true)
    }
    @objc func rightNavBtnClic(_ btn: UIButton){
        let controller = UIStoryboard.getSettiingControllerTable()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createRightNavItem()
        loadData()
        if checkMarketVer(){
            huiyuanLabel.text = "信息发布"
            xingbiLabel.text = "地址管理"
        }else{
            huiyuanLabel.text = "我的会员"
            xingbiLabel.text = "我的星币"
        }
        addGestureRecognizerIgnoreTableView(view: pubView, target: self, actionName: "pubViewAction")
        addGestureRecognizerIgnoreTableView(view: collectView, target: self, actionName: "collectViewAction")
        addGestureRecognizerIgnoreTableView(view: VipCenterVIew, target: self, actionName: "VipCenterVIewAction")
        addGestureRecognizerIgnoreTableView(view: myorderView, target: self, actionName: "myorderViewAction")
        self.title = "我的"
        guideCellBgView.layer.masksToBounds = true
        guideCellBgView.layer.cornerRadius = 10
        self.tableView.backgroundColor = ZYJColor.main
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.separatorColor = UIColor.gray
        self.tableView.tableFooterView = UIView()
        let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
        tableView.mj_header = addressHeadRefresh
         headImg.layer.cornerRadius = 29;
        headImg.layer.masksToBounds = true
    }
    
    @IBAction func editHeaderAction(_ sender: Any) {
        let controller = UIStoryboard.getPersonsInfoController()
        controller.userModel = self.usermodel
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func refreshList() {
        loadData()
     }
    func loadData(){
        let requestParams = HomeAPI.userinfoPathAndParam()
        getRequest(pathAndParams: requestParams,showHUD:false)
     }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
     }
 
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        tableView.mj_header?.endRefreshing()
        if requestPath.containsStr(find: HomeAPI.userinfoPath){
            super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
           
            usermodel = Mapper<UserModel>().map(JSONObject: responseResult.rawValue)
            
            setIntValueForKey(value: usermodel?.uid, key: Constants.userid)
                      
           if usermodel!.vip == 1{
               setIntValueForKey(value: 1, key: Constants.isVip)
               setIntValueForKey(value: usermodel?.vip_id, key: Constants.vipId)
           }else{
               setIntValueForKey(value: 0, key: Constants.isVip)
               setIntValueForKey(value: usermodel?.vip_id, key: Constants.vipId)
           }
           
           
            nameLabel.text = usermodel?.nickname
            if usermodel?.is_shiming == 2{
                authLabel.text = "已认证"
              // isAuthon.image = UIImage.init(named: "yirenzheng")
            }else{
                authLabel.text = "未认证"
              // isAuthon.image = UIImage.init(named: "weirenzheng")
            }
            headImg.displayImageWithURL(url: usermodel?.avatar_check)
           
            self.tableView.reloadData()
        }else if requestPath.containsStr(find: HomeAPI.logoutPath){
            logoutAccount(account: "")
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.getNewLoginController()
        }
      
    }
    
    @objc private func pubViewAction() {
        let controller = MyPubViewController()
        self.navigationController?.pushViewController(controller, animated: true)
      }
    
    @objc private func collectViewAction() {
        let controller = MyCollectViewController()
        self.navigationController?.pushViewController(controller, animated: true)
      }
    
    @objc private func VipCenterVIewAction() {
        
        if checkMarketVer(){
            let controller = UIStoryboard.getMyToPubController()
            self.navigationController?.pushViewController(controller, animated: true)
        
        }else{
            let controller = VipCenterViewController()
            controller.usermodel = self.usermodel
            self.navigationController?.pushViewController(controller, animated: true)
        }
    
       
      }
    
    @objc private func myorderViewAction() {
        if checkMarketVer(){
            let controller = GoodsMenuController()
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
            let controller = MyOrderViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
      
      }
 
    @IBAction func editPersons(_ sender: Any) {
        let controller = UIStoryboard.getPersonsInfoController()
        controller.userModel = self.usermodel
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "我的"
     }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
     }
 
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0{
            
            if checkMarketVer(){
                let controller = addressListController()
                //controller.usermodel = self.usermodel
                self.navigationController?.pushViewController(controller, animated: true)
            }else{
                let controller = MyStarCoinController()
                controller.usermodel = self.usermodel
                self.navigationController?.pushViewController(controller, animated: true)
            }
 
        }
        
        else if indexPath.row == 1{
            let controller = InfoAuthenController()
            if usermodel?.is_shiming == 2 || usermodel?.shiming_status == 0{
                controller.isShimin = true
            }else{
                controller.isShimin = false
            }
            if usermodel?.is_audio == 2 || usermodel?.audio_status == 0{
                controller.isAudio = true
            }else{
                controller.isAudio = false
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else if indexPath.row == 2{
            if checkMarketVer(){
                let controller = UIStoryboard.getFeedBackController()
                self.navigationController?.pushViewController(controller, animated: true)
            }else{
                let noticeView = UIAlertController.init(title: "", message: "您确定拨打客服联系电话吗？", preferredStyle: .alert)
                  noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
                      let urlstr = "telprompt://" + "15002500877"
                     if let url = URL.init(string: urlstr){
                          if #available(iOS 10, *) {
                             UIApplication.shared.open(url, options: [:], completionHandler: nil)
                         } else {
                             UIApplication.shared.openURL(url)
                          }
                       }
                 }))
                 noticeView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
                    
                }))
                self.present(noticeView, animated: true, completion: nil)
            }
           
            
          
        }
        
        else if indexPath.row == 3{
            let noticeView = UIAlertController.init(title: "提示", message: "您确定退出账号，退出后需要重新登陆", preferredStyle: .alert)
            noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { [self] (action) in
 
                  let requestParams = HomeAPI.logoutPathAndParam()
                 self.getRequest(pathAndParams: requestParams,showHUD:false)
     
            }))
             noticeView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
                
            }))
            self.present(noticeView, animated: true, completion: nil)
         
        }
        else if indexPath.row == 4{
              let controller = MyOrderViewController()
              self.navigationController?.pushViewController(controller, animated: true)
         }
        else if indexPath.row == 5{
            
            
//            let controller = UIStoryboard.getFeedBackController()
//            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        else if indexPath.row == 6{
//            let controller = UIStoryboard.getPayViewController()
//            self.navigationController?.pushViewController(controller, animated: true)
//

        }
 
    }
    
}
 

