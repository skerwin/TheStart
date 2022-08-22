//
//  MyTalentedController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/08/22.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh
import Reachability
import SnapKit
import WMZDialog

class MyTalentedController: BaseViewController,Requestable{
    
    var tableView:UITableView!
 
    var headerBgView:UIView!
 
    var authorId = 333
   
    var parentNavigationController: UINavigationController?
 
 
    var userModel = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "才艺展示"
       //  initHeadView()
         initTableView()
     }
 
 
    func loadData(){
        let requestParams = HomeAPI.authorDetailPathAndParams(id: authorId)
        postRequest(pathAndParams: requestParams,showHUD:false)
    }

    override func onFailure(responseCode: String, description: String, requestPath: String) {
        DialogueUtils.dismiss()
        DialogueUtils.showError(withStatus: description)
     
    }
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
 
        userModel = Mapper<UserModel>().map(JSONObject: responseResult.rawValue)
       
    }
 
 
   
    
    func initTableView(){
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - 188 - navigationHeaderAndStatusbarHeight - 44), style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = ZYJColor.main
        
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 240;
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.registerNibWithTableViewCellName(name: WorkerImgCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: MyintroLogoCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: WorkerVideoCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: VideoBalankCell.nameOfClass)

         //self.tableView.tableHeaderView = headerBgView
        view.addSubview(tableView)
     }
 
}
 
 

extension MyTalentedController:UITableViewDataSource,UITableViewDelegate {
    
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
              if userModel!.images.count == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "VideoBalankCell", for: indexPath) as! VideoBalankCell
                cell.zanwu.text = "暂无图片资料"
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerImgCell", for: indexPath) as! WorkerImgCell
                cell.configUserCell(model: userModel!)
                cell.selectionStyle = .none
                return cell
            }
             
        }else if indexPath.row == 1{
 
             if userModel!.video_path == ""{

                 let cell = tableView.dequeueReusableCell(withIdentifier: "VideoBalankCell", for: indexPath) as! VideoBalankCell
                 cell.selectionStyle = .none
                 cell.zanwu.text = "暂无视频资料"
                 return cell
             }else{
                 let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerVideoCell", for: indexPath) as! WorkerVideoCell
                 cell.selectionStyle = .none
                 cell.configUserCell(model: userModel!)
                 return cell
             }
         }else{
             if userModel!.logo == ""{

                 let cell = tableView.dequeueReusableCell(withIdentifier: "VideoBalankCell", for: indexPath) as! VideoBalankCell
                 cell.selectionStyle = .none
                 cell.zanwu.text = "用户暂无上传logo"
                 return cell
             }else{
                 let cell = tableView.dequeueReusableCell(withIdentifier: "MyintroLogoCell", for: indexPath) as! MyintroLogoCell
                 cell.selectionStyle = .none
                 cell.logoimg.displayImageWithURL(url: userModel?.logo)
                 return cell
             }
             
         }
 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2{
            return 148
            
        }else{
            return UITableView.automaticDimension
        }
    }
    
}
