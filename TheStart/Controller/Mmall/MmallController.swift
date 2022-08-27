//
//  MmallController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/14.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh

class MmallController: BaseViewController {

    
    var controllerArray : [UIViewController] = []
    var controller1:MuiscListController!
    
    var controller2:MuiscListController!
    
    var controller3:MuiscListController!
    
    var controller4:AuthorViewController!
    
    
 
 
    var pageMenuController: PMKPageMenuController? = nil
    var toTopHeight:CGFloat = 0 //pagemenu距顶部位置
    
    var rightBarButton:UIButton!
    
    var bgview:UIView!
    
    var selcetIndex = 0
    
    var ybPopupMenu: YBPopupMenu!
    
    var titles = ["全部","开场","颗粒爆点","套曲包","教学","其他",]

//    func createRightNavItem() {
//
//        rightBarButton = UIButton.init()
//        bgview = UIView.init()
//
//
//        rightBarButton.frame = CGRect.init(x: 0, y: 6, width: 66, height: 28)
//        rightBarButton.setTitle("会员免费", for: .normal)
//        bgview.frame = CGRect.init(x: 0, y: 0, width: 66, height: 44)
//
//        rightBarButton.addTarget(self, action: #selector(rightNavBtnClic(_:)), for: .touchUpInside)
//
//        rightBarButton.setTitleColor(.white, for: .normal)
//        rightBarButton.backgroundColor = colorWithHexString(hex: "#228CFC")
//        rightBarButton.layer.masksToBounds = true
//        rightBarButton.layer.cornerRadius = 5;
//        rightBarButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//
//        bgview.addSubview(rightBarButton)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: bgview)
//
//    }
//    @objc func rightNavBtnClic(_ btn: UIButton){
//        let controller = MuiscListController()
//        controller.isFreeZone = true
//        self.navigationController?.pushViewController(controller, animated: true)
//    }
    
    
    func createRightNavItem() {
        
        rightBarButton = UIButton.init()
        rightBarButton.frame = CGRect.init(x: 0, y: 100, width: 70, height: 28)
        rightBarButton.addTarget(self, action: #selector(rightNavBtnClic(_:)), for: .touchUpInside)
        //rightBarButton.setBackgroundImage(UIImage.init(named: "add"), for: .normal)
        //rightBarButton.setImage(UIImage.init(named: "add"), for: .normal)
        rightBarButton.setTitle("分类", for: .normal)
        rightBarButton.titleLabel?.textAlignment = .right
        rightBarButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightBarButton.setTitleColor(colorWithHexString(hex: "#228CFC"), for: .normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBarButton)
 
    }
    @objc func rightNavBtnClic(_ btn: UIButton){
        ybPopupMenu = YBPopupMenu.showRely(on: btn, titles: titles, icons: [], menuWidth: 125, delegate: self)
    }
    

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if checkMarketVer(){
           
       // }else{
          createRightNavItem()
       // }
       
        self.title = "音乐馆"
        // self.navigationController?.navigationBar.topItem?.title = ""
        
        
        controller1 = MuiscListController()
        controller1.title = "最新"
        controller1.isFreeZone = false
        controller1.order = 1
        controller1.type = 0
        controller1.parentNavigationController = self.navigationController
        
        
        controller2 = MuiscListController()
        controller2.title = "最热"
        controller2.isFreeZone = false
        controller2.order = 2
        controller1.type = 0
        controller2.parentNavigationController = self.navigationController
        
        
        controller3 = MuiscListController()
        controller3.title = "免费"
        controller3.isFreeZone = true
        controller3.order = 0
        controller1.type = 0
        controller3.parentNavigationController = self.navigationController
     
        controller4 = AuthorViewController()
        controller4.title = "作者"
        controller4.parentNavigationController = self.navigationController
        
       
 
        toTopHeight = navigationHeaderAndStatusbarHeight
        
        
        controllerArray.append(controller1)
        controllerArray.append(controller2)
        controllerArray.append(controller3)
        controllerArray.append(controller4)
       
        pageMenuController = PMKPageMenuController(controllers: controllerArray, menuStyle: .plain, menuColors:[colorWithHexString(hex: "A255FF")], startIndex: 0, topBarHeight: toTopHeight)
       pageMenuController?.delegate = self
       self.addChild(pageMenuController!)
       self.view.addSubview(pageMenuController!.view)
       pageMenuController?.didMove(toParent: self)
        
       
       
 
        // Do any additional setup after loading the view.
    }
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        //ischeck 是否审核  0 未审核  1  审核中  2 通过审核 3 审核为通过
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
        
    }
}
extension MmallController:YBPopupMenuDelegate{
    func ybPopupMenuDidSelected(at index: Int, ybPopupMenu: YBPopupMenu!) {
        ybPopupMenu.isHidden = true
        
        let vc = controllerArray[selcetIndex] as! MuiscListController
        if index == 4{
            vc.type = 5
            rightBarButton.setTitle(titles[5], for: .normal)
        }else if index == 5{
            vc.type = 4
            rightBarButton.setTitle(titles[4], for: .normal)
        }else{
            vc.type = index
            if index == 0{
                rightBarButton.setTitle("分类", for: .normal)
            }else{
                rightBarButton.setTitle(titles[index], for: .normal)
            }
            
        }
        vc.refreshList()
        
        
//        if index == 0{
//            let controller = WorkerPubViewController()
//            controller.pubType = 2
//            self.navigationController?.pushViewController(controller, animated: true)
//        }else{
//            let controller = WorkerPubViewController()
//            controller.pubType = 1
//            self.navigationController?.pushViewController(controller, animated: true)
//         }
     }
}
extension MmallController: PMKPageMenuControllerDelegate
{
    func pageMenuController(_ pageMenuController: PMKPageMenuController, willMoveTo viewController: UIViewController, at menuIndex: Int) {
    }
    
    func pageMenuController(_ pageMenuController: PMKPageMenuController, didMoveTo viewController: UIViewController, at menuIndex: Int) {
       
//        if menuIndex == 0{
//            self.navigationItem.rightBarButtonItem = nil
//        }else{
//            if checkMarketVer(){
//
//            }else{
//                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: bgview)
//            }
//            
//        }
    }
    
    func pageMenuController(_ pageMenuController: PMKPageMenuController, didPrepare menuItems: [PMKPageMenuItem]) {
        // XXX: For .hacka style
        var i: Int = 1
        for item: PMKPageMenuItem in menuItems {
            item.badgeValue = String(format: "%zd", i)
            i += 1
        }
    }
    
    func pageMenuController(_ pageMenuController: PMKPageMenuController, didSelect menuItem: PMKPageMenuItem, at menuIndex: Int) {
        print(menuIndex)
        selcetIndex = menuIndex
        if menuIndex == 3{
            rightBarButton.isHidden = true
        }else{
            let vc = controllerArray[selcetIndex] as! MuiscListController
            vc.type = 0
            vc.refreshList()
            rightBarButton.setTitle("分类", for: .normal)
            rightBarButton.isHidden = false
        }
        menuItem.badgeValue = nil // XXX: For .hacka style
    }
}


