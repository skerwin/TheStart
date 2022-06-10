//
//  CashOutStutateController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/10.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh

class CashOutStutateController: BaseViewController,Requestable {

    var tableView:UITableView!
    
    var dataList = [CashOutModel]()
    
    var headView:CashOutHeader!
        
    var headerBgView:UIView!
    
    var parentNavigationController: UINavigationController?
    
    var process = 0
    var complete = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHeadView()
        loadData()
        initTableView()
        self.title = "提现进度"
        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        let requestParams = HomeAPI.bankOutListPathAndParams(page: page, limit: limit)
        postRequest(pathAndParams: requestParams,showHUD:false)

    }
    
    func initHeadView(){
        headView = Bundle.main.loadNibNamed("CashOutHeader", owner: nil, options: nil)!.first as? CashOutHeader
        headView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 160)
        //headView.delegate = self
        headerBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 160))
        headerBgView.backgroundColor = UIColor.clear
        headerBgView.addSubview(headView)
        
      }
    override func onFailure(responseCode: String, description: String, requestPath: String) {
              tableView.mj_header?.endRefreshing()
              tableView.mj_footer?.endRefreshing()
              self.tableView.mj_footer?.endRefreshingWithNoMoreData()
    }

    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        tableView.mj_header?.endRefreshing()
        tableView.mj_footer?.endRefreshing()

        process =  responseResult["info"]["process"].intValue
        complete =  responseResult["info"]["complete"].intValue
        
        headView.processLabel.text = "¥" + intToString(number: process)
        headView.compltetLabel.text = "¥" + intToString(number: complete)
        
        let list:[CashOutModel]  = getArrayFromJson(content: responseResult["list"])

        dataList.append(contentsOf: list)
        if list.count < 10 {
            self.tableView.mj_footer?.endRefreshingWithNoMoreData()
        }
        self.tableView.reloadData()
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
        tableView.registerNibWithTableViewCellName(name: CashOutCell.nameOfClass)
 
        let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
        tableView.mj_header = addressHeadRefresh

        let footerRefresh = GmmMJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(pullRefreshList))
        tableView.mj_footer = footerRefresh
        
        tableView.tableHeaderView = headView
        
        view.addSubview(tableView)
        tableView.tableFooterView = UIView()
      
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

extension CashOutStutateController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: dataList.count ,isdisplay: true)

       // return 10
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CashOutCell", for: indexPath) as! CashOutCell
        cell.selectionStyle = .none
        cell.model = dataList[indexPath.row]
        return cell
       
      
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 70

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
    

}
