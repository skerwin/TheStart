//
//  HomePageController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/14.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh
import SDCycleScrollView

 
class HomePageController: BaseViewController,Requestable {

    
    var tableView:UITableView!
    
    var dataList = [String]()
    
    var advertisementView:SDCycleScrollView!
    var bannerView:UIView!
    var adverModelList = [AdverModel]()
    
    let topAdvertisementViewHeight = screenWidth * 0.40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        self.view.backgroundColor = ZYJColor.main
        loadData()
       
        
        self.title = "首页"
        // Do any additional setup after loading the view.
    }
    
    func loadData(){

        
        
        
        let workParams = HomeAPI.workCategoryPathAndParams()
        getRequest(pathAndParams: workParams,showHUD: false)
        
        
        
        let salaryParams = HomeAPI.salaryPathAndParams()
        getRequest(pathAndParams: salaryParams,showHUD: false)
        
        
//        let testParas = HomeAPI.testPathAndParams()
//        getRequest(pathAndParams: testParas,showHUD:false)
        //getRequest(pathAndParams: testParas, showHUD: <#T##Bool#>, needCache: <#T##Bool#>)
        //postRequest(pathAndParams: testParas,showHUD: true)
        
        
    }
    
    func getAdvertisementView(imageArr:[AdverModel]) -> UIView {
        
        bannerView = UIView.init(frame:  CGRect.init(x: 0, y:0 , width: screenWidth, height: topAdvertisementViewHeight))
 
//        var imageArrTemp = [String]()
//        if imageArr.count == 0{
//            return UIView()
//        }else{
//            for model in imageArr {
//                imageArrTemp.append(model.image)
//            }
//        }
//
        
        SDCycleScrollView.clearImagesCache()
//        advertisementView = SDCycleScrollView.init(frame: CGRect.init(x: 0, y: 0 , width: screenWidth, height: topAdvertisementViewHeight), imageURLStringsGroup:imageArrTemp)
        advertisementView = SDCycleScrollView.init(frame: CGRect.init(x: 0, y: 0 , width: screenWidth, height: topAdvertisementViewHeight), imageNamesGroup: [UIImage.init(named: "111222.jpg")!,UIImage.init(named: "111222.jpg")!,UIImage.init(named: "111222.jpg")!])
        
        if advertisementView == nil{
            return UIView() as! SDCycleScrollView
       
        }
        
        advertisementView.pageControlAliment = SDCycleScrollViewPageContolAliment(rawValue: 1)
        advertisementView.pageControlStyle = SDCycleScrollViewPageContolStyle(rawValue: 1)
        //pageControlBottomOffset
        advertisementView.delegate = self
        
        advertisementView.layer.cornerRadius = 5;
        advertisementView.layer.masksToBounds = true;
        
        
        
        bannerView.addSubview(advertisementView)
        return bannerView
    }
    
    func initTableView(){
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = ZYJColor.main
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 240;
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.registerNibWithTableViewCellName(name: GuideCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: HomeSubscribeCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: JobViewCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: HomeJobCell.nameOfClass)
        tableView.tableHeaderView = getAdvertisementView(imageArr: adverModelList)
        view.addSubview(tableView)
        tableView.tableFooterView = UIView()
      
    }
 
}
extension HomePageController:SDCycleScrollViewDelegate{
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
//        if adverModelList[index].url == ""{
//            return
//        }
//        let controller = AdverController()
//        controller.urlString = adverModelList[index].url
//        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
extension HomePageController:GuideCellDelegate{
    func findWorkerViewAction() {
        let controller = WorkListViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func findJobViewAction() {
        let controller = JobListViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tipOffVIewAction() {
        let controller = TipOffMenuPageController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func superManViewAction() {
        let controller = SuperManListController()
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
 
}


extension HomePageController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: notifyModelList.count ,isdisplay: true)

        if section == 2{
            return 10
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            return UIView()
        }else{
            let sectionView = Bundle.main.loadNibNamed("HomeRankHeaderView", owner: nil, options: nil)!.first as! HomeRankHeaderView
            sectionView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 44)
            
            if section == 1{
                sectionView.name.text = "牛人找场"
            }else{
                sectionView.name.text = "夜场寻人"
            }
            return sectionView
            
        }
      
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return 44
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let section = indexPath.section
        if section == 0{
            return 145
        }else if section == 1{
            return 102
        }else{
            return 109
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = indexPath.section
        if section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "GuideCell", for: indexPath) as! GuideCell
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }else if section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSubscribeCell", for: indexPath) as! HomeSubscribeCell
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeJobCell", for: indexPath) as! HomeJobCell
            cell.selectionStyle = .none
            return cell
        }
       
    }
    
   
}

//
//
//func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//
//    let row = indexPath.row
//    if row == 0{

//    }else if row == 1{

//    }else if row == 2{

//    }else if row == 3{
//        let controller = TipOffPostViewController()
//        self.navigationController?.pushViewController(controller, animated: true)
//    }else if row == 4{
//        let controller = UIStoryboard.getMineViewController()
//        self.navigationController?.pushViewController(controller, animated: true)
//    }else if row == 5{
//        let controller = JobInfoViewController()
//        self.navigationController?.pushViewController(controller, animated: true)
//    }else if row == 6{
//        let controller = MuiscListController()
//        self.navigationController?.pushViewController(controller, animated: true)
//    }else if row == 7{
//        let controller = AuthorViewController()
//        self.navigationController?.pushViewController(controller, animated: true)
//    }else if row == 8{
//        let controller = PubMusicController()
//        self.navigationController?.pushViewController(controller, animated: true)
 
//    else if row == 11{
//        let controller = UIStoryboard.getFeedBackController()
//        self.navigationController?.pushViewController(controller, animated: true)
//    }
//    else if row == 12{
//        let controller = UIStoryboard.getPersonsInfoController()
//        self.navigationController?.pushViewController(controller, animated: true)
//    } else if row == 13{
//        let controller = UIStoryboard.getMessageController()
//        self.navigationController?.pushViewController(controller, animated: true)
//    }else if row == 14{
//        let controller = ContactListController()
//        self.navigationController?.pushViewController(controller, animated: true)
//    }
//
//    else{
//        let controller = AuthorViewController()
//        self.navigationController?.pushViewController(controller, animated: true)
//    }
// }
//
//
//func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
//{
//
//    let row = indexPath.row
//    let cell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath) as! testCell
//    cell.selectionStyle = .none
//    if row == 0{
//        cell.nameLabel.text = "黑人馆"
//    }else if row == 1{
//        cell.nameLabel.text = "找场详情"
//    }else if row == 2{
//        cell.nameLabel.text = "找场发布"
//    }else if row == 3{
//        cell.nameLabel.text = "发布黑料"
//    }else if row == 4{
//        cell.nameLabel.text = "个人中心"
//    }else if row == 5{
//        cell.nameLabel.text = "找人详情"
//    }else if row == 6{
//        cell.nameLabel.text = "音乐馆"
//    }else if row == 7{
//        cell.nameLabel.text = "作者馆"
//    }else if row == 8{
//        cell.nameLabel.text = "发布音乐"
//    }else if row == 9{
//        cell.nameLabel.text = "工作列表"
//    }
//    else if row == 10{
//        cell.nameLabel.text = "求职者列表"
//    }
//    else if row == 11{
//        cell.nameLabel.text = "意见反馈"
//    } else if row == 12{
//        cell.nameLabel.text = "个人信息设置"
//    }else if row == 13{
//        cell.nameLabel.text = "聊天页面"
//    }
//    else if row == 14{
//        cell.nameLabel.text = "聊天列表"
//    }
//
//
//
//    return cell
//
//
//}
 
