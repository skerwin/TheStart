//
//  WorkerInfoViewController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/18.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh
import Reachability
import SnapKit
class WorkerInfoViewController: BaseViewController,Requestable {

    var tableView:UITableView!
    
    var headView:WorkerBaseInfo!
        
    var headerBgView:UIView!
    
    var footerView:ChatBtnView!
    
    var footerBgView:UIView!
    
    var dateID = 0
    
    var dataModel = JobModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "求职详情"
        loadData()
        initHeadView()
        initFooterView()
        initTableView()
        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        let requestParams = HomeAPI.workDetailPathAndParams(id: dateID)
        getRequest(pathAndParams: requestParams,showHUD:false)
    }
    
    
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
     }


    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        
         dataModel = Mapper<JobModel>().map(JSONObject: responseResult.rawValue)
         headView.configModel(model: dataModel!)
         self.tableView.reloadData()
    }
    
    func initHeadView(){
        headView = Bundle.main.loadNibNamed("WorkerBaseInfo", owner: nil, options: nil)!.first as? WorkerBaseInfo
        headView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 210)
        headView.delegate = self
        headerBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 210))
        headerBgView.backgroundColor = UIColor.clear
        headerBgView.addSubview(headView)
        
      }
    
    
    func initFooterView(){
        footerView = Bundle.main.loadNibNamed("ChatBtnView", owner: nil, options: nil)!.first as? ChatBtnView
        footerView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 85)
        footerView.delegate = self
        footerBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 85))
        footerBgView.backgroundColor = UIColor.clear
        footerBgView.addSubview(footerView)
        
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
        tableView.registerNibWithTableViewCellName(name: WorkerImgCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: WorkerInfoCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: WorkerVideoCell.nameOfClass)
        
        self.tableView.tableHeaderView = headerBgView
        tableView.tableFooterView = footerBgView
 
        
        view.addSubview(tableView)
        
    }
 
}
extension WorkerInfoViewController:WorkerBaseInfoDelegate {
    func WorkerCommunicateAction(){
        let noticeView = UIAlertController.init(title: "", message: "您确定拨打对方的联系电话吗？", preferredStyle: .alert)
         noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { [self] (action) in
 
            let urlstr = "telprompt://" + self.dataModel!.mobile
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
extension WorkerInfoViewController:ChatBtnViewDelegate {
    func sumbitAction() {
            let controller = UIStoryboard.getMessageController()
            self.navigationController?.pushViewController(controller, animated: true)
    }
 
}
extension WorkerInfoViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: notifyModelList.count ,isdisplay: true)

        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerInfoCell", for: indexPath) as! WorkerInfoCell
            cell.selectionStyle = .none
            cell.configCell(model: self.dataModel!, isjob: false)
            return cell
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerImgCell", for: indexPath) as! WorkerImgCell
            cell.model = dataModel
             cell.selectionStyle = .none
            return cell
           
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerVideoCell", for: indexPath) as! WorkerVideoCell
            cell.selectionStyle = .none
            cell.model = dataModel
            return cell
        }
      
        
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
