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

 
class HomePageController: BaseViewController,Requestable {

    
    var tableView:UITableView!
    
    var dataLWokerList = [JobModel]()
    var dataLJobList = [JobModel]()
    var bannerList = [ImageModel]()
    
    var advertisementView:SDCycleScrollView!
    var bannerView:UIView!
    
    let topAdvertisementViewHeight = screenWidth * 0.40
    
    var callMobile = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WebSocketManager.instance.openSocket()
        
       // logoutAccount(account: "")
        initTableView()
        self.view.backgroundColor = ZYJColor.main
        loadData()
       
        loadDictData()
        self.title = "首页"
        // Do any additional setup after loading the view.
    }
    func loadData(){
       
        let workParams = HomeAPI.homePathAndParams()
        getRequest(pathAndParams: workParams,showHUD: false)
    }
    
    func loadDictData(){
        
        let workParams = HomeAPI.workCategoryPathAndParams()
        getRequest(pathAndParams: workParams,showHUD: false)
        
        let salaryParams = HomeAPI.salaryPathAndParams()
        getRequest(pathAndParams: salaryParams,showHUD: false)
        
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
        }


    }
    
    func callPhone(){
        let urlstr = "telprompt://" + callMobile
        if let url = URL.init(string: urlstr){
             if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
             }
        }
    }
    
 
}
extension HomePageController:SDCycleScrollViewDelegate{
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        if bannerList[index].link == ""{
            return
        }
        let controller = NotifyWebDetailController()
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
        
        if mobile == getAcctount(){
            showOnlyTextHUD(text: "不能给自己拨打电话")
            return
        }
        
        
        let noticeView = UIAlertController.init(title: "", message: "您确定拨打对方的联系电话吗？", preferredStyle: .alert)
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
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: notifyModelList.count ,isdisplay: true)

        if section == 2{
            return dataLJobList.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            return UIView()
        }else{
            let sectionView = Bundle.main.loadNibNamed("HomeRankHeaderView", owner: nil, options: nil)!.first as! HomeRankHeaderView
            sectionView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 44)
            
            if section == 1{
                sectionView.name.text = "达人区"
            }else{
                sectionView.name.text = "最新职位"
            }
            return sectionView
            
        }
      
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return 44
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let section = indexPath.section
        if section == 0{
            return 110
        }else if section == 1{
            return 102
        }else{
            return 109
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
 
        if indexPath.section == 2{
            let controller = JobInfoViewController()
            controller.dateID = dataLJobList[indexPath.row].id
            self.navigationController?.pushViewController(controller, animated: true)
        }
       
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = indexPath.section
        if section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "GuideCell", for: indexPath) as! GuideCell
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }else if section == 1{
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

