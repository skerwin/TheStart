//
//  ClarifyViewController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/29.
//
 

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh

class ClarifyViewController: BaseViewController,Requestable {

    var tableView:UITableView!
    var dataList = [TipOffModel]()
        
    var type = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        initTableView()
        self.title = "澄清馆"
        // Do any additional setup after loading the view.
    }
    func loadData(){
        let requestParams = HomeAPI.tipOffListPathAndParams(type:type, page: page, limit: pagenum)
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

        let list:[TipOffModel]  = getArrayFromJson(content: responseResult)
           // getArrayFromJsonByArrayName(arrayName: "list", content:  responseResult)

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
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 240;
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.registerNibWithTableViewCellName(name: TipOffListCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: TipOffListNoImgCell.nameOfClass)
 
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

extension ClarifyViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: dataList.count ,isdisplay: true)
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
 
//        if dataList[indexPath.row].images.count != 0{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "TipOffListCell", for: indexPath) as! TipOffListCell
//            cell.selectionStyle = .none
//            cell.model = dataList[indexPath.row]
//            return cell
//        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TipOffListNoImgCell", for: indexPath) as! TipOffListNoImgCell
            cell.selectionStyle = .none
            cell.model = dataList[indexPath.row]
            return cell
//        }
      
     }
 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = TipOffDetailViewController()
        controller.dateID = dataList[indexPath.row].id
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
