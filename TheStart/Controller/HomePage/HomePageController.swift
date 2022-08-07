//
//  HomePageController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/14.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh
import SDCycleScrollView
import WMZDialog
 
class HomePageController: BaseViewController,Requestable {

    
    var tableView:UITableView!
    
    var dataLWokerList = [JobModel]()
    var dataLJobList = [JobModel]()
    var bannerList = [ImageModel]()
    
    var advertisementView:SDCycleScrollView!
    var bannerView:UIView!
    
    let topAdvertisementViewHeight = screenWidth * 0.40
    
    var callMobile = ""
    
    
    var pubJobBtn:UIButton!
    var pubWorkerBtn:UIButton!
   
    var pubJobLabel:UILabel!
    var pubWorkerLabel:UILabel!
    var pubBtn:UIButton!
    var pubSubHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WebSocketManager.instance.openSocket()
        
       // logoutAccount(account: "")
        initTableView()
        initPubBtn()
        self.view.backgroundColor = ZYJColor.main
        loadData()
       
        loadDictData()
        self.title = "首页"
        // Do any additional setup after loading the view.
    }
    func loadData(){
       
        
        let requestParamsP3 = HomeAPI.openMarketPathAndParam()
        postRequest(pathAndParams: requestParamsP3,showHUD: false)
        
        
        let workParams = HomeAPI.homePathAndParams()
        getRequest(pathAndParams: workParams,showHUD: false)
    }
    
    func loadDictData(){
        
        let workParams = HomeAPI.workCategoryPathAndParams()
        getRequest(pathAndParams: workParams,showHUD: false)
        
        let salaryParams = HomeAPI.salaryPathAndParams()
        getRequest(pathAndParams: salaryParams,showHUD: false)
        
        let requestParamsP3 = HomeAPI.openMarketPathAndParam()
        postRequest(pathAndParams: requestParamsP3,showHUD: false)
        
    }
    
    
    func initPubBtn(){
       pubBtn = UIButton.init()
       pubBtn.frame = CGRect.init(x: 5, y: 5, width: 56, height: 56)
       pubBtn.addTarget(self, action: #selector(pubBtnClick(_:)), for: .touchUpInside)
       pubBtn.setBackgroundImage(UIImage.init(named: "release"), for: .normal)
       
       let bgview = UIView.init()
       bgview.frame = CGRect.init(x: (screenWidth - 66)/2, y: screenHeight - navigationHeaderAndStatusbarHeight - 66, width: 56, height: 56)
       bgview.addSubview(pubBtn)
       self.view.addSubview(bgview)

       let bgAddview = UIView.init()
       bgAddview.frame = CGRect.init(x: (screenWidth - 220)/2, y: screenHeight - navigationHeaderAndStatusbarHeight - 140 , width: 220, height: 80)
       //bgAddview.backgroundColor = UIColor.yellow
       self.view.addSubview(bgAddview)
       
       pubWorkerBtn = UIButton.init()
       pubWorkerBtn.frame = CGRect.init(x: 25, y: 0, width: 60, height: 60)
       pubWorkerBtn.addTarget(self, action: #selector(pubWorkerClick(_:)), for: .touchUpInside)
       pubWorkerBtn.setImage(UIImage.init(named: "find_place"), for: .normal)
        
       pubWorkerLabel = UILabel.init(frame: CGRect.init(x: 0, y: 60, width: 110, height: 20))
       pubWorkerLabel.text = "我要找场"
       pubWorkerLabel.textColor = colorWithHexString(hex: "60BAF0")
        pubWorkerLabel.font = UIFont.boldSystemFont(ofSize: 15)
       pubWorkerLabel.textAlignment = .center
    
       
       pubJobBtn = UIButton.init()
       pubJobBtn.frame = CGRect.init(x: 135, y: 0, width: 60, height: 60)
       pubJobBtn.addTarget(self, action: #selector(pubJobBtnClick(_:)), for: .touchUpInside)
       pubJobBtn.setImage(UIImage.init(named: "find_person"), for: .normal)

       pubJobLabel = UILabel.init(frame: CGRect.init(x: 110, y: 60, width: 110, height: 20))
       pubJobLabel.text = "我要找人"
       pubJobLabel.textAlignment = .center
       pubJobLabel.textColor = colorWithHexString(hex: "F19E44")
       pubJobLabel.font = UIFont.boldSystemFont(ofSize: 15)
  
       addjustPubBtn()
       bgAddview.addSubview(pubWorkerBtn)
       bgAddview.addSubview(pubJobBtn)
       bgAddview.addSubview(pubWorkerLabel)
       bgAddview.addSubview(pubJobLabel)

   }
    
    func addjustPubBtn(){
        
        pubWorkerBtn.isHidden = pubSubHidden
        pubJobBtn.isHidden = pubSubHidden
        pubWorkerLabel.isHidden = pubSubHidden
        pubJobLabel.isHidden = pubSubHidden
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        pubSubHidden = true
        addjustPubBtn()
    }
    
    @objc func pubWorkerClick(_ btn: UIButton){
 
            let controller = WorkerPubViewController()
            controller.pubType = 2
            self.navigationController?.pushViewController(controller, animated: true)
           
   
    }
    @objc func pubJobBtnClick(_ btn: UIButton){
        let controller = WorkerPubViewController()
        controller.pubType = 1
        self.navigationController?.pushViewController(controller, animated: true)
     }
    
    @objc func pubBtnClick(_ btn: UIButton){
    
        if pubSubHidden {
            pubSubHidden = false
        }else{
            pubSubHidden = true
        }
         addjustPubBtn()
   
    }
    
    
    
    func UpdateAdvertisementView(imageArr:[ImageModel]) {
        
        let prarModel = imageArr
        var imageArrTemp = [String]()
        if imageArr.count == 0{
            tableView.tableHeaderView = getAdvertisementView(imageArr: prarModel)
        }else{
            for model in imageArr {
                imageArrTemp.append(model.pic)
            }
             if advertisementView == nil {
                 advertisementView = SDCycleScrollView.init(frame: CGRect.init(x: 5, y: 0 , width: screenWidth - 10, height: topAdvertisementViewHeight), imageURLStringsGroup:imageArrTemp)
                advertisementView.pageControlAliment = SDCycleScrollViewPageContolAliment(rawValue: 1)
                advertisementView.pageControlStyle = SDCycleScrollViewPageContolStyle(rawValue: 1)
                //pageControlBottomOffset
                advertisementView.delegate = self
                advertisementView.backgroundColor = ZYJColor.main
                advertisementView.layer.cornerRadius = 5;
                advertisementView.layer.masksToBounds = true;
                bannerView.addSubview(advertisementView)
                tableView.tableHeaderView = bannerView
             }else{
                 advertisementView.imageURLStringsGroup = imageArrTemp
             }
        }
        
    }
    
    func getAdvertisementView(imageArr:[ImageModel]) -> UIView {
        
        bannerView = UIView.init(frame:  CGRect.init(x: 0, y:0 , width: screenWidth, height: topAdvertisementViewHeight))
        bannerView.backgroundColor = ZYJColor.main
 
        var imageArrTemp = [String]()
        if imageArr.count == 0{
            return UIView()
        }else{
            for model in imageArr {
                imageArrTemp.append(model.pic)
            }
        }
        
        SDCycleScrollView.clearImagesCache()
        advertisementView = SDCycleScrollView.init(frame: CGRect.init(x: 5, y: 0 , width: screenWidth - 10, height: topAdvertisementViewHeight), imageURLStringsGroup:imageArrTemp)
 
        if advertisementView == nil{
            return UIView() as! SDCycleScrollView
       
        }
        
        advertisementView.pageControlAliment = SDCycleScrollViewPageContolAliment(rawValue: 1)
        advertisementView.pageControlStyle = SDCycleScrollViewPageContolStyle(rawValue: 1)
        //pageControlBottomOffset
        advertisementView.delegate = self
        advertisementView.backgroundColor = ZYJColor.main
        advertisementView.layer.cornerRadius = 5;
        advertisementView.layer.masksToBounds = true;
 
        bannerView.addSubview(advertisementView)
        return bannerView
    }
    
    func initTableView(){
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = ZYJColor.main
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 240;
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.registerNibWithTableViewCellName(name: GuideCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: HomeSubscribeCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: JobViewCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: HomeJobCell.nameOfClass)
        tableView.tableHeaderView = getAdvertisementView(imageArr: bannerList)
        
        
        let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
        tableView.mj_header = addressHeadRefresh

//        let footerRefresh = GmmMJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(pullRefreshList))
//        tableView.mj_footer = footerRefresh
        
        view.addSubview(tableView)
        tableView.tableFooterView = UIView()
      
    }
 
    @objc func pullRefreshList() {
        page = page + 1
        self.loadData()
    }
    
    @objc func refreshList() {
        self.tableView.mj_footer?.resetNoMoreData()
        dataLJobList.removeAll()
        dataLWokerList.removeAll()
        page = 1
        self.loadData()
    }
    
    
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
            tableView.mj_header?.endRefreshing()
            tableView.mj_footer?.endRefreshing()
            self.tableView.mj_footer?.endRefreshingWithNoMoreData()
        if requestPath == HomeAPI.userCallPath{
            let noticeView = UIAlertController.init(title: "", message: "非会员每天限拨打3次电话，请¥98元充值会员,无限次拨打", preferredStyle: .alert)
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
        tableView.mj_header?.endRefreshing()
        tableView.mj_footer?.endRefreshing()
        if requestPath.containsStr(find: HomeAPI.homePath){
            dataLJobList = getArrayFromJsonByArrayName(arrayName: "list_zr", content:  responseResult)
            dataLWokerList = getArrayFromJsonByArrayName(arrayName: "list_zc", content:  responseResult)
            bannerList = getArrayFromJsonByArrayName(arrayName: "banner", content:  responseResult)
            UpdateAdvertisementView(imageArr: bannerList)
            self.tableView.reloadData()
        }else if requestPath == HomeAPI.userCallPath{
            callPhone()
        }else if requestPath == HomeAPI.openMarketPath{
            let isgoods = responseResult["if_goods"].intValue
            if isgoods == 1{
                setStringValueForKey(value: "1", key: Constants.isMarketVer)
            }else{
                setStringValueForKey(value: "0", key: Constants.isMarketVer)
            }
 
            let ifExamine = responseResult["if_examine"].intValue
            if ifExamine == 1{
                setStringValueForKey(value: "1", key: Constants.ifExamine)
            }else{
                setStringValueForKey(value: "0", key: Constants.ifExamine)
            }
            
            let IOS_code = responseResult["ios_code"].stringValue
            let IOS_force = responseResult["ios_force"].intValue
            if SysMajorVersion != IOS_code{  //这里判断一下大小给审核官
                if IOS_force == 1{
                    let noticeView = UIAlertController.init(title: "版本有更新", message: "为了您得到更好用的户体验请您到应用商店下载最新版APP", preferredStyle: .alert)
                    noticeView.addAction(UIAlertAction.init(title: "去更新", style: .default, handler: { (action) in
                        let url:URL?=URL.init(string: "https://apps.apple.com/cn/app/%E6%A9%99%E5%BF%83%E6%97%B6%E4%BB%A3/id1626455805")
                        
                        UIApplication.shared.open(url ?? (URL.init(string: "https://apps.apple.com/cn/app/%E6%A9%99%E5%BF%83%E6%97%B6%E4%BB%A3/id1626455805"))!, options: [:], completionHandler: nil)
                    }))
                    self.present(noticeView, animated: true, completion: nil)
                }else{
                    let agreement = stringForKey(key: Constants.UpdateVerion)
                    if agreement == nil || (agreement?.isLengthEmpty())!{
                        self.showAlertDialog(message: "为了您得到更好用的户体验请您到应用商店下载最新版APP", title: "版本更新了") { (type) in
                            if type == .Sure{
                                let url:URL?=URL.init(string: "https://apps.apple.com/cn/app/%E6%A9%99%E5%BF%83%E6%97%B6%E4%BB%A3/id1626455805")
                                
                                UIApplication.shared.open(url ?? (URL.init(string: "https://apps.apple.com/cn/app/%E6%A9%99%E5%BF%83%E6%97%B6%E4%BB%A3/id1626455805"))!, options: [:], completionHandler: nil)
                            }else{
                                setIntValueForKey(value: IOS_force, key: Constants.isForceUpdateVerion)
                                setStringValueForKey(value: "UpdateVerion" as String, key: Constants.UpdateVerion)
                            }
                        }
                    }
                }
            }
        }
     }
    
    func callPhone(){
        
        let dialog = Dialog()
        dialog
            .wShowAnimationSet()(AninatonZoomIn)
            .wHideAnimationSet()(AninatonZoomOut)
            .wEventCancelFinishSet()(
                {(anyID:Any?,otherData:Any?) in
                    UIPasteboard.general.string = self.callMobile

                }
            )
            .wEventOKFinishSet()(
                { [self](anyID:Any?,otherData:Any?) in
                    let urlstr = "telprompt://" + callMobile
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
            .wMessageSet()("对方的联系方式为(微信同号):" + callMobile )
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
    
 
}
extension HomePageController:SDCycleScrollViewDelegate{
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        if bannerList[index].link == ""{
            return
        }
        let controller = NotifyWebDetailController()
        if bannerList[index].link.containsStr(find: "baidu"){
            return
        }
        controller.urlString = bannerList[index].link
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
extension HomePageController:GuideCellDelegate{
    func findWorkerViewAction() {
        let controller = WorkListViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func findJobViewAction() {
        let controller = JobListViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tipOffVIewAction() {
        let controller = TipOffMenuPageController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func superManViewAction() {
        let controller = SuperManListController()
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
 
}

extension HomePageController:JobHomeCellDelegate{
    func JobHomeCommunicateAction(mobile: String) {
        
        
        callMobile = mobile
        
        if checkMarketVer(){
            
        }else{
            if mobile == getAcctount(){
                showOnlyTextHUD(text: "不能给自己拨打电话")
                return
            }
            
        }
        
 
        let noticeView = UIAlertController.init(title: "温馨提示", message: "会员无限，非会员每天仅可获取三次对方联系方式，您确定获取吗？", preferredStyle: .alert)
         noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
             
             let pathAndParams = HomeAPI.userCallPathAndParams(type: 1)
             self.postRequest(pathAndParams: pathAndParams,showHUD: false)
             
        }))
        
        noticeView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
            
        }))
        self.present(noticeView, animated: true, completion: nil)
    }
    
    
}
extension HomePageController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: notifyModelList.count ,isdisplay: true)

        if section == 1{
            return dataLJobList.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      
            let sectionView = Bundle.main.loadNibNamed("HomeRankHeaderView", owner: nil, options: nil)!.first as! HomeRankHeaderView
            sectionView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 44)
            
            if section == 0{
                sectionView.name.text = "达人区"
            }else{
                sectionView.name.text = "最新场"
            }
            return sectionView
            
      
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 44
//        if section == 0{
//            return 0
//        }else{
//            return 44
//        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let section = indexPath.section
        if section == 0{
            return 102
        }else{
            return 109
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
 
        if indexPath.section == 1{
            let controller = JobInfoViewController()
            controller.dateID = dataLJobList[indexPath.row].id
            self.navigationController?.pushViewController(controller, animated: true)
        }
       
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = indexPath.section
//        if section == 0{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "GuideCell", for: indexPath) as! GuideCell
//            cell.delegate = self
//            cell.selectionStyle = .none
//            return cell
//        }else
        if section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSubscribeCell", for: indexPath) as! HomeSubscribeCell
            cell.selectionStyle = .none
            cell.parentNavigationController = self.navigationController
            cell.dataLWokerList = self.dataLWokerList
            cell.collectionView.reloadData()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeJobCell", for: indexPath) as! HomeJobCell
            cell.model = dataLJobList[indexPath.row]
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
       
    }
    
   
}

