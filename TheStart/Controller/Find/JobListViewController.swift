//
//  JobListViewController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/20.
//

import UIKit
import SwiftyJSON
 
class JobListViewController: BaseViewController,Requestable {

    var tableView:UITableView!
    
    var dataList = [String]()
    let moneyList = ["薪资","5K以下","5K-1W","1W-1.5W","1.5W以上"]
    
    var dropView:DOPDropDownMenu!
    
    var departmentList = [DepartmentModel]()
    override func loadView() {
        super.loadView()
        self.edgesForExtendedLayout = []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCache()
        initDropView()
        initTableView()
        self.title = "用工列表"
        // Do any additional setup after loading the view.
    }
    
    func loadCache(){
            let departmenResult = XHNetworkCache.check(withURL: HomeAPI.departmenListPath)
            if departmenResult {
                let dict = XHNetworkCache.cacheJson(withURL: HomeAPI.departmenListPath)
                let responseJson = JSON(dict)
                departmentList = getArrayFromJson(content: responseJson["data"])
                
                var modelall = DepartmentModel()
                modelall?.name = "科室"
                modelall?.id = 0
                
                var sunModelall = DepartmentModel()
                sunModelall?.name = "科室"
                sunModelall?.id = 0
                modelall?.child.append(sunModelall!)
                departmentList.insert(modelall!, at: 0)
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
        
        tableView = UITableView(frame: CGRect(x: 0, y: 48, width: screenWidth, height: screenHeight - 48), style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = ZYJColor.main
        
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 240;
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.registerNibWithTableViewCellName(name: JobViewCell.nameOfClass)
 
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
        if requestPath == HomeAPI.departmenListPath{
            departmentList = getArrayFromJson(content: responseResult)
            
            var modelall = DepartmentModel()
            modelall?.name = "科室"
            modelall?.id = 0
            
            var sunModelall = DepartmentModel()
            sunModelall?.name = "科室"
            sunModelall?.id = 0
            modelall?.child.append(sunModelall!)
            departmentList.insert(modelall!, at: 0)
        }
        self.tableView.reloadData()
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        tableView.mj_header?.endRefreshing()
        tableView.mj_footer?.endRefreshing()
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
    }
    @objc func pullRefreshList() {
        tableView.mj_header?.endRefreshing()
        tableView.mj_footer?.endRefreshing()
//        page = page + 1
//        self.loadData()
    }
    
    @objc func refreshList() {
        tableView.mj_header?.endRefreshing()
        tableView.mj_footer?.endRefreshing()
//        dateModelList.removeAll()
//        self.tableView.mj_footer?.resetNoMoreData()
//        page = 1
//        self.loadData()
    }
 
}

extension JobListViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: notifyModelList.count ,isdisplay: true)

        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobViewCell", for: indexPath) as! JobViewCell
        cell.selectionStyle = .none
        return cell
       
      
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 109

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let controller = TipOffDetailViewController()
      
         self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
extension JobListViewController: DOPDropDownMenuDataSource,DOPDropDownMenuDelegate {
    
    func numberOfColumns(in menu: DOPDropDownMenu!) -> Int {
        return 4
    }
    func menu(_ menu: DOPDropDownMenu!, numberOfRowsInColumn column: Int) -> Int {
        switch column {
        case 0:
            return departmentList.count
        case 1:
            return departmentList.count
        case 2:
            return moneyList.count
        case 3:
            return moneyList.count
            
        default:
            return 0
        }
    }
    
    func menu(_ menu: DOPDropDownMenu!, titleForRowAt indexPath: DOPIndexPath!) -> String! {
        switch indexPath.column {
        case 0:
            return departmentList[indexPath.row].name
        case 1:
            return departmentList[indexPath.row].name
        case 2:
            return moneyList[indexPath.row]
        case 3:
            return moneyList[indexPath.row]
            
        default:
            return ""
        }
    }
    // 二级的时候用
    func menu(_ menu: DOPDropDownMenu!, numberOfItemsInRow row: Int, column: Int) -> Int {
        
        if column == 0{
           return departmentList[row].child.count
        }
        return 0
    }
    func menu(_ menu: DOPDropDownMenu!, titleForItemsInRowAt indexPath: DOPIndexPath!) -> String! {
        if indexPath.column == 0{
            let nextList = departmentList[indexPath.row].child
            return nextList[indexPath.item].name
        }
        return ""
    }
    
    func menu(_ menu: DOPDropDownMenu!, didSelectRowAt indexPath: DOPIndexPath!) {
        
        let colum = indexPath.column
        let row = indexPath.row
        let item = indexPath.item
        
        if colum == 0{
          
            if item != -1{
                 refreshList()
            }
        }else if colum == 1{
             refreshList()
        }else if colum == 2{
           
            refreshList()
        }
        
        
    }
    func menu(_ menu: DOPDropDownMenu!, confirmBtnClick indexPathList: NSMutableDictionary!) {
        
    }
    func menu(_ menu: DOPDropDownMenu!, cancelBtnClick indexPathList: NSMutableDictionary!) {
        
    }
}
 
