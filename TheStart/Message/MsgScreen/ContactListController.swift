//
//  ContactListController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/21.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh

class ContactListController: BaseViewController,Requestable {
    
    
    var tableView:UITableView!
    
    var dataList = [ContactModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        initTableView()
        self.title = "聊天列表"
        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        let requestParams = HomeAPI.getContactListPathAndParams(keyword: "", page: page, limit: limit)
        getRequest(pathAndParams: requestParams,showHUD:false)

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

        let list:[ContactModel]  = getArrayFromJson(content: responseResult)

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
        tableView.registerNibWithTableViewCellName(name: ContactViewCell.nameOfClass)
        
        
        let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
        tableView.mj_header = addressHeadRefresh
        
        let footerRefresh = GmmMJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(pullRefreshList))
        tableView.mj_footer = footerRefresh
        
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

extension ContactListController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.tableViewDisplayWithMsg(message: "暂无消息", rowCount: dataList.count ,isdisplay: true)
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactViewCell", for: indexPath) as! ContactViewCell
        cell.selectionStyle = .none
        cell.model = dataList[indexPath.row]
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 72
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataList[indexPath.row].to_uid == getUserId(){
            showOnlyTextHUD(text: "不能跟自己发起聊天哦")
            return
        }
        let controller = UIStoryboard.getMessageController()
       
        controller.toID = dataList[indexPath.row].to_uid
        controller.nameTitle = dataList[indexPath.row].nickname
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
