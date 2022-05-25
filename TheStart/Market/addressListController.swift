//
//  addressListController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/25.
//


import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh

class addressListController: BaseViewController,Requestable {

    
    var tableView:UITableView!
    
    var dataList = [AddressModel]()
        
    var rightBarButton:UIButton!

    var type = 2
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        initTableView()
        createRightNavItem()
        self.title = "地址管理"
        // Do any additional setup after loading the view.
    }
    
    
    func loadData(){
        let requestParams = HomeAPI.addressListPathAndParams()
        postRequest(pathAndParams: requestParams,showHUD:false)

    }
    func createRightNavItem() {
        
        rightBarButton = UIButton.init()
        let bgview = UIView.init()
 
        rightBarButton.frame = CGRect.init(x: 0, y: 6, width: 70, height: 28)
        rightBarButton.setTitle("添加地址", for: .normal)
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
        let controller = UIStoryboard.getaddressDetailController()
        controller.isadd = true
         self.navigationController?.pushViewController(controller, animated: true)
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

        let list:[AddressModel]  = getArrayFromJson(content: responseResult)

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
         tableView.registerNibWithTableViewCellName(name: addressListCell.nameOfClass)
 
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

extension addressListController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: dataList.count ,isdisplay: true)

        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressListCell", for: indexPath) as! addressListCell
        cell.selectionStyle = .none
        cell.model = dataList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        let controller = UIStoryboard.getaddressDetailController()
        controller.isadd = false
        controller.dateID = dataList[indexPath.row].id
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
