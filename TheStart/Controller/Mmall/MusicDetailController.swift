//
//  MusicDetailController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/05.
//
 
import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh
import Reachability
import SnapKit

class MusicDetailController: BaseViewController,Requestable{

    var tableView:UITableView!
    
    var headView:MusicDetailHeader!
        
    var headerBgView:UIView!
    
    var footerView:ChatBtnView!
    
    var footerBgView:UIView!
    
    var dateID = 0
    
    var dataModel = AudioModel()
    
    var rightBarButton:UIButton!
    
    var isCollect = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "音乐详情"
        createRightNavItem() 
        loadData()
        initHeadView()
        initFooterView()
        initTableView()
        // Do any additional setup after loading the view.
    }
    func loadData(){
        let requestParams = HomeAPI.audioDetailPathAndParams(id: dateID)
        getRequest(pathAndParams: requestParams,showHUD:false)
    }
    
    func createRightNavItem() {
        
        rightBarButton = UIButton.init()
        let bgview = UIView.init()
 
        rightBarButton.frame = CGRect.init(x: 0, y: 0, width: 28, height: 28)
        bgview.frame = CGRect.init(x: 0, y: 0, width: 28, height: 28)
        
        rightBarButton.addTarget(self, action: #selector(rightNavBtnClic(_:)), for: .touchUpInside)
        
        rightBarButton.setBackgroundImage(UIImage.init(named: "shoucangs"), for: .normal)
     
        bgview.addSubview(rightBarButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: bgview)
        
    }

    @objc func rightNavBtnClic(_ btn: UIButton){
        
        if isCollect == 1{
            let requestParams = HomeAPI.delAudioCollectPathAndParams(id: dateID)
            postRequest(pathAndParams: requestParams,showHUD:false)
        }else{
            let requestParams = HomeAPI.audioCollectPathAndParams(id: dateID)
            postRequest(pathAndParams: requestParams,showHUD:false)
        }
     }
    func changeCollectBtn(){
        if isCollect == 1{
            rightBarButton.setBackgroundImage(UIImage.init(named: "shoucangzhong"), for: .normal)
        }else{
            rightBarButton.setBackgroundImage(UIImage.init(named: "shoucangs"), for: .normal)
        }
    }
    
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
     }


    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        
        if requestPath == HomeAPI.audioCollectPath{
            isCollect = responseResult["if_collect"].intValue
            changeCollectBtn()
            showOnlyTextHUD(text: "收藏成功")
        }else if requestPath == HomeAPI.delAudioCollectPath{
            isCollect = responseResult["if_collect"].intValue
            changeCollectBtn()
            showOnlyTextHUD(text: "取消收藏成功")
        }else{
            dataModel = Mapper<AudioModel>().map(JSONObject: responseResult.rawValue)
            headView.configModel(model: dataModel!)
             self.tableView.reloadData()
            isCollect = dataModel!.userCollect
            changeCollectBtn()
        }
        
      
    }
    
    func initHeadView(){
        headView = Bundle.main.loadNibNamed("MusicDetailHeader", owner: nil, options: nil)!.first as? MusicDetailHeader
        headView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 200)
        headerBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 200))
        headerBgView.backgroundColor = UIColor.clear
        headerBgView.addSubview(headView)
        
      }
    
    
    func initFooterView(){
        footerView = Bundle.main.loadNibNamed("ChatBtnView", owner: nil, options: nil)!.first as? ChatBtnView
        footerView.chatBtn.setTitle("立即购买", for: .normal)
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
extension MusicDetailController:ChatBtnViewDelegate {
    func sumbitAction() {
            //let controller = UIStoryboard.getMessageController()
           // self.navigationController?.pushViewController(controller, animated: true)
    }
 
}
 
extension MusicDetailController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: notifyModelList.count ,isdisplay: true)
        
        if dataModel?.name == ""{
            return 0
        }
        if dataModel?.audio_path == "" && dataModel?.images.count == 0{
            return 1
        }
        
        if dataModel?.audio_path == "" || dataModel?.images.count == 0{
            return 2
        }

        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerInfoCell", for: indexPath) as! WorkerInfoCell
            cell.selectionStyle = .none
            cell.configAudioCell(model: dataModel!)
            return cell
        }else if indexPath.row == 1{
            
            if dataModel?.images.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerVideoCell", for: indexPath) as! WorkerVideoCell
                cell.selectionStyle = .none
                cell.configAudioCell(model: dataModel!)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerImgCell", for: indexPath) as! WorkerImgCell
                cell.selectionStyle = .none
                cell.configAudioCell(model: dataModel!)
                return cell
            }
           
           
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerVideoCell", for: indexPath) as! WorkerVideoCell
            cell.selectionStyle = .none
            cell.configAudioCell(model: dataModel!)
            return cell
        }
      
        
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
}
