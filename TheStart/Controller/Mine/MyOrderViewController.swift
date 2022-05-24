//
//  MyOrderViewController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/11.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh

class MyOrderViewController: BaseViewController {

   
   var controllerArray : [UIViewController] = []
    
   var controller1:BuyOrderViewController!
   var controller2:SellOrderViewController!
 
 


   var pageMenuController: PMKPageMenuController? = nil
   var toTopHeight:CGFloat = 0 //pagemenu距顶部位置
   
   override func viewDidLoad() {
       super.viewDidLoad()
       
       self.title = "我的订单"
       controller1 = BuyOrderViewController()
       controller1.title = "已购买"
       controller1.parentNavigationController = self.navigationController
    
 
       controller2 = SellOrderViewController()
       controller2.title = "已售出"
       controller2.parentNavigationController = self.navigationController
      
       toTopHeight = navigationHeaderAndStatusbarHeight
       
       controllerArray.append(controller1)
       controllerArray.append(controller2)
      
       
       pageMenuController = PMKPageMenuController(controllers: controllerArray, menuStyle: .plain, menuColors:[colorWithHexString(hex: "A255FF")], startIndex: 1, topBarHeight: toTopHeight)
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
extension MyOrderViewController: PMKPageMenuControllerDelegate
{
   func pageMenuController(_ pageMenuController: PMKPageMenuController, willMoveTo viewController: UIViewController, at menuIndex: Int) {
   }
   
   func pageMenuController(_ pageMenuController: PMKPageMenuController, didMoveTo viewController: UIViewController, at menuIndex: Int) {
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
