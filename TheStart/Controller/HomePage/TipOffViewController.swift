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
    
    var dataRecord = [TipOffModel]()
        
    var pubBtn:UIButton!
    
    var type = 1
    var type1 = 0 //嘿人嘿场类型
    
    var isFromMine = false
    var isMypub = false
    var isMyCollect = false
    
    var headerView:TipOffListHeadView!
    var headerViewbgView:UIView!
    
    var isRecorde = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        loadData()
        if isFromMine{
            
        }else{
            createPubBtn()
            if type == 1{
                initHeaderView()
            }
        }
      
        self.title = "黑人馆"
        
        // Do any additional setup after loading the view.
    }
 
    func initHeaderView(){
        headerView = Bundle.main.loadNibNamed("TipOffListHeadView", owner: nil, options: nil)!.first as? TipOffListHeadView
        headerView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 34)
        headerView.delegate = self
        //headerView.parentNavigationController = self.navigationController
 
        headerViewbgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 34))
        headerViewbgView.backgroundColor = ZYJColor.barColor
        headerViewbgView.addSubview(headerView)
        self.view.addSubview(headerViewbgView)
       }
    
    func createPubBtn() {
        
        pubBtn = UIButton.init()
        pubBtn.frame = CGRect.init(x: 0, y: 4, width: 60, height: 60)
        pubBtn.addTarget(self, action: #selector(pubBtnClick(_:)), for: .touchUpInside)
        pubBtn.setImage(UIImage.init(named: "tipOffPost"), for: .normal)
        
        let bgview = UIView.init()
        bgview.frame = CGRect.init(x: screenWidth - 100, y: screenHeight - navigationHeaderAndStatusbarHeight - 44 - bottomNavigationHeight - 34, width: 60, height: 60)
        bgview.addSubview(pubBtn)
        
        self.view.addSubview(bgview)
 
     }
    @objc func pubBtnClick(_ btn: UIButton){
 
        let controller = TipOffPostViewController()
        controller.articleType = self.type
        controller.reloadBlock = {[weak self] () -> Void in
            self!.refreshList()
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func loadData(){
        if isMypub {
            let pathAndParams = HomeAPI.myArticleListPathAndParams(page: page, limit: limit)
            getRequest(pathAndParams: pathAndParams,showHUD: true)
        }else if isMyCollect{
        
        }else{
            let requestParams = HomeAPI.tipOffListPathAndParams(type:type, type1:type1,page: page, limit: pagenum)
            getRequest(pathAndParams: requestParams,showHUD:true)
 
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

        if requestPath == HomeAPI.tipOffRecordPath{
            let list:[TipOffModel]  = getArrayFromJson(content: responseResult)

            dataRecord.append(contentsOf: list)
            if list.count < 10 {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
            self.tableView.reloadData()
        }else{
            let list:[TipOffModel]  = getArrayFromJson(content: responseResult)

            dataList.append(contentsOf: list)
            if list.count < 10 {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
            self.tableView.reloadData()
        }
      
    }
    
    func initTableView(){

        if isFromMine{
            tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - 44 - navigationHeight), style: .plain)
        }else{
            if self.type == 1{
                tableView = UITableView(frame: CGRect(x: 0, y: 34, width: screenWidth, height: screenHeight - navigationHeaderAndStatusbarHeight - 34 - bottomNavigationHeight), style: .plain)
            }else{
                tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - navigationHeaderAndStatusbarHeight - bottomNavigationHeight), style: .plain)
            }
 
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
        tableView.registerNibWithTableViewCellName(name: TipOffRecordeCell.nameOfClass)
        
 
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
        
        if isRecorde{
            self.tableView.mj_footer?.resetNoMoreData()
            dataRecord.removeAll()
            page = 1
            let requestParams = HomeAPI.tipOffRecordPathAndParams(page: page, limit: limit)
            postRequest(pathAndParams: requestParams,showHUD:false)
        }else{
            self.tableView.mj_footer?.resetNoMoreData()
            dataList.removeAll()
            page = 1
            self.loadData()
        }
       
    }
    
 
}

extension TipOffViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: dataList.count ,isdisplay: true)
        if isRecorde{
            return dataRecord.count
        }else{
            return dataList.count
        }
        
 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if isRecorde{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TipOffRecordeCell", for: indexPath) as! TipOffRecordeCell
            cell.nameLbael.text = dataRecord[indexPath.row].name
            if dataRecord[indexPath.row].type1 == 1{
                cell.tipLabel.text = "嘿人"
            }else if dataRecord[indexPath.row].type1 == 2{
                cell.tipLabel.text = "嘿店"
            }else {
                cell.tipLabel.text = "其他"
            }
            
            cell.selectionStyle = .none
            return cell
        
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TipOffListNoImgCell", for: indexPath) as! TipOffListNoImgCell
            cell.selectionStyle = .none
            cell.model = dataList[indexPath.row]
            return cell
        }
 
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isRecorde{
            return 44
        }else{
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let controller = TipOffDetailViewController()
        if isRecorde{
            controller.dateID = dataRecord[indexPath.row].id
        }else{
            controller.dateID = dataList[indexPath.row].id
        }
          controller.isFromMine = self.isMypub
         self.navigationController?.pushViewController(controller, animated: true)
    }
}
extension TipOffViewController:TipOffListHeadViewDelegate {
    func allBtnAction() {
        isRecorde = false
        type1 = 0
        refreshList()
    }
    
    func personBtnAction() {
        isRecorde = false
        type1 = 1
        refreshList()
    }
    
    func storebtnAction() {
        isRecorde = false
        type1 = 2
        refreshList()
    }
    
    func recordebtnAction() {
        
        isRecorde = true
        refreshList()
        
        
       // self.tableView.reloadData()
        
        
    }
    
    
}

