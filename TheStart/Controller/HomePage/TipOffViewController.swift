//
//  TipOffViewController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/15.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh

class TipOffViewController: BaseViewController,Requestable {

    
    
    var parentNavigationController: UINavigationController?
    var tableView:UITableView!
    
    var dataList = [TipOffModel]()
        
    var pubBtn:UIButton!
    var type = 1
    
    var isFromMine = false
    var isMypub = false
    var isMyCollect = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        loadData()
        createPubBtn()
        self.title = "黑人馆"
        
        // Do any additional setup after loading the view.
    }
    
    func createPubBtn() {
        
        pubBtn = UIButton.init()
        pubBtn.frame = CGRect.init(x: 0, y: 4, width: 60, height: 60)
        pubBtn.addTarget(self, action: #selector(pubBtnClick(_:)), for: .touchUpInside)
        pubBtn.setImage(UIImage.init(named: "tipOffPost"), for: .normal)
        
        let bgview = UIView.init()
        bgview.frame = CGRect.init(x: screenWidth - 100, y: screenHeight - 120 - 44, width: 60, height: 60)
        bgview.addSubview(pubBtn)
        
        self.view.addSubview(bgview)
        
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: bgview)
    }
    @objc func pubBtnClick(_ btn: UIButton){
    
        let controller = TipOffPostViewController()
        controller.articleType = 1
        controller.reloadBlock = {[weak self] () -> Void in
            self!.refreshList()
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func loadData(){
        if isMypub {
            let pathAndParams = HomeAPI.myArticleListPathAndParams(page: page, limit: limit)
            getRequest(pathAndParams: pathAndParams,showHUD: false)
        }else if isMyCollect{
        
        }else{
            let requestParams = HomeAPI.tipOffListPathAndParams(type:type, page: page, limit: pagenum)
            getRequest(pathAndParams: requestParams,showHUD:false)
        }
       
     

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

        dataList.append(contentsOf: list)
        if list.count < 10 {
            self.tableView.mj_footer?.endRefreshingWithNoMoreData()
        }
        self.tableView.reloadData()
    }
    
    func initTableView(){

        if isFromMine{
            tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - 44 - navigationHeight), style: .plain)
        }else{
            tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), style: .plain)

        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = ZYJColor.main
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 294;
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        tableView.registerNibWithTableViewCellName(name: TipOffListCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: TipOffListCell2.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: TipOffListCell1.nameOfClass)
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

extension TipOffViewController:UITableViewDataSource,UITableViewDelegate {
    
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
 
        let cell = tableView.dequeueReusableCell(withIdentifier: "TipOffListNoImgCell", for: indexPath) as! TipOffListNoImgCell
        cell.selectionStyle = .none
        cell.model = dataList[indexPath.row]
        return cell
 
        
    }
 
// 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let controller = TipOffDetailViewController()
         controller.dateID = dataList[indexPath.row].id
         controller.isFromMine = self.isMypub
         self.navigationController?.pushViewController(controller, animated: true)
    }
}
