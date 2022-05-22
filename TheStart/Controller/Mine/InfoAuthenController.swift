//
//  InfoAuthenController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/22.
//

 
import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh

class InfoAuthenController: BaseViewController {

    
    var controllerArray : [UIViewController] = []
    var controller1:AuthenController!
    var controller2:MusicianAuthorController!
    
    var controller3:AuthenSuuccessController!
    var controller4:AuthenSuuccessController!
 
    var isShimin = false
    var isAudio = false
    
    var pageMenuController: PMKPageMenuController? = nil
    var toTopHeight:CGFloat = 0 //pagemenu距顶部位置
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "信息认证"
        // self.navigationController?.navigationBar.topItem?.title = ""
        
        
        controller1 = UIStoryboard.getAuthenController()
        controller1.title = "实名认证"
 
        controller2 = MusicianAuthorController()
        controller2.title = "音乐人认证"
        
        controller3 = UIStoryboard.getAuthenSuuccessController()
        controller3.title = "实名认证"
        controller3.titlestr = "您已通过实名认证"
        
        controller4 = UIStoryboard.getAuthenSuuccessController()
        controller4.title = "音乐人认证"
        controller4.titlestr = "您已通过音乐人认证"
 
 
        toTopHeight = navigationHeaderAndStatusbarHeight
        
        if isShimin{
            if isAudio{
                controllerArray.append(controller3)
                controllerArray.append(controller4)
            }else{
                controllerArray.append(controller3)
                controllerArray.append(controller2)
            }
          
        }else{
            if isAudio{
                controllerArray.append(controller1)
                controllerArray.append(controller4)
            }else{
                controllerArray.append(controller1)
                controllerArray.append(controller2)
            }
           
        }
        
       
       
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
extension InfoAuthenController: PMKPageMenuControllerDelegate
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


