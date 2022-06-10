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
    var controller2:AuthorViewController!
 
 
 
    var pageMenuController: PMKPageMenuController? = nil
    var toTopHeight:CGFloat = 0 //pagemenu距顶部位置
    
    var rightBarButton:UIButton!
    
    var bgview:UIView!

    func createRightNavItem() {
        
        rightBarButton = UIButton.init()
        bgview = UIView.init()
 
            
        rightBarButton.frame = CGRect.init(x: 0, y: 6, width: 66, height: 28)
        rightBarButton.setTitle("会员免费", for: .normal)
        bgview.frame = CGRect.init(x: 0, y: 0, width: 66, height: 44)
        
        rightBarButton.addTarget(self, action: #selector(rightNavBtnClic(_:)), for: .touchUpInside)
      
        rightBarButton.setTitleColor(.white, for: .normal)
        rightBarButton.backgroundColor = colorWithHexString(hex: "#228CFC")
        rightBarButton.layer.masksToBounds = true
        rightBarButton.layer.cornerRadius = 5;
        rightBarButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
     
        bgview.addSubview(rightBarButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: bgview)
        
    }

    @objc func rightNavBtnClic(_ btn: UIButton){
        let controller = MuiscListController()
        controller.isFreeZone = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createRightNavItem()
        self.title = "音乐馆"
        // self.navigationController?.navigationBar.topItem?.title = ""
        
        
        controller1 = MuiscListController()
        controller1.title = "音乐"
        controller1.parentNavigationController = self.navigationController
     
        controller2 = AuthorViewController()
        controller2.title = "作者"
        controller2.parentNavigationController = self.navigationController
       
 
        toTopHeight = navigationHeaderAndStatusbarHeight
        
        
        controllerArray.append(controller1)
        controllerArray.append(controller2)
       
        pageMenuController = PMKPageMenuController(controllers: controllerArray, menuStyle: .plain, menuColors:[colorWithHexString(hex: "A255FF")], startIndex: 0, topBarHeight: toTopHeight)
       pageMenuController?.delegate = self
       self.addChild(pageMenuController!)
       self.view.addSubview(pageMenuController!.view)
       pageMenuController?.didMove(toParent: self)
        
       createRightNavItem()
 
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
extension MmallController: PMKPageMenuControllerDelegate
{
    func pageMenuController(_ pageMenuController: PMKPageMenuController, willMoveTo viewController: UIViewController, at menuIndex: Int) {
    }
    
    func pageMenuController(_ pageMenuController: PMKPageMenuController, didMoveTo viewController: UIViewController, at menuIndex: Int) {
        //print(menuIndex)
        if menuIndex == 0{
            self.navigationItem.rightBarButtonItem = nil
        }else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: bgview)
        }
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
        menuItem.badgeValue = nil // XXX: For .hacka style
    }
}


