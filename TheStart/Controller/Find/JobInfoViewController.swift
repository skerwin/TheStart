//
//  JobInfoViewController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/19.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh
import Reachability
import SnapKit
import WMZDialog
class JobInfoViewController: BaseViewController,Requestable{

    var tableView:UITableView!
    
    var headView:JobBaseInfo!
        
    var headerBgView:UIView!
    
    var footerView:ChatBtnView!
    
    var footerBgView:UIView!
    
    var dateID = 0
    
    var dataModel = JobModel()
    
    var rightBarButton:UIButton!
    var rightBarButton2:UIButton!
    
    var isCollect = 0
    
    var bgview:UIView!
    
    var isFromMine = false
    
    var linkUrl = ""
    
    
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
        
        bgview = UIView.init()
        
        if isFromMine{
            rightBarButton = UIButton.init()
            rightBarButton.frame = CGRect.init(x: 0, y: 0, width: 28, height: 28)
            bgview.frame = CGRect.init(x: 0, y: 0, width: 58, height: 28)
            rightBarButton.addTarget(self, action: #selector(rightNavBtnClic(_:)), for: .touchUpInside)
            rightBarButton.setBackgroundImage(UIImage.init(named: "shoucangs"), for: .normal)
            bgview.addSubview(rightBarButton)
        }else{
             bgview.frame = CGRect.init(x: 0, y: 0, width: 80, height: 44)
            
            rightBarButton = UIButton.init()
            rightBarButton.frame = CGRect.init(x: 46, y: 8, width: 28, height: 28)
            rightBarButton.addTarget(self, action: #selector(rightNavBtnClic(_:)), for: .touchUpInside)
            rightBarButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            rightBarButton.setTitleColor(.darkGray, for: .normal)
            rightBarButton.setBackgroundImage(UIImage.init(named: "shoucangs"), for: .normal)
 
            rightBarButton2 = UIButton.init()
            rightBarButton2.frame = CGRect.init(x: 0, y: 2, width: 40, height:40)
            rightBarButton2.setImage(UIImage.init(named: "share"), for: .normal)
            rightBarButton2.addTarget(self, action: #selector(rightNavBtnClick2(_:)), for: .touchUpInside)
            rightBarButton2.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            rightBarButton2.setTitleColor(.darkGray, for: .normal)
            bgview.addSubview(rightBarButton)
            bgview.addSubview(rightBarButton2)
        }
         self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: bgview)
     }
    
    @objc func rightNavBtnClick2(_ btn: UIButton){
        
        self.shareView.show(withContentType: JSHAREMediaType(rawValue: 3)!)
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
        message.title = "测试分享"
        message.text = "这是分享内容"
        message.platform = platform
        message.mediaType = .link;
        message.url = dataModel?.link_url
        let imageLogo = UIImage.init(named: "logo")
       
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
    
    func changeCollectBtn(){
        
        if dataModel?.uid == getUserId() && isFromMine{
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
        }
        else if requestPath == HomeAPI.userCallPath{
            callPhone()
        }else if requestPath == HomeAPI.userImPathPath{
            gotoMessage()
        }else if requestPath == HomeAPI.workDelPath{
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
            if (dataModel?.link_url == ""){
                dataModel?.link_url = self.linkUrl
            }
            headView.configModel(model: dataModel!)
            isCollect = dataModel!.is_collect
            changeCollectBtn()
        }
        
        // bottoomView.configModel(model: dataModel!)
         self.tableView.reloadData()
    }
    func gotoMessage(){
        let controller = UIStoryboard.getMessageController()
        controller.toID = dataModel!.uid
        controller.nameTitle = dataModel!.nickname
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func callPhone(){
        let dialog = Dialog()
        dialog
            .wShowAnimationSet()(AninatonZoomIn)
            .wHideAnimationSet()(AninatonZoomOut)
            .wEventCancelFinishSet()(
                {(anyID:Any?,otherData:Any?) in
                    UIPasteboard.general.string = self.dataModel!.mobile

                }
            )
            .wEventOKFinishSet()(
                { [self](anyID:Any?,otherData:Any?) in
                    let urlstr = "telprompt://" + self.dataModel!.mobile
                    if let url = URL.init(string: urlstr){
                         if #available(iOS 10, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                         }
                      }
                }
            )
            .wTitleSet()("获取成功")
            .wMessageSet()("对方的联系方式为(微信同号):" + self.dataModel!.mobile )
            .wOKTitleSet()("拨打电话")
            .wCancelTitleSet()("复制号码")
            .wMessageColorSet()(UIColor.black)
            .wTitleColorSet()(UIColor.black)
            .wOKColorSet()(UIColor.systemBlue)
            .wCancelColorSet()(UIColor.darkGray)
            .wTitleFontSet()(17)
            .wMessageFontSet()(16)
            .wTypeSet()(DialogTypeNornal)
          
        _ = dialog.wStart()
        
        
    }
    
    func initHeadView(){
        headView = Bundle.main.loadNibNamed("JobBaseInfo", owner: nil, options: nil)!.first as? JobBaseInfo
        headView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 188)
        headView.delegate = self
        headView.parentNavigationController = self.navigationController
        headerBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 188))
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
//        let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
//        tableView.mj_header = addressHeadRefresh
//         let footerRefresh = GmmMJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(pullRefreshList))
//        tableView.mj_footer = footerRefresh
        
        view.addSubview(tableView)
        
    }
 
}
extension JobInfoViewController:ChatBtnViewDelegate {
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
            
            let pathAndParams = HomeAPI.userImPathPathAndParams(type: 2,to_uid: dataModel!.uid)
            postRequest(pathAndParams: pathAndParams,showHUD: false)
            
        }
   }
 
}
extension JobInfoViewController:JobBaseInfoDelegate {
    func JobCommunicateAction(){
        
        if checkMarketVer(){
            
        }else{
            if dataModel!.uid == getUserId(){
                showOnlyTextHUD(text: "不能给自己拨打电话")
                return
            }
        }
        
        
        
      
      
        let noticeView = UIAlertController.init(title: "温馨提示", message: "会员无限，非会员每天仅可获取三次对方联系方式，您确定获取吗？", preferredStyle: .alert)
        
        noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { [self] (action) in
             let pathAndParams = HomeAPI.userCallPathAndParams(type: 2)
            postRequest(pathAndParams: pathAndParams,showHUD: false)
 
        }))
        
        noticeView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
            
        }))
        self.present(noticeView, animated: true, completion: nil)
    }
    
    
}
extension JobInfoViewController:UITableViewDataSource,UITableViewDelegate {
    
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
            cell.configCell(model: self.dataModel!, isjob: true)
            return cell
        }else if indexPath.row == 1{
            
            if dataModel!.images.count == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "VideoBalankCell", for: indexPath) as! VideoBalankCell
                cell.zanwu.text = "暂无图片资料"
                cell.selectionStyle = .none
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
