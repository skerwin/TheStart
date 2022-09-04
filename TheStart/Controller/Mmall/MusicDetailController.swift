//
//  MusicDetailController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/05.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh
import Reachability
import SnapKit
import WMZDialog
import CoreMIDI

class MusicDetailController: BaseViewController,Requestable{
    
    var tableView:UITableView!
    
    var headView:MusicDetailHeader!
    
    var headerBgView:UIView!
    
    var footerView:ChatBtnView!
    var footerViewVip:BuyBtnView!
    
    var lookInfoView:AudioLinkInfoView!
    
    
    var footerBgView:UIView!
    
    var dateID = 0
    
    var dataModel = AudioModel()
    
    var rightBarButton:UIButton!
    
    var isCollect = 0
    
    var dataCoinList = [DictModel]()
    var myCoins = ""
    var isVipAuudio = false
    var isBought = false
    var isFromMine = false
    var bgview:UIView!
    
    //评论相关
    var selectedSection = 0
    var commentList = [CommentModel]()
    var dataCommentList = [Array<CommentModel>]()
    var parentCommentID = -1
    var parentComment = CommentModel()
    var commentSection = 0
    var addComment = false
    var delCommet = false
    var adjustFrame = false
    var reportType = 1
    var reportID = 0
    var reportReason = ""
    
    var rightBarButton2:UIButton!
 
    var delindex = IndexPath.init(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "音乐详情"
        createRightNavItem()
        loadData()
        loadDataCoin()
        initHeadView()
        //initFooterView(bought: isBought)
        initTableView()
        loadComment()
        // Do any additional setup after loading the view.
    }
    func loadData(){
        let requestParams = HomeAPI.audioDetailPathAndParams(id: dateID)
        getRequest(pathAndParams: requestParams,showHUD:false)
    }
    func loadDataCoin(){
        let requestParams = HomeAPI.MyCoinListPathAndParams()
        getRequest(pathAndParams: requestParams,showHUD:false)
        
    }
    
    func loadComment(){
       //print(page,limit)
       let requestCommentParams = HomeAPI.audioComentListPathAndParams(audioId: dateID,page: page,limit: limit)
       getRequest(pathAndParams: requestCommentParams,showHUD:false)
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
            rightBarButton2.frame = CGRect.init(x: 0, y: 8, width: 28, height:28)
            rightBarButton2.setImage(UIImage.init(named: "pl"), for: .normal)
            rightBarButton2.addTarget(self, action: #selector(rightNavBtnClick2(_:)), for: .touchUpInside)
            rightBarButton2.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            rightBarButton2.setTitleColor(.darkGray, for: .normal)
            bgview.addSubview(rightBarButton)
            bgview.addSubview(rightBarButton2)
        }
         self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: bgview)
        
    }
    
    
    @objc func rightNavBtnClick2(_ btn: UIButton){
        self.adjustFrame = true
        commentSection = 0
        parentCommentID = 0
        parentComment = CommentModel()
        commentBarVC.barView.inputTextView.becomeFirstResponder()
        
    }
    
    
    @objc func rightNavBtnClic(_ btn: UIButton){
 
        if dataModel?.uid == getUserId() && isFromMine{
            let noticeView = UIAlertController.init(title: "", message: "你确定要删除本条信息么", preferredStyle: .alert)
            noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { [self] (action) in
                let requestParams = HomeAPI.audioDelPathAndParams(id: dateID)
                postRequest(pathAndParams: requestParams,showHUD:false)
            }))
            noticeView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
                
            }))
            self.present(noticeView, animated: true, completion: nil)
        }else{
            if isCollect == 1{
                let requestParams = HomeAPI.delAudioCollectPathAndParams(id: dateID)
                postRequest(pathAndParams: requestParams,showHUD:false)
            }else{
                let requestParams = HomeAPI.audioCollectPathAndParams(id: dateID)
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
    }
    
    
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        
        
        if requestPath == HomeAPI.audioAddComentPath{
            showOnlyTextHUD(text: "评论成功")
            addComment = true
            addRefresh()
        }
        else if requestPath == HomeAPI.audioComentDelPath{
            showOnlyTextHUD(text: "删除成功")
            delCommet = true
            addRefresh()
        }
        
        else if requestPath.containsStr(find: HomeAPI.audioComentListPath){
            tableView.mj_header?.endRefreshing()
            tableView.mj_footer?.endRefreshing()
            let list:[CommentModel]  = getArrayFromJson(content: responseResult)
            commentList.append(contentsOf: list)
            for cModel in list {
                var tempList = [CommentModel]()
                tempList.append(cModel)
                if cModel.children_count != 0 {
                    for subModel in cModel.children {
                        tempList.append(subModel)
                    }
                }
                dataCommentList.append(tempList)
            }
            if list.count < 10 {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
            self.tableView.reloadData()
            if commentSection == 0 {
                if addComment || delCommet{
                    if limit != 10{
                        let indexPath = IndexPath.init(row: 0, section: 1)
                        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                        addComment = false
                        delCommet = false
                    }
                }
                
            }else{
                
                if delCommet {
                    if self.delindex.section != 0 {
                        //删回复
                        var row = 0
                        row = self.delindex.row - 1
                        let indexPath = IndexPath.init(row: row, section: commentSection)
                        tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
                    }else{
                        let row = 0
                        let indexPath = IndexPath.init(row: row, section: commentSection - 1)
                        tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
                    }
                    
                    
                }else if addComment{
                    let row = dataCommentList[commentSection - 1].count - 1
                    let indexPath = IndexPath.init(row: row, section: commentSection)
                    tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
                    addComment = false
                }
            }
        }else if requestPath == HomeAPI.reportPath{
             showOnlyTextHUD(text: "投诉成功，将尽快处理")
            
        }else if requestPath == HomeAPI.audioCollectPath{
            isCollect = responseResult["if_collect"].intValue
            changeCollectBtn()
            showOnlyTextHUD(text: "收藏成功")
        }else if requestPath == HomeAPI.delAudioCollectPath{
            isCollect = responseResult["if_collect"].intValue
            changeCollectBtn()
            showOnlyTextHUD(text: "取消收藏成功")
        }else if requestPath.containsStr(find: HomeAPI.MyCoinListPath){
            
            myCoins = responseResult["coins"].stringValue
            dataCoinList = getArrayFromJsonByArrayName(arrayName: "recharge_quota", content: responseResult)
            
        }else if requestPath == HomeAPI.buyAudioListPath{
            
            let token = responseResult["status"].stringValue
            if token == "-2"{
                let noticeView = UIAlertController.init(title: "", message: "您的星币不足无法购买，请充值后购买", preferredStyle: .alert)
                noticeView.addAction(UIAlertAction.init(title: "充值", style: .default, handler: { [self] (action) in
                    self.chooseCoin()
                }))
                
                noticeView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
                    
                }))
                self.present(noticeView, animated: true, completion: nil)
            }else{
                buySuccess()
            }
 
        }else if requestPath == HomeAPI.buyAudioFreeListPath{
            let is_vip = responseResult["result"]["is_vip"].boolValue
            if is_vip{
                buySuccess()
            }else{
                let noticeView = UIAlertController.init(title: "", message: "您不是会员，请¥98元充值会员", preferredStyle: .alert)
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
        }else if requestPath == HomeAPI.audioDelPath{
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
            dataModel = Mapper<AudioModel>().map(JSONObject: responseResult.rawValue)
            headView.configModel(model: dataModel!)
            self.tableView.reloadData()
            isCollect = dataModel!.userCollect
            changeCollectBtn()
            if dataModel?.vip_free == 0{
                isVipAuudio = false
            }else{
                isVipAuudio = true
            }
            if dataModel?.if_order == 0{
                isBought = false
            }else{
                isBought = true
            }
           
            initFooterView(bought: isBought)
 
            if checkMarketVer(){
                tableView.tableFooterView = footerBgView
            }else{
                if dataModel!.uid == getUserId(){
                    tableView.tableFooterView = UIView()
                }else{
                    tableView.tableFooterView = footerBgView
                }
            }
         }
      }
    
    lazy var commentBarVC: CommentBarController = { [unowned self] in
        let barVC = CommentBarController()
        self.view.addSubview(barVC.view)
        barVC.view.snp.makeConstraints { (make) in
            make.left.right.width.equalTo(self.view)
            if iphoneXOrIphoneX11 {
                //make.bottom.equalTo(self.view.snp.bottom).offset(-distance)
                make.bottom.equalTo(self.view.snp.bottom).offset(ZChatBarOriginHeight)
            }else{
                make.bottom.equalTo(self.view.snp.bottom).offset(ZChatBarOriginHeight)
            }
            make.height.equalTo(ZChatBarOriginHeight)
        }
        barVC.delegate = self
        return barVC
    }()
    
    func buySuccess(){
        isBought = true
        if isVipAuudio{
            initFooterView(bought: isBought)
            tableView.tableFooterView = footerBgView
        }
        footerView.chatBtn.setTitle("查看网盘链接", for: .normal)
        let noticeView = UIAlertController.init(title: "", message: "购买成功！", preferredStyle: .alert)
        noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
            
        }))
        self.present(noticeView, animated: true, completion: nil)
    }
    
    func initHeadView(){
        headView = Bundle.main.loadNibNamed("MusicDetailHeader", owner: nil, options: nil)!.first as? MusicDetailHeader
        headView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 267)
        headerBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 267))
        headerBgView.backgroundColor = UIColor.clear
        headView.parentNavigationController = self.navigationController
        headerBgView.addSubview(headView)
        
    }
    
    
    func initFooterView(bought:Bool){
         
//        if getAcctount() == "18153684982"{
//            footerView = Bundle.main.loadNibNamed("ChatBtnView", owner: nil, options: nil)!.first as? ChatBtnView
//            footerView.chatBtn.setTitle("查看网盘链接", for: .normal)
//            footerView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 85)
//            footerView.delegate = self
//
//            footerBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 85))
//            footerBgView.addSubview(footerView)
//            footerBgView.backgroundColor = UIColor.clear
//        }else{
            if checkMarketVer(){
                footerView = Bundle.main.loadNibNamed("ChatBtnView", owner: nil, options: nil)!.first as? ChatBtnView
                footerView.chatBtn.setTitle("查看网盘链接", for: .normal)
                footerView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 85)
                footerView.delegate = self
               
                footerBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 85))
                footerBgView.addSubview(footerView)
                footerBgView.backgroundColor = UIColor.clear
                
                
                
            }else{
                if isBought{
                    footerView = Bundle.main.loadNibNamed("ChatBtnView", owner: nil, options: nil)!.first as? ChatBtnView
                    footerView.chatBtn.setTitle("查看网盘链接", for: .normal)
                    footerView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 85)
                    footerView.delegate = self
                   
                    footerBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 85))
                    footerBgView.addSubview(footerView)
                    footerBgView.backgroundColor = UIColor.clear
                    
                }else{
                    if isVipAuudio{
                        
                        footerViewVip = Bundle.main.loadNibNamed("BuyBtnView", owner: nil, options: nil)!.first as? BuyBtnView
                        footerViewVip.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 85)
                        footerViewVip.delegate = self
                        footerBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 85))
                        footerBgView.backgroundColor = UIColor.clear
                        footerBgView.addSubview(footerViewVip)
         
                    }else{
                        footerView = Bundle.main.loadNibNamed("ChatBtnView", owner: nil, options: nil)!.first as? ChatBtnView
                        footerView.chatBtn.setTitle("立即购买", for: .normal)
                        footerView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 85)
                        footerView.delegate = self
                        footerBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 85))
                        footerBgView.backgroundColor = UIColor.clear
                        footerBgView.addSubview(footerView)
                    }
                }
            }
       // }
       
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
        tableView.registerNibWithTableViewCellName(name: reCommentCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: CommentCell.nameOfClass)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
        tableView.mj_header = addressHeadRefresh
        
        let footerRefresh = GmmMJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(pullRefreshList))
        tableView.mj_footer = footerRefresh
        
        self.tableView.tableHeaderView = headerBgView
        tableView.tableFooterView = footerBgView
        view.addSubview(tableView)
        
    }
    func chooseCoin(){
        
        var coinStr = [String]()
        
        
        for index in 0..<dataCoinList.count {
            coinStr.append(dataCoinList[index].give_money + "星币")
        }
        
        let dialog = Dialog()
        dialog
            .wTypeSet()(DialogTypeSelect)
            .wEventFinishSet()({(anyID:Any?,path:IndexPath?,type:DialogType) in
                //print("选择",anyID as Any);
            })
            .wCustomCellSet()(
                
                { [self]
                    (indexPath:IndexPath?,tableView:UITableView?,model:Any?,isSelected:Bool) -> UITableViewCell?  in
                    var cell = tableView!.dequeueReusableCell(withIdentifier: "Starcell")
                    if cell == nil {
                        cell = UITableViewCell(style: .value1, reuseIdentifier: "Starcell")
                    }
                    cell?.textLabel?.textColor = isSelected ? ZYJColor.coinColor :UIColor.black
                    cell?.textLabel?.text = (model as! String)
                    cell?.detailTextLabel?.text = "¥" + " " +  dataCoinList[indexPath!.row].price
                    cell?.selectionStyle = .none
                    
                    return cell
                }
            )
            .wTitleSet()("抱歉，您没有足够星币购买")
            .wTitleColorSet()(ZYJColor.coinColor)
            .wTitleFontSet()(16.0)
           //.wMessageSet()("请充值")
            .wListDefaultValueSet()([2])
            .wDataSet()(coinStr)
            .wSeparatorStyleSet()(.singleLine)
            .wOKTitleSet()("去充值")
            .wAddBottomViewSet()(true)
            .wEventCancelFinishSet()(
                {(anyID:Any?,otherData:Any?) in
                    //print("选择quxai",anyID as Any);
                }
            )
            .wEventOKFinishSet()(
                {(anyID:Any?,otherData:Any?) in
                     //let arr1 = anyID as! Array<String>
                     if otherData != nil{
                        let arr = otherData as! Array<IndexPath>
                        let priceStr = self.dataCoinList[arr.first!.row].price
                        let controller = UIStoryboard.getCashierDeskController()
                        controller.paytype = .ChargeStarCoin
                        controller.priceStr = priceStr
                        self.present(controller, animated: true)
                    }
                      
                
 
                 }
            )
        _ = dialog.wStart()
    }
    
    func lookInfo(){
        let dialog = Dialog()
        dialog
            .wTypeSet()(DialogTypeMyView)
            .wMyDiaLogViewSet()(
                {
                    [self]
                    (mainView:UIView?) -> UIView?  in
                    lookInfoView = Bundle.main.loadNibNamed("AudioLinkInfoView", owner: nil, options: nil)!.first as? AudioLinkInfoView
                    lookInfoView.frame = CGRect.init(x: 0, y: 0, width: screenWidth - 50, height: 200)
                    
                    if checkMarketVer(){
                        lookInfoView.linkTv.text = "链接:https://pan.baidu.com/s/1U-GBDlYQc49YLHzKZz5mpg  密码:7lta"
                        lookInfoView.codeTv.text = "7lta"
                    }else{
                        lookInfoView.linkTv.text = dataModel?.link
                        lookInfoView.codeTv.text = dataModel?.code
                    }
                    
                    let lookInfoBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth - 50, height: 200))
                    lookInfoBgView.backgroundColor = UIColor.clear
                    lookInfoBgView.addSubview(lookInfoView)
                    
                    mainView?.addSubview(lookInfoBgView)
                    mainView?.layer.masksToBounds = true;
                    mainView?.layer.cornerRadius = 10;
                    return lookInfoBgView
                }
            )
        
        _ = dialog.wStart()
    }
    
    
    func commonBuy(){
        if isBought{
            lookInfo()
        }else{
            let coinNum = stringToFloat(test: dataModel!.price)
            let coinmy = stringToFloat(test: myCoins)
            
            if coinmy < coinNum{
                self.chooseCoin()
            }else{
                let noticeView = UIAlertController.init(title: "", message: "您确定花费" + dataModel!.price + "星币购买此音乐么", preferredStyle: .alert)
                noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { [self] (action) in
                    let requestParams = HomeAPI.buyAudioListPathAndParams(id: self.dateID)
                    self.postRequest(pathAndParams: requestParams,showHUD:false)
                }))
                noticeView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
                    
                }))
                self.present(noticeView, animated: true, completion: nil)
            }
        }
    }
    
    
    @objc func refreshList() {
        self.tableView.mj_footer?.resetNoMoreData()
        commentList.removeAll()
        dataCommentList.removeAll()
        commentSection = 0
        parentCommentID = 0
        parentComment = CommentModel()
        
        limit = 10
        page = 1
        self.loadComment()
    }
    
    @objc func pullRefreshList() {
        if limit == 10{
            page = page + 1
        }else{
            page = limit/10 + 1
        }
        limit = 10
        self.loadComment()
    }
    
    func addRefresh(){
        self.tableView.mj_footer?.resetNoMoreData()
        commentList.removeAll()
        dataCommentList.removeAll()
        if page != 1{
            limit = page * 10
        }
        page = 1
        self.loadComment()
        
    }
    
    func savemessage(text:String){
        
        if (text.hasEmoji()) {
            showOnlyTextHUD(text: "不支持发送表情")
            return
            // message = message!.disable_emoji(text: message! as NSString)
        }
        
        if (text.containsEmoji()) {
            showOnlyTextHUD(text: "不支持发送表情")
            return
            // message = message!.disable_emoji(text: message! as NSString)
        }
        if text.isEmptyStr()  {
            showOnlyTextHUD(text: "评论内容不能为空")
            return
        }
        
        var cModel = CommentModel()
        cModel?.audio_id = self.dateID
        cModel?.comment = text
        if parentCommentID != -1{
            cModel?.rid = parentCommentID
            cModel?.uid = parentComment!.uid
        }else{
            cModel?.rid = 0
        }
        
        
        let requestParams = HomeAPI.audioAddComentPathAndParams(model: cModel!, isTopComment: true)
        postRequest(pathAndParams: requestParams,showHUD:false)
    }
    
    
    func commentDelete(delrid:Int){
        let requestParams = HomeAPI.audioComentDelPathAndParams(rid: delrid)
        postRequest(pathAndParams: requestParams,showHUD:false)
        
    }
    
    
    func reportContent(){
        delay(second: 1) { [self] in
            showOnlyTextHUD(text: "投诉成功，将尽快处理")
        }
        
       // let requestParams = HomeAPI.reportPathAndParams(articleId: reportID, type: reportType, reason: reportReason, remark: "我要举报")
       // postRequest(pathAndParams: requestParams,showHUD:false)
    }
    
    
    // MARK: 重置barView的位置
    func resetChatBarFrame() {
        
        commentBarVC.resetKeyboard()
        UIApplication.shared.keyWindow?.endEditing(true)
        commentBarVC.view.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(ZChatBarOriginHeight)
        }
        UIView.animate(withDuration: kKeyboardChangeFrameTime, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func didRecommetnClick() {
        
        let acVC = ActionSheetViewController(cellTitleList: ["垃圾广告", "不良信息","骚扰信息"])!
        acVC.valueBlock = { index in
            if index == 0{
                self.reportReason = "垃圾广告"
            }else if index == 0{
                self.reportReason = "低俗色情"
            }else{
                self.reportReason = "骚扰信息"
            }
            
        }
        acVC.confirmBlock = {
            if self.reportReason == ""{
                self.showOnlyTextHUD(text: "请选择投诉原因")
            }
            self.reportContent()
        }
        acVC.cellTitleColor = UIColor.darkGray
        acVC.cellTitleFont = 16
        acVC.titleString = "选择投诉原因"
        present(acVC, animated: false, completion:  nil)
        
    }
   
}
extension MusicDetailController:BuyBtnViewDelegate {
    func buyBtnAction(){
         commonBuy()
     }
    
    func vipBtnAction(){
        
        //print("656667")
        if checkVip() {
        //if 1 == 0 {
            let noticeView = UIAlertController.init(title: "", message: "您是Vip会员可免费购买此音乐", preferredStyle: .alert)
            noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { [self] (action) in
                let requestParams = HomeAPI.buyAudioFreeListPathAndParams(id: dateID)
                postRequest(pathAndParams: requestParams,showHUD:false)
            }))
            noticeView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in

            }))
            self.present(noticeView, animated: true, completion: nil)
        }else{
            let noticeView = UIAlertController.init(title: "", message: "您不是会员，请¥98元充值会员", preferredStyle: .alert)
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
    
}
extension MusicDetailController:ChatBtnViewDelegate {
    func sumbitAction() {
         if checkMarketVer(){
            lookInfo()
        }else{
//            if getAcctount() == "18153684982"{
//                lookInfo()
//            }else{
                commonBuy()
//            }
           
        }
     
       
     }
}

extension MusicDetailController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataCommentList.count + 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: notifyModelList.count ,isdisplay: true)
        
        if section == 0{
            if dataModel?.name == ""{
                return 0
            }
            if dataModel?.audio_path == "" && dataModel?.images.count == 0{
                return 1
            }
            
            if dataModel?.audio_path == "" || dataModel?.images.count == 0{
                return 2
            }
            
            return 3
        }else{
            return dataCommentList[section - 1].count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
 
            let hv = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 0.5))
            hv.backgroundColor = ZYJColor.main
            return hv
     }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
            return 0.5
     }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        
        if section == 0{
            if dataCommentList.count > 0{
                let sectionView = Bundle.main.loadNibNamed("TipOffCommentHeaderView", owner: nil, options: nil)!.first as! TipOffCommentHeaderView
                sectionView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 25)
                let bgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 25))
                bgView.addSubview(sectionView)
                return bgView
            }else{
                let hv = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 0.5))
                hv.backgroundColor = ZYJColor.main
                return hv
            }
           
        }else{
            let hv = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 0.5))
            hv.backgroundColor = ZYJColor.main
            return hv
         }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        if section == 0{
            if dataCommentList.count > 0{
                return 25
            }else{
                return 0.5
            }
            
        }else{
            return 0.5
        }
 
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let section = indexPath.section
        let row = indexPath.row
        if indexPath.section == 0{
            if indexPath.row == 0{
                 let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerInfoCell", for: indexPath) as! WorkerInfoCell
                cell.selectionStyle = .none
                cell.configAudioCell(model: dataModel!)
                return cell
                
            }else if indexPath.row == 1{
                if dataModel?.images.count == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerVideoCell", for: indexPath) as! WorkerVideoCell
                    cell.selectionStyle = .none
                    cell.configAudioCell(model: dataModel!)
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerImgCell", for: indexPath) as! WorkerImgCell
                    cell.selectionStyle = .none
                    cell.configAudioCell(model: dataModel!)
                    return cell
                }
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerVideoCell", for: indexPath) as! WorkerVideoCell
                cell.selectionStyle = .none
                cell.configAudioCell(model: dataModel!)
                return cell
            }
        }else{
            let modelList = dataCommentList[section - 1]
            if (modelList[row].rid) == 0{
                let section = indexPath.section
                let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.nameOfClass) as! CommentCell
                cell.selectionStyle = .none
                cell.parentNavigationController = self.navigationController
                cell.sectoin = section
                cell.delegeta = self
                cell.model = modelList[indexPath.row]
                let childArr = modelList[row].children
                if childArr.count != 0{
                    cell.lineView.isHidden = true
                }else{
                    cell.lineView.isHidden = false
                }
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "reCommentCell", for: indexPath) as! reCommentCell
                cell.selectionStyle = .none
                cell.parentNavigationController = self.navigationController
                cell.delegeta = self
                cell.indexpath = indexPath
                cell.model = modelList[indexPath.row]
                return cell
            }
        }
 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
     }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if adjustFrame{
            resetChatBarFrame()
        }
     }
}
extension MusicDetailController:ReCommentCellDelegate{
    //回复
    func reComplainActiion(cmodel:CommentModel,onView:UIButton,index:IndexPath){
        
        commentSection = index.section
        let modelList = dataCommentList[commentSection - 1]
        let tempm = modelList[index.row]
        parentCommentID = tempm.rid
        parentComment = tempm
        self.adjustFrame = true
        commentBarVC.barView.inputTextView.becomeFirstResponder()
    }
    //举报和删除
    func redelActiion(cmodel:CommentModel,onView:UIButton,index:IndexPath){
        
        
        if (cmodel.uid == getUserId()){
            commentSection = index.section
            let modelList = dataCommentList[commentSection - 1]
            let tempm = modelList[index.row]
            parentCommentID = tempm.rid
            parentComment = tempm
            
            delindex = index
            self.adjustFrame = true
            
            let noticeView = UIAlertController.init(title: "", message: "您确定要删除此条评论么", preferredStyle: .alert)
            noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { [self] (action) in
                self.commentDelete(delrid: cmodel.id)
            }))
            noticeView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
                
            }))
            self.present(noticeView, animated: true, completion: nil)
        }else{
            commentSection = index.section
            reportType = 2
            let modelList = dataCommentList[commentSection - 1]
            let tempm = modelList[index.row]
            reportID = tempm.id
            self.adjustFrame = true
            didRecommetnClick()
        }
        
    }
    
    
    
}
extension MusicDetailController:CommentCellDelegate{
    
    //举报和删除
    func complainActiion(cmodel: CommentModel, section: Int) {
        
        if (cmodel.uid == getUserId()){
            commentSection = section
            parentCommentID = cmodel.id
            parentComment = cmodel
            self.adjustFrame = true
            
            let noticeView = UIAlertController.init(title: "", message: "您确定要删除此条评论么", preferredStyle: .alert)
            noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { [self] (action) in
                self.commentDelete(delrid: cmodel.id)
            }))
            noticeView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
                
            }))
            self.present(noticeView, animated: true, completion: nil)
        }else{
            reportType = 2
            reportID = commentList[section - 1].id
            self.adjustFrame = true
            didRecommetnClick()
        }
    }
    //回复
    func commentACtion(cmodel: CommentModel, section: Int) {
        commentSection = section
        parentCommentID = cmodel.id
        parentComment = cmodel
        self.adjustFrame = true
        commentBarVC.barView.inputTextView.becomeFirstResponder()
    }
}

extension MusicDetailController:CommentBarControllerDelegate{
    func commentBarGood() {
        
    }
    func sendMessage(messge: String) {
        self.savemessage(text: messge)
        adjustFrame = true
        resetChatBarFrame()
        adjustFrame = false
    }
    
    
    func commentBarUpdateHeight(height: CGFloat) {
        commentBarVC.view.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
    }
    func commentBarVC(commentBarVC: CommentBarController, didChageChatBoxBottomDistance distance: CGFloat) {
        
        commentBarVC.view.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(-distance)
        }
        UIView.animate(withDuration: kKeyboardChangeFrameTime, animations: {
            self.view.layoutIfNeeded()
        })
        self.view.layoutIfNeeded()
        
        //self.tableView.scrollToRow(at: IndexPath(row: 0, section:selectedSection), at: .bottom, animated: true)
    }
    
}
