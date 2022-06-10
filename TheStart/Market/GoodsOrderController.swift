//
//  GoodsOrderController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/26.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh

class GoodsOrderController: BaseViewController,Requestable {

    
    var tableView:UITableView!
    
    var dataList = [OrderModel]()
        
    var pubBtn:UIButton!
    
    var orderStatus = 1
    var parentNavigationController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        initTableView()
        self.title = "我的购买"
        // Do any additional setup after loading the view.
    }
    
    
    func loadData(){
        let requestParams = HomeAPI.goodsOrderListPathAndParams(order_status: orderStatus, page: page, limit: limit)
        postRequest(pathAndParams: requestParams,showHUD:false)

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

        let list:[OrderModel]  = getArrayFromJson(content: responseResult)

        dataList.append(contentsOf: list)
        if list.count < 10 {
            self.tableView.mj_footer?.endRefreshingWithNoMoreData()
        }
        self.tableView.reloadData()
    }
    
    func initTableView(){
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - navigationHeaderAndStatusbarHeight - 44), style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = ZYJColor.main
        
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 240;
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
         tableView.registerNibWithTableViewCellName(name: GoodsOrderCell.nameOfClass)
 
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

extension GoodsOrderController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: dataList.count ,isdisplay: true)

        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsOrderCell", for: indexPath) as! GoodsOrderCell
        cell.selectionStyle = .none
        cell.config(model: dataList[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = UIStoryboard.getGoodsCashDeskController()
        controller.isFromOrder = true
        controller.orderId = dataList[indexPath.row].id
        self.present(controller, animated: true)
        //self.parentNavigationController?.pushViewController(controller, animated: true)
    }
}
