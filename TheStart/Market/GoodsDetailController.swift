//
//  GoodsDetailController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/25.
//

import UIKit
 

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh

class GoodsDetailController: BaseViewController,Requestable {

    
    var tableView:UITableView!
    
 
    var pubBtn:UIButton!
    
    
    var headView:GoodDetailHeader!
        
    var headerBgView:UIView!
    
    var footerView:ChatBtnView!
    
    var footerBgView:UIView!
    
    var dateID = 0
    
    var dataModel = GoodsModel()
 
    var type = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHeadView()
        initFooterView()
        loadData()
        initTableView()
        self.title = "大咖秀"
        // Do any additional setup after loading the view.
    }
    
    func initHeadView(){
        headView = Bundle.main.loadNibNamed("GoodDetailHeader", owner: nil, options: nil)!.first as? GoodDetailHeader
        headView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 340)
        //headView.delegate = self
        headerBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 340))
        headerBgView.backgroundColor = UIColor.clear
        headerBgView.addSubview(headView)
        
      }
    
    
    func initFooterView(){
        footerView = Bundle.main.loadNibNamed("ChatBtnView", owner: nil, options: nil)!.first as? ChatBtnView
        footerView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 85)
        footerView.chatBtn.setTitle("立即购买", for: .normal)
        footerView.delegate = self
        footerBgView = UIView.init(frame:  CGRect.init(x: 0, y: screenHeight - 85, width: screenWidth, height: 85))
        footerBgView.backgroundColor = UIColor.clear
        footerBgView.addSubview(footerView)
        
        
        self.view.addSubview(footerBgView)
      }
    
    func loadData(){
        let requestParams = HomeAPI.goodsInfoPathAndParams(id: dateID)
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

        dataModel = Mapper<GoodsModel>().map(JSONObject: responseResult.rawValue)
        headView.configModel(model: dataModel!)
        self.tableView.reloadData()
    }
    
    func initTableView(){
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - 80), style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = ZYJColor.main
        
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 240;
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
         tableView.registerNibWithTableViewCellName(name: GoodDetailCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: GoodeDetailLineewCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: GoodDetailCell.nameOfClass)
        
        let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
        tableView.mj_header = addressHeadRefresh
 
        
        tableView.registerNibWithTableViewCellName(name: WorkerInfoCell.nameOfClass)
        
        self.tableView.tableHeaderView = headerBgView
        //tableView.tableFooterView = footerBgView
        
        view.addSubview(tableView)
 
    }
  
    
    @objc func refreshList() {
        self.tableView.mj_footer?.resetNoMoreData()
        page = 1
        self.loadData()
    }
    
 
}
extension GoodsDetailController:ChatBtnViewDelegate {
    func sumbitAction() {
        let controller = UIStoryboard.getGoodsCashDeskController()
        controller.paytype = .chargeVip
        controller.priceStr = "98.00"
        self.present(controller, animated: true)
    }
 
}
extension GoodsDetailController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: dataList.count ,isdisplay: true)

        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0{
            print("model.content.html2String")
           // print(model.content.html2String)
            
            print(dataModel!.content.html2String.count)
            if dataModel!.content.containsStr(find: "<img"){
                let cell = tableView.dequeueReusableCell(withIdentifier: "GoodDetailCell", for: indexPath) as! GoodDetailCell
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerInfoCell", for: indexPath) as! WorkerInfoCell
                cell.selectionStyle = .none
                cell.configGoodsCell(model: self.dataModel!, num: 0)
                return cell
            }
            
           
        }else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerInfoCell", for: indexPath) as! WorkerInfoCell
            cell.selectionStyle = .none
            cell.configGoodsCell(model: self.dataModel!, num: 1)
            return cell
        }else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerInfoCell", for: indexPath) as! WorkerInfoCell
            cell.selectionStyle = .none
            cell.configGoodsCell(model: self.dataModel!, num: 2)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "GoodeDetailLineewCell", for: indexPath) as! GoodeDetailLineewCell
            cell.selectionStyle = .none
            return cell
         }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            return 12
        } 
        return UITableView.automaticDimension
     }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
}
