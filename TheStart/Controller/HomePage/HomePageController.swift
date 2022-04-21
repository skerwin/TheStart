//
//  HomePageController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/14.
//

import UIKit
import SwiftyJSON
 
class HomePageController: BaseViewController,Requestable {

    
    var tableView:UITableView!
    
    var dataList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        initTableView()
        self.title = "启程APP"
        // Do any additional setup after loading the view.
    }
    
    func loadData(){

        let pathAndParams = HomeAPI.departmenListPathAndParams()
        postRequest(pathAndParams: pathAndParams,showHUD: false)
        
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
        tableView.registerNibWithTableViewCellName(name: testCell.nameOfClass)
 
        
        view.addSubview(tableView)
        tableView.tableFooterView = UIView()
      
    }
 
}

extension HomePageController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: notifyModelList.count ,isdisplay: true)

        return 14
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath) as! testCell
        cell.selectionStyle = .none
        if row == 0{
            cell.nameLabel.text = "黑人馆"
        }else if row == 1{
            cell.nameLabel.text = "找场详情"
        }else if row == 2{
            cell.nameLabel.text = "找场发布"
        }else if row == 3{
            cell.nameLabel.text = "发布黑料"
        }else if row == 4{
            cell.nameLabel.text = "个人中心"
        }else if row == 5{
            cell.nameLabel.text = "找人详情"
        }else if row == 6{
            cell.nameLabel.text = "音乐馆"
        }else if row == 7{
            cell.nameLabel.text = "作者馆"
        }else if row == 8{
            cell.nameLabel.text = "发布音乐"
        }else if row == 9{
            cell.nameLabel.text = "工作列表"
        }
        else if row == 10{
            cell.nameLabel.text = "求职者列表"
        }
        else if row == 11{
            cell.nameLabel.text = "意见反馈"
        } else if row == 12{
            cell.nameLabel.text = "个人信息设置"
        }else if row == 13{
            cell.nameLabel.text = "聊天页面"
        }
        
        
        
        return cell
 
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 44

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
 
        let row = indexPath.row
        if row == 0{
            let controller = TipOffViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }else if row == 1{
            let controller = WorkerInfoViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }else if row == 2{
            let controller = WorkerPubViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }else if row == 3{
            let controller = TipOffPostViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }else if row == 4{
            let controller = UIStoryboard.getMineViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }else if row == 5{
            let controller = JobInfoViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }else if row == 6{
            let controller = MuiscListController()
            self.navigationController?.pushViewController(controller, animated: true)
        }else if row == 7{
            let controller = AuthorViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }else if row == 8{
            let controller = PubMusicController()
            self.navigationController?.pushViewController(controller, animated: true)
        }else if row == 9{
            let controller = JobListViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else if row == 10{
            let controller = WorkListViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else if row == 11{
            let controller = UIStoryboard.getFeedBackController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else if row == 12{
            let controller = UIStoryboard.getPersonsInfoController()
            self.navigationController?.pushViewController(controller, animated: true)
        } else if row == 13{
            let controller = UIStoryboard.getMessageController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        
        else{
            let controller = AuthorViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
     }
}




 
