//
//  WorkerInfoViewController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/18.
//

import UIKit

class WorkerInfoViewController: BaseViewController {

    var tableView:UITableView!
    
    var headView:WorkerBaseInfo!
        
    var headerBgView:UIView!
    
    var footerView:ChatBtnView!
    
    var footerBgView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "找场详情"
        initHeadView()
        initFooterView()
        initTableView()
        // Do any additional setup after loading the view.
    }
    func initHeadView(){
        headView = Bundle.main.loadNibNamed("WorkerBaseInfo", owner: nil, options: nil)!.first as? WorkerBaseInfo
        headView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 186)
        
        headerBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 186))
        headerBgView.backgroundColor = UIColor.clear
        headerBgView.addSubview(headView)
        
      }
    
    
    func initFooterView(){
        footerView = Bundle.main.loadNibNamed("ChatBtnView", owner: nil, options: nil)!.first as? ChatBtnView
        footerView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 85)
        
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
//        let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
//        tableView.mj_header = addressHeadRefresh
//         let footerRefresh = GmmMJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(pullRefreshList))
//        tableView.mj_footer = footerRefresh
        
        view.addSubview(tableView)
        
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
            return cell
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerImgCell", for: indexPath) as! WorkerImgCell
            cell.selectionStyle = .none
            return cell
           
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerVideoCell", for: indexPath) as! WorkerVideoCell
            cell.selectionStyle = .none
            return cell
        }
      
        
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let controller = TipOffDetailViewController()
      
         self.navigationController?.pushViewController(controller, animated: true)
    }
}
