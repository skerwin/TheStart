//
//  WorkListViewController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/20.
//

import UIKit
import SwiftyJSON

class WorkListViewController: BaseViewController,Requestable  {

    
    var parentNavigationController: UINavigationController?
    var tableView:UITableView!
    
    var dataList = [JobModel]()
    
    var salaryList = [DictModel]()
    var workCateList = [DictModel]()
    let genderList = ["不限","男","女"]
    var addressList = [AddressModel]()
 
    var dropView:DOPDropDownMenu!
        
    
    var type = 2 //牛人列表
    var cate_id = 0
    var salary = 0
    var city = ""
    var keyword = ""
    var gender = ""
    var rightBarButton:UIButton!
    
    var isFromMine = false
    var isMypub = false
    var isMyCollect = false
    
    override func loadView() {
        super.loadView()
        self.edgesForExtendedLayout = []
    }
    
    override func viewDidLoad() {
        loadData()
        loadCityJson()
        if isFromMine {
        }else{
            createRightNavItem()
            initDropView()
        }
        initTableView()
        self.title = "求职列表"
        // Do any additional setup after loading the view.
    }
    
    func  loadData(){
        
        if isMypub {
            let pathAndParams = HomeAPI.myJobWorkerListPathAndParams(type: type, page: page, limit: limit)
            getRequest(pathAndParams: pathAndParams,showHUD: false)
        }else if isMyCollect{
            let pathAndParams = HomeAPI.collectJobWorkerListPathAndParams(type: type, page: page, limit: limit)
            getRequest(pathAndParams: pathAndParams,showHUD: false)
        }else{
            let pathAndParams = HomeAPI.jobAndWorkerPathAndParams(type: type, cate_id: cate_id, salary: salary, page: page, limit: limit, city: city, keyword: keyword, gender: gender)
            getRequest(pathAndParams: pathAndParams,showHUD: false)
        }
       
    }
    
    
    func createRightNavItem() {
        rightBarButton = UIButton.init()
        let bgview = UIView.init()
        rightBarButton.frame = CGRect.init(x: 0, y: 6, width: 70, height: 28)
        rightBarButton.setTitle("职位发布", for: .normal)
        bgview.frame = CGRect.init(x: 0, y: 0, width: 65, height: 44)
        rightBarButton.addTarget(self, action: #selector(rightNavBtnClic(_:)), for: .touchUpInside)
        rightBarButton.setTitleColor(.white, for: .normal)
        rightBarButton.backgroundColor = colorWithHexString(hex: "#228CFC")
        rightBarButton.layer.masksToBounds = true
        rightBarButton.layer.cornerRadius = 5;
        rightBarButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        bgview.addSubview(rightBarButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: bgview)
        
    }

    @objc func rightNavBtnClic(_ btn: UIButton){
        let controller = WorkerPubViewController()
        controller.pubType = 1
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func loadCityJson(){
        do {
              if let file = Bundle.main.url(forResource: "cityjson", withExtension: "json") {
                  let data = try Data(contentsOf: file)
                  let json = try JSONSerialization.jsonObject(with: data, options: [])
                  if json is [String: Any] {
                      // json is a dictionary
                  } else if let object = json as? [Any] {
                      // json is an array
                      let responseJson = JSON(object)
                      addressList = getArrayFromJson(content:responseJson)
                      
                      var modelall = AddressModel()
                      modelall?.name = "城市"
                      modelall?.level = "0"
                      
                      var sunModelall = AddressModel()
                      sunModelall?.name = "城市"
                      sunModelall?.level = "0"
                      modelall?.children.append(sunModelall!)
                      addressList.insert(modelall!, at: 0)
                  } else {
                      print("JSON is invalid")
                  }
              } else {
                  print("no file")
              }
          } catch {
              print(error.localizedDescription)
          }
        
        let workcateResult = XHNetworkCache.check(withURL: HomeAPI.workCategoryPath)
        if workcateResult {
            let dict = XHNetworkCache.cacheJson(withURL: HomeAPI.workCategoryPath)
            let responseJson = JSON(dict)
            workCateList = getArrayFromJson(content: responseJson["data"]["cate"])
            
            var modelall = DictModel()
            modelall?.title = "工种"
            modelall?.id = 0
            
            var sunModelall = DictModel()
            sunModelall?.title = "工种"
            sunModelall?.id = 0
            modelall?.child.append(sunModelall!)
            workCateList.insert(modelall!, at: 0)
            
        }
        
        let salaryResult = XHNetworkCache.check(withURL: HomeAPI.salaryPath)
        if salaryResult {
            let dict = XHNetworkCache.cacheJson(withURL: HomeAPI.salaryPath)
            let responseJson = JSON(dict)
            salaryList = getArrayFromJson(content: responseJson["data"])
            
            var modelall = DictModel()
            modelall?.salary = "薪资"
            modelall?.id = 0
            salaryList.insert(modelall!, at: 0)
        }
        
    }
    
    func initDropView(){
        
        dropView = DOPDropDownMenu.init(origin: CGPoint.init(x: 0, y:0 ), andHeight: 48)
        dropView.indicatorColor = UIColor.white
        dropView.fontSize = 16
        dropView.textColor = UIColor.white
        dropView.delegate = self
        dropView.dataSource = self
        self.view.addSubview(dropView)
    }
    
    func initTableView(){
        
        if isFromMine{
            tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - 44 - navigationHeight), style: .plain)
        }else{
            tableView = UITableView(frame: CGRect(x: 0, y: 48, width: screenWidth, height: screenHeight - 48), style: .plain)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = ZYJColor.main
        
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 240;
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.registerNibWithTableViewCellName(name: WorkerViewCell.nameOfClass)
 
        let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
        tableView.mj_header = addressHeadRefresh

        let footerRefresh = GmmMJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(pullRefreshList))
        tableView.mj_footer = footerRefresh
        
        view.addSubview(tableView)
        tableView.tableFooterView = UIView()
      
    }
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        tableView.mj_header?.endRefreshing()
        tableView.mj_footer?.endRefreshing()
        
        if requestPath.containsStr(find: HomeAPI.collectJobWorkerListPath){
            let list:[JobModel]  = getArrayFromJson(content: responseResult)

            dataList.append(contentsOf: list)
            if list.count < 10 {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
        } else if requestPath.containsStr(find: HomeAPI.myJobWorkerListPath){
            let list:[JobModel]  = getArrayFromJson(content: responseResult)

            dataList.append(contentsOf: list)
            if list.count < 10 {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
        }else{
            let list:[JobModel]  = getArrayFromJson(content: responseResult["list"])

            dataList.append(contentsOf: list)
            if list.count < 10 {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
        }
        self.tableView.reloadData()
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        tableView.mj_header?.endRefreshing()
        tableView.mj_footer?.endRefreshing()
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
    }
    @objc func pullRefreshList() {
        page = page + 1
        self.loadData()
    }
    
    @objc func refreshList() {
        self.tableView.mj_footer?.resetNoMoreData()
        dataList.removeAll()
        page = 1
        self.loadData()
    }
 
}

extension WorkListViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: dataList.count ,isdisplay: true)
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerViewCell", for: indexPath) as! WorkerViewCell
        cell.model = dataList[indexPath.row]
        if isFromMine{
            cell.communiteBtn.isHidden = true
        }else{
            cell.communiteBtn.isHidden = false
        }
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
 
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 121

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let controller = WorkerInfoViewController()
         controller.dateID = dataList[indexPath.row].id
         self.navigationController?.pushViewController(controller, animated: true)
    }
    

}
extension WorkListViewController:WorkerViewCellDelegate {
    func WorkerCellCommunicateAction(mobile:String) {
        let noticeView = UIAlertController.init(title: "", message: "您确定拨打对方的联系电话吗？", preferredStyle: .alert)
        
         noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
             
             
             let urlstr = "telprompt://" + mobile
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
extension WorkListViewController: DOPDropDownMenuDataSource,DOPDropDownMenuDelegate {
    
    func numberOfColumns(in menu: DOPDropDownMenu!) -> Int {
        return 4
    }
    func menu(_ menu: DOPDropDownMenu!, numberOfRowsInColumn column: Int) -> Int {
        switch column {
        case 0:
            return addressList.count
        case 1:
            return workCateList.count
        case 2:
            return salaryList.count
        case 3:
            return genderList.count
            
        default:
            return 0
        }
    }
    
    func menu(_ menu: DOPDropDownMenu!, titleForRowAt indexPath: DOPIndexPath!) -> String! {
        switch indexPath.column {
        case 0:
            return addressList[indexPath.row].name
        case 1:
            return workCateList[indexPath.row].title
        case 2:
            return salaryList[indexPath.row].salary
        case 3:
            return genderList[indexPath.row]
            
        default:
            return ""
        }
    }
    // 二级的时候用
    func menu(_ menu: DOPDropDownMenu!, numberOfItemsInRow row: Int, column: Int) -> Int {
        
        if column == 0{
           return addressList[row].children.count
        }else if column == 1{
           return workCateList[row].child.count
        }
        return 0
    }
    func menu(_ menu: DOPDropDownMenu!, titleForItemsInRowAt indexPath: DOPIndexPath!) -> String! {
        if indexPath.column == 0{
            let nextList = addressList[indexPath.row].children
            return nextList[indexPath.item].name
        }else  if indexPath.column == 1{
            let nextList = workCateList[indexPath.row].child
            return nextList[indexPath.item].title
        }
        return ""
    }
    
    func menu(_ menu: DOPDropDownMenu!, didSelectRowAt indexPath: DOPIndexPath!) {
        
        let colum = indexPath.column
        let row = indexPath.row
        let item = indexPath.item
        if colum == 0{
            if item != -1{
              let nextArr = addressList[row].children
              city = nextArr[indexPath.item].label
            }
        }else if colum == 1{
            if item != -1{
              let nextArr = workCateList[row].child
              cate_id = nextArr[indexPath.item].id
            }
        }else if colum == 2{
 
            salary = salaryList[row].id
        }else if colum == 3{
            gender = genderList[row]
        }
        refreshList()
        
    }
    func menu(_ menu: DOPDropDownMenu!, confirmBtnClick indexPathList: NSMutableDictionary!) {
        
    }
    func menu(_ menu: DOPDropDownMenu!, cancelBtnClick indexPathList: NSMutableDictionary!) {
        
    }
}
 
