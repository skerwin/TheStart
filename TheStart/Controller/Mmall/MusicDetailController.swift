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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "音乐详情"
        createRightNavItem()
        loadData()
        loadDataCoin()
        initHeadView()
        //initFooterView(bought: isBought)
        initTableView()
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
        
        if requestPath == HomeAPI.audioCollectPath{
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
        headView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 200)
        headerBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 200))
        headerBgView.backgroundColor = UIColor.clear
        headerBgView.addSubview(headView)
        
    }
    
    
    func initFooterView(bought:Bool){
        
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
                    lookInfoView.linkTv.text = dataModel?.link
                    lookInfoView.codeTv.text = dataModel?.code
                    
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
            commonBuy()
        }
     
       
     }
}

extension MusicDetailController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: notifyModelList.count ,isdisplay: true)
        
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
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
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
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
