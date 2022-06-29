//
//  WorkerInfoViewController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/18.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh
import Reachability
import SnapKit
class WorkerInfoViewController: BaseViewController,Requestable {

    var tableView:UITableView!
    
    var headView:WorkerBaseInfo!
        
    var headerBgView:UIView!
    
    var footerView:ChatBtnView!
    
    var footerBgView:UIView!
    
    var dateID = 0
    
    var dataModel = JobModel()
    
    var rightBarButton:UIButton!
    var isCollect = 0
    
    var isFromMine = false
    
    var bgview:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "找场详情"
        createRightNavItem() 
        loadData()
        initHeadView()
        initFooterView()
        initTableView()
        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        let requestParams = HomeAPI.workDetailPathAndParams(id: dateID)
        getRequest(pathAndParams: requestParams,showHUD:false)
    }
    
    
    func createRightNavItem() {
        
        rightBarButton = UIButton.init()
        bgview = UIView.init()
 
        rightBarButton.frame = CGRect.init(x: 0, y: 0, width: 28, height: 28)
        bgview.frame = CGRect.init(x: 0, y: 0, width: 28, height: 28)
        
        rightBarButton.addTarget(self, action: #selector(rightNavBtnClic(_:)), for: .touchUpInside)
        
        rightBarButton.setBackgroundImage(UIImage.init(named: "shoucangs"), for: .normal)
     
        bgview.addSubview(rightBarButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: bgview)
        
    }

    @objc func rightNavBtnClic(_ btn: UIButton){
        
        if dataModel?.uid == getUserId() && isFromMine{
            let noticeView = UIAlertController.init(title: "", message: "你确定要删除本条信息么", preferredStyle: .alert)
            noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { [self] (action) in
                let requestParams = HomeAPI.workDelPathAndParams(id: dateID)
                postRequest(pathAndParams: requestParams,showHUD:false)
            }))
            noticeView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
                
            }))
            self.present(noticeView, animated: true, completion: nil)
        }else{
            if isCollect == 1{
                let requestParams = HomeAPI.delWorkCollectPathAndParams(id: dateID)
                postRequest(pathAndParams: requestParams,showHUD:false)
            }else{
                let requestParams = HomeAPI.workCollectPathAndParams(id: dateID)
                postRequest(pathAndParams: requestParams,showHUD:false)
            }
        }
       
     }
    func changeCollectBtn(){
        
        if isFromMine{
            rightBarButton.setBackgroundImage(UIImage.init(named: ""), for: .normal)
            rightBarButton.setTitle("删除", for: .normal)
            rightBarButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            rightBarButton.setTitleColor(colorWithHexString(hex: "#228CFC"), for: .normal)
            rightBarButton.frame = CGRect.init(x: 0, y: 0, width: 58, height: 28)
            bgview.frame = CGRect.init(x: 0, y: 0, width: 58, height: 28)
        }else{
            if isCollect == 1{
                rightBarButton.setBackgroundImage(UIImage.init(named: "shoucangzhong"), for: .normal)
            }else{
                rightBarButton.setBackgroundImage(UIImage.init(named: "shoucangs"), for: .normal)
            }
        }
       
    }
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
        if requestPath == HomeAPI.userCallPath || requestPath == HomeAPI.userImPathPath{
            
            var message = ""
            if requestPath == HomeAPI.userCallPath{
                message = "非会员每天限拨打3次电话，请¥98元充值会员,无限次拨打"
            }else{
                message = "非会员每天限发起3次聊天，请¥98元充值会员,无限次聊天"
            }
            
            let noticeView = UIAlertController.init(title: "", message: message, preferredStyle: .alert)
            noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { [self] (action) in
                let controller = UIStoryboard.getCashierDeskController()
                controller.paytype = .chargeVip
                controller.priceStr = "98.00"
                self.present(controller, animated: true)
            }))
            noticeView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
                
            }))
            self.present(noticeView, animated: true, completion: nil)
        }
    }


    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        
        if requestPath == HomeAPI.workCollectPath{
            isCollect = responseResult["if_collect"].intValue
            changeCollectBtn()
            showOnlyTextHUD(text: "收藏成功")
        }else if requestPath == HomeAPI.delWorkCollectPath{
            isCollect = responseResult["if_collect"].intValue
            changeCollectBtn()
            showOnlyTextHUD(text: "取消收藏成功")
        } else if requestPath == HomeAPI.userCallPath{
            callPhone()
        }
        else if requestPath == HomeAPI.userImPathPath{
            gotoMessage()
        }
        else if requestPath == HomeAPI.workDelPath{
            DialogueUtils.showSuccess(withStatus: "删除成功")
            delay(second: 0.1) { [self] in
    //            if (self.reloadBlock != nil) {
    //                self.reloadBlock!()
    //            }
                DialogueUtils.dismiss()
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        else{
            dataModel = Mapper<JobModel>().map(JSONObject: responseResult.rawValue)
            headView.configModel(model: dataModel!)
            isCollect = dataModel!.is_collect
            changeCollectBtn()
        }
        
       
         self.tableView.reloadData()
    }
    
    func gotoMessage(){
        let controller = UIStoryboard.getMessageController()
        controller.toID = dataModel!.uid
        controller.nameTitle = dataModel!.nickname
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func callPhone(){
        let urlstr = "telprompt://" + self.dataModel!.mobile
         if let url = URL.init(string: urlstr){
              if #available(iOS 10, *) {
                 UIApplication.shared.open(url, options: [:], completionHandler: nil)
             } else {
                 UIApplication.shared.openURL(url)
              }
           }
    }
    
    func initHeadView(){
        headView = Bundle.main.loadNibNamed("WorkerBaseInfo", owner: nil, options: nil)!.first as? WorkerBaseInfo
        headView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 210)
        headView.delegate = self
        headerBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 210))
        headerBgView.backgroundColor = UIColor.clear
        headerBgView.addSubview(headView)
        
      }
    
    
    func initFooterView(){
        footerView = Bundle.main.loadNibNamed("ChatBtnView", owner: nil, options: nil)!.first as? ChatBtnView
        footerView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 85)
        footerView.delegate = self
        footerBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 85))
        footerBgView.backgroundColor = UIColor.clear
        footerBgView.addSubview(footerView)
        
      }
    

    
    func initTableView(){
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = ZYJColor.main
        
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 240;
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.registerNibWithTableViewCellName(name: WorkerImgCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: WorkerInfoCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: WorkerVideoCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: VideoBalankCell.nameOfClass)

        self.tableView.tableHeaderView = headerBgView
        tableView.tableFooterView = footerBgView
 
        
        view.addSubview(tableView)
        
    }
 
}
extension WorkerInfoViewController:WorkerBaseInfoDelegate {
    func WorkerCommunicateAction(){
        
        
        if checkMarketVer(){
            
        }else{
            if dataModel!.uid == getUserId(){
                showOnlyTextHUD(text: "不能给自己拨打电话")
                return
            }
        }
        
        
      
        let noticeView = UIAlertController.init(title: "", message: "您确定拨打对方的联系电话吗？", preferredStyle: .alert)
         noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { [self] (action) in
 
             let pathAndParams = HomeAPI.userCallPathAndParams(type: 1)
             postRequest(pathAndParams: pathAndParams,showHUD: false)
 
        }))
        
        noticeView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
            
        }))
        self.present(noticeView, animated: true, completion: nil)
    }
    
    
}
extension WorkerInfoViewController:ChatBtnViewDelegate {
    func sumbitAction() {
        if dataModel!.uid == getUserId(){
            showOnlyTextHUD(text: "不能跟自己发起聊天哦")
            return
        }
        
        
        if checkMarketVer(){
            let controller = UIStoryboard.getMessageController()
            controller.toID = dataModel!.uid
            controller.nameTitle = dataModel!.nickname
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
             let pathAndParams = HomeAPI.userImPathPathAndParams(type: 1,to_uid: dataModel!.uid)
            postRequest(pathAndParams: pathAndParams,showHUD: false)
            
        }
        
        
    }
 
}
extension WorkerInfoViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: notifyModelList.count ,isdisplay: true)

        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerInfoCell", for: indexPath) as! WorkerInfoCell
            cell.selectionStyle = .none
            cell.configCell(model: self.dataModel!, isjob: false)
            return cell
        }else if indexPath.row == 1{
            
            
            if dataModel!.images.count == 0{
              
                let cell = tableView.dequeueReusableCell(withIdentifier: "VideoBalankCell", for: indexPath) as! VideoBalankCell
                cell.selectionStyle = .none
                cell.zanwu.text = "暂无图片资料"
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerImgCell", for: indexPath) as! WorkerImgCell
                cell.model = dataModel
                 cell.selectionStyle = .none
                return cell
            }
            
          
           
        }else {
            
            
            if dataModel!.video.count == 0{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "VideoBalankCell", for: indexPath) as! VideoBalankCell
                cell.selectionStyle = .none
                cell.zanwu.text = "暂无视频资料"
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerVideoCell", for: indexPath) as! WorkerVideoCell
                cell.selectionStyle = .none
                cell.model = dataModel
                return cell
            }
            
          
        }
    
    }
 
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
