//
//  HomePageMenuController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/06/16.
//
 
import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh
import SDCycleScrollView

class HomePageMenuController: BaseViewController,Requestable {
 
 
   // var  homeVc:HomePageController!
    var  jobVc:JobListViewController!
    var  workVc:WorkListViewController!
    var  storeVc:StoreViewController!
    var  goodsVc:goodsListController!
  
    
    
    
    var commonfont:CGFloat = 16
    var selectedfont:CGFloat = 17
    
    var jobVcButton:UIButton!
    var jobVcRedView:UIView!
 
    var workVcButton:UIButton!
    var workVcRedView:UIView!
    
    var goodsVcButton:UIButton!
    
    var storeVcButton:UIButton!
    
    var navView:UIView!
    
    var rightBarButton:UIButton!
    
    var bannerList = [ImageModel]()
    
    var advertisementView:SDCycleScrollView!
    
    var bannerView:UIView!
    var rightView:UIView!
    
    
    
    func UpdateAdvertisementView(imageArr:[ImageModel]) {
        
        let prarModel = imageArr
        var imageArrTemp = [String]()
        if imageArr.count == 0{
            self.view.addSubview(getAdvertisementView(imageArr: prarModel))
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
                self.view.addSubview(bannerView)
             }else{
                 advertisementView.imageURLStringsGroup = imageArrTemp
             }
        }
        
    }
    
    func getAdvertisementView(imageArr:[ImageModel]) -> UIView {
        
        bannerView = UIView.init(frame:  CGRect.init(x: 0, y:navigationHeaderAndStatusbarHeight , width: screenWidth, height: topAdvertisementViewHeight))
        bannerView.backgroundColor = ZYJColor.main
 
        var imageArrTemp = [String]()
        if imageArr.count == 0{
            return UIView()
        }else{
            for model in imageArr {
                imageArrTemp.append(model.pic)
            }
        }
        print(imageArrTemp)
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
    
    func loadData(){
       
        
        let requestParamsP3 = HomeAPI.openMarketPathAndParam()
        postRequest(pathAndParams: requestParamsP3,showHUD: false)
        
        
        let workParams = HomeAPI.homePathAndParams()
        getRequest(pathAndParams: workParams,showHUD: false)
    }
    
    func loadDictData(){
        
        let workParams = HomeAPI.workCategoryPathAndParams()
        getRequest(pathAndParams: workParams,showHUD: false)
        
        
        let requestParamsP3 = HomeAPI.openMarketPathAndParam()
        postRequest(pathAndParams: requestParamsP3,showHUD: false)
        
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
    }

    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
 
        if requestPath.containsStr(find: HomeAPI.homePath){
             bannerList = getArrayFromJsonByArrayName(arrayName: "banner", content:  responseResult)
             UpdateAdvertisementView(imageArr: bannerList)
        }else if requestPath.containsStr(find: HomeAPI.workCategoryPath){
            let salaryParams = HomeAPI.salaryPathAndParams()
            getRequest(pathAndParams: salaryParams,showHUD: false)
        }else if requestPath.containsStr(find: HomeAPI.salaryPath){
            addController()
        }
        
        else if requestPath == HomeAPI.openMarketPath{
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
            
            let floatCode = stringToFloat(test: IOS_code)
            let floatsysCode = stringToFloat(test: SysMajorVersion)
            
            if floatCode > floatsysCode{  //这里判断一下大小给审核官
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
    
    
    func addController(){
        jobVc = JobListViewController()
        jobVc.isFromHome = true
        jobVc.view.frame = CGRect.init(x: 0, y: topAdvertisementViewHeight + navigationHeaderAndStatusbarHeight + 10, width: screenWidth, height: screenHeight)
        
        
        workVc = WorkListViewController()
        workVc.isFromHome = true
        workVc.view.frame = CGRect.init(x: 0, y: topAdvertisementViewHeight + navigationHeaderAndStatusbarHeight + 10, width: screenWidth, height: screenHeight)
       
        
        storeVc = StoreViewController()
        storeVc.view.frame = CGRect.init(x: 0, y:navigationHeaderAndStatusbarHeight + 10, width: screenWidth, height: screenHeight)
        
        //goodsVc = goodsListController()
        //goodsVc.view.frame = CGRect.init(x: 0, y:navigationHeaderAndStatusbarHeight + 10, width: screenWidth, height: screenHeight)
        
        self.addChild(jobVc)
        self.view.addSubview(jobVc.view)
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = ZYJColor.main
        
        createRightNavItem()
        
        WebSocketManager.instance.openSocket()
        loadData()
        loadDictData()
 
       // navView = UIView.init(frame: CGRect.init(x: (screenWidth - 260)/2, y: 0, width:240, height: 44))
        navView = UIView.init(frame: CGRect.init(x: (screenWidth - 220)/2, y: 0, width:220, height: 44))
        jobVcButton = UIButton.init()
        jobVcButton.frame = CGRect.init(x: 0, y: 0, width: 80, height: 44)
        jobVcButton.addTarget(self, action: #selector(jobVcButtonACtion(_:)), for: .touchUpInside)
        jobVcButton.setTitle("我要找人", for: .normal)
        jobVcButton.setTitleColor(ZYJColor.barText, for: .normal)
        jobVcButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: selectedfont)
        
        jobVcRedView = UIView.init(frame:  CGRect.init(x: 67, y: 10, width:10, height: 10))
        jobVcRedView.backgroundColor = UIColor.red
        jobVcRedView.layer.masksToBounds = true
        jobVcRedView.layer.cornerRadius = 5
        
      
        workVcButton = UIButton.init()
        workVcButton.frame = CGRect.init(x: 80, y: 0, width: 80, height: 44)
        workVcButton.addTarget(self, action: #selector(workVcuttonACtion(_:)), for: .touchUpInside)
        workVcButton.setTitle("我要找场", for: .normal)
        workVcButton.setTitleColor(UIColor.white, for: .normal)
        workVcButton.titleLabel?.font = UIFont.systemFont(ofSize: commonfont)
        
        workVcRedView = UIView.init(frame:  CGRect.init(x: 67 + 80, y: 10, width:10, height: 10))
        workVcRedView.backgroundColor = UIColor.red
        workVcRedView.layer.masksToBounds = true
        workVcRedView.layer.cornerRadius = 5
        
        
        storeVcButton = UIButton.init()
        //storeVcButton.frame = CGRect.init(x: 160, y: 0, width: 50, height: 44)
        storeVcButton.frame = CGRect.init(x: 160, y: 0, width: 60, height: 44)

        storeVcButton.addTarget(self, action: #selector(storeVcButtonACtion(_:)), for: .touchUpInside)
        storeVcButton.setTitle("商家", for: .normal)
        storeVcButton.setTitleColor(UIColor.white, for: .normal)
        storeVcButton.titleLabel?.font = UIFont.systemFont(ofSize: commonfont)
        
//        goodsVcButton = UIButton.init()
//        goodsVcButton.frame = CGRect.init(x: 210, y: 0, width: 50, height: 44)
//        goodsVcButton.addTarget(self, action: #selector(goodsVcButtonACtion(_:)), for: .touchUpInside)
//        goodsVcButton.setTitle("商店", for: .normal)
//        goodsVcButton.setTitleColor(UIColor.white, for: .normal)
//        goodsVcButton.titleLabel?.font = UIFont.systemFont(ofSize: commonfont)
 
        navView.addSubview(jobVcButton)
        navView.addSubview(workVcButton)
        navView.addSubview(storeVcButton)
       // navView.addSubview(goodsVcButton)
        
        let preDate = stringForKey(key: "predate")
        if (preDate != nil){
            print(preDate!)
        }
        if  (preDate != nil) && Calendar.current.isDate(self.dateTime(preDate!), inSameDayAs: self.dateTime(getNowDate())) {
            print("它们是同一天")
        }else {
            navView.addSubview(jobVcRedView)
            navView.addSubview(workVcRedView)
            setValueForKey(value: getNowDate()  as AnyObject, key: "predate")
         }
 
        //getLastDay(_ nowDay: String)

        self.navigationController?.navigationBar.addSubview(navView)
         self.view.addSubview(getAdvertisementView(imageArr: bannerList))
       
    }
 
    
    func getNowDate() -> String {
        
        let format = DateFormatter.init()
        format.dateFormat = "yyyy.MM.dd"
        let now = format.string(from: Date.init()) as String
        return now
    }
    
    func createRightNavItem() {
        
        rightBarButton = UIButton.init(type: .custom)
        rightBarButton.frame = CGRect.init(x: 0, y: 1, width: 38, height: 38)
        rightBarButton.addTarget(self, action: #selector(rightNavBtnClic(_:)), for: .touchUpInside)
        //rightBarButton.setBackgroundImage(UIImage.init(named: "release"), for: .normal)
        rightBarButton.setImage(UIImage.init(named: "release"), for: .normal)
        rightView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        rightView.addSubview(rightBarButton)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightView)
 
    }
    
    func dateTime(_ dateStr: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let date = dateFormatter.date(from:dateStr)!
        return date
    }
    
    @objc func rightNavBtnClic(_ btn: UIButton){
         YBPopupMenu.showRely(on: btn, titles: ["我要找场","我要找人",], icons: [], menuWidth: 125, delegate: self)
    }
    
    func getLastDay(_ nowDay: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        // 先把传入的时间转为 date
        let date = dateFormatter.date(from: nowDay)
        let lastTime: TimeInterval = -(24*60*60) // 往前减去一天的秒数，昨天
//      let nextTime: TimeInterval = 24*60*60 // 这是后一天的时间，明天
        let lastDate = date?.addingTimeInterval(lastTime)
        let lastDay = dateFormatter.string(from: lastDate!)
        return lastDay
 
    }
    
    @objc func jobVcButtonACtion(_ btn: UIButton){
        
        if (!jobVcRedView.isHidden) {
            jobVcRedView.isHidden = true;
        }
        
        bannerView.isHidden = false
        advertisementView.isHidden = false
        let cons = self.children
        
      
        
        for con in cons {
            if con != jobVc{
                con.removeFromParent()
                con.view.removeFromSuperview()
            }
        }

        if cons.count > 0 && cons.contains(jobVc) {
            jobVc.refreshScrollToRow()
            return;
        }
        
        jobVcButton.setTitleColor(ZYJColor.barText, for: .normal)
        jobVcButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: selectedfont)
        
        workVcButton.setTitleColor(UIColor.white, for: .normal)
        workVcButton.titleLabel?.font = UIFont.systemFont(ofSize: commonfont)
        
       // goodsVcButton.setTitleColor(UIColor.white, for: .normal)
       // goodsVcButton.titleLabel?.font = UIFont.systemFont(ofSize: commonfont)
        
        storeVcButton.setTitleColor(UIColor.white, for: .normal)
        storeVcButton.titleLabel?.font = UIFont.systemFont(ofSize: commonfont)
        

        self.addChild(jobVc)

        self.view.addSubview(jobVc.view)
     }
    
    @objc func workVcuttonACtion(_ btn: UIButton){
        
        if (!workVcRedView.isHidden) {
            workVcRedView.isHidden = true;
        }
        
        bannerView.isHidden = false
        advertisementView.isHidden = false
        let cons = self.children
        
        for con in cons {
            if con != workVc{
                con.removeFromParent()
                con.view.removeFromSuperview()
            }
        }
        if cons.count > 0 && cons.contains(workVc) {
            workVc.refreshScrollToRow()
            return;
        }
 
        jobVcButton.setTitleColor(UIColor.white, for: .normal)
        jobVcButton.titleLabel?.font = UIFont.systemFont(ofSize: commonfont)
        
        workVcButton.setTitleColor(ZYJColor.barText, for: .normal)
        workVcButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: selectedfont)
        
       // goodsVcButton.setTitleColor(UIColor.white, for: .normal)
       // goodsVcButton.titleLabel?.font = UIFont.systemFont(ofSize: commonfont)
 
        storeVcButton.setTitleColor(UIColor.white, for: .normal)
        storeVcButton.titleLabel?.font = UIFont.systemFont(ofSize: commonfont)
        
        self.addChild(workVc)
        self.view.addSubview(workVc.view)
    }
    
    @objc func goodsVcButtonACtion(_ btn: UIButton){
        
        bannerView.isHidden = true
        advertisementView.isHidden = true
        let cons = self.children
        
        for con in cons {
            if con != goodsVc{
                con.removeFromParent()
                con.view.removeFromSuperview()
            }
        }
 
      

        jobVcButton.setTitleColor(UIColor.white, for: .normal)
        jobVcButton.titleLabel?.font = UIFont.systemFont(ofSize: commonfont)
        
        workVcButton.setTitleColor(UIColor.white, for: .normal)
        workVcButton.titleLabel?.font = UIFont.systemFont(ofSize: commonfont)
        
       // goodsVcButton.setTitleColor(ZYJColor.barText, for: .normal)
       // goodsVcButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: selectedfont)
        
        storeVcButton.setTitleColor(UIColor.white, for: .normal)
        storeVcButton.titleLabel?.font = UIFont.systemFont(ofSize: commonfont)
       

        self.addChild(goodsVc)
        self.view.addSubview(goodsVc.view)
    }
    
    @objc func storeVcButtonACtion(_ btn: UIButton){
        
        bannerView.isHidden = true
        advertisementView.isHidden = true
        let cons = self.children
        for con in cons {
            if con != storeVc{
                con.removeFromParent()
                con.view.removeFromSuperview()
            }
        }
       
        
        jobVcButton.setTitleColor(UIColor.white, for: .normal)
        jobVcButton.titleLabel?.font = UIFont.systemFont(ofSize: commonfont)
        
        workVcButton.setTitleColor(UIColor.white, for: .normal)
        workVcButton.titleLabel?.font = UIFont.systemFont(ofSize: commonfont)
        
       // goodsVcButton.setTitleColor(UIColor.white, for: .normal)
       // goodsVcButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: commonfont)
        
        storeVcButton.setTitleColor(ZYJColor.barText, for: .normal)
        storeVcButton.titleLabel?.font = UIFont.systemFont(ofSize: selectedfont)
        
       

        self.addChild(storeVc)
        self.view.addSubview(storeVc.view)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navView.removeFromSuperview()
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.addSubview(navView)
    }
      
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
    }
 

}
 
extension HomePageMenuController:YBPopupMenuDelegate{
    func ybPopupMenuDidSelected(at index: Int, ybPopupMenu: YBPopupMenu!) {
        ybPopupMenu.isHidden = true
        
        if index == 0{
            let controller = WorkerPubViewController()
            controller.pubType = 2
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
            let controller = WorkerPubViewController()
            controller.pubType = 1
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
extension HomePageMenuController:SDCycleScrollViewDelegate{
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        if bannerList[index].link == ""{
            return;
        }
        if bannerList[index].link.containsStr(find: "stopPage"){
            return;
        }
        
        let controller = NotifyWebDetailController()

        controller.urlString = bannerList[index].link
        if bannerList[index].link.containsStr(find: "plane"){
            let controller = HomeWebDetailController()
            let uisid:Int = intForKey(key: Constants.userid) ?? 0
            controller.urlString = "https://www.qichen123.com/web_view/dfj/index.html?user_id=" + intToString(number: uisid)
            self.navigationController?.pushViewController(controller, animated: true)
            return
        }else if(bannerList[index].link.containsStr(find: "answer")){
            let uisid:Int = intForKey(key: Constants.userid) ?? 0
            controller.urlString = "https://www.qichen123.com//web_view/paper/questions_info.html?user_id=" + intToString(number: uisid)
         }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
