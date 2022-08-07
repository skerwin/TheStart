//
//  MyIntroController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/08/22.
//
 import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh

class MyIntroController: BaseViewController,Requestable {

    
    var tableView:UITableView!
    
    var parentNavigationController: UINavigationController?
    var userModel = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
         // Do any additional setup after loading the view.
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
        tableView.registerNibWithTableViewCellName(name: MyIntroCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: VideoBalankCell.nameOfClass)

         view.addSubview(tableView)
        tableView.tableFooterView = UIView()
      
    }
 
 
}

extension MyIntroController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: dataList.count ,isdisplay: true)

        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if userModel!.if_open == 0 && userModel?.uid != getUserId(){

            
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoBalankCell", for: indexPath) as! VideoBalankCell
            cell.selectionStyle = .none
            cell.zanwu.text = "此作者暂未公开展示个人信息，看看其他人吧"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyIntroCell", for: indexPath) as! MyIntroCell
            cell.selectionStyle = .none
            cell.configModel(model: self.userModel!)
            return cell
        }
        
        
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if userModel!.if_open == 0 && userModel?.uid != getUserId(){
            return 150
        }else{
            return 338
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}
