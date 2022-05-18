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
    var usermodel = UserModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        addGestureRecognizerIgnoreTableView(view: pubView, target: self, actionName: "pubViewAction")
        addGestureRecognizerIgnoreTableView(view: collectView, target: self, actionName: "collectViewAction")
        addGestureRecognizerIgnoreTableView(view: VipCenterVIew, target: self, actionName: "VipCenterVIewAction")
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
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        
         usermodel = Mapper<UserModel>().map(JSONObject: responseResult.rawValue)
        
         setIntValueForKey(value:  usermodel?.uid, key: Constants.userid)
        
         nameLabel.text = usermodel?.nickname
         if usermodel?.is_shiming == 2{
            isAuthon.image = UIImage.init(named: "yirenzheng")
         }else{
            isAuthon.image = UIImage.init(named: "weirenzheng")
         }
        headImg.displayImageWithURL(url: usermodel?.avatar_check)
        
         self.tableView.reloadData()
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
        let controller = VipCenterViewController()
        self.navigationController?.pushViewController(controller, animated: true)
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
        return 7
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
            let controller = MyStarCoinController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        else if indexPath.row == 1{
            let controller = UIStoryboard.getAuthenController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else if indexPath.row == 2{
            let controller = MusicianAuthorController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        else if indexPath.row == 3{
            let controller = UIStoryboard.getMyToPubController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else if indexPath.row == 4{
              let controller = MyOrderViewController()
              self.navigationController?.pushViewController(controller, animated: true)
         }
        else if indexPath.row == 5{
            let controller = UIStoryboard.getFeedBackController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        else if indexPath.row == 6{
            let controller = UIStoryboard.getPayViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
 
    }
    
}
 

