//
//  MyHomePageController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/08/21.
//
import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh

class MyHomePageController: BaseViewController,Requestable {

    
    var controllerArray : [UIViewController] = []
    var controller1:MyIntroController!
    var controller2:MyTalentedController!
    var controller3:AuthorDetailController!
    
    
    var isFromMine = false
 
  
    var pageMenuController: PMKPageMenuController? = nil
    var toTopHeight:CGFloat = 188 //pagemenu距顶部位置
    var bgview:UIView!
    
    var headView:PersonHomePageHeader!
    var headerBgView:UIView!
    
    var parentNavigationController: UINavigationController?
 
    var dataList = [AudioModel]()
    
    var userModel = UserModel()
    
    var rightBarButton:UIButton!
    var isCollect = 0
    
    var authorId = 0
  
    func initHeadView(){
        headView = Bundle.main.loadNibNamed("PersonHomePageHeader", owner: nil, options: nil)!.first as? PersonHomePageHeader
        headView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height:188)
        //headView.delegate = self
        
        headerBgView = UIView.init(frame:  CGRect.init(x: 0, y: navigationHeaderAndStatusbarHeight, width: screenWidth, height: 188))
        headerBgView.backgroundColor = UIColor.red
        headerBgView.addSubview(headView)
 
        self.view.addSubview(headerBgView)
        
    }
    func initPageView(){
        controller1 = MyIntroController()
        controller1.title = "介绍"
        controller1.userModel = self.userModel
        controller1.parentNavigationController = self.navigationController
     
        controller2 = MyTalentedController()
        controller2.userModel = self.userModel
        controller2.title = "才艺展示"
        controller2.parentNavigationController = self.navigationController
       
        controller3 = AuthorDetailController()
        controller3.title = "作品集"
        controller3.parentNavigationController = self.navigationController
        controller3.dataList = self.dataList
 
        
        controllerArray.append(controller1)
        controllerArray.append(controller2)
        controllerArray.append(controller3)
       
        pageMenuController = PMKPageMenuController(controllers: controllerArray, menuStyle: .plain, menuColors:[colorWithHexString(hex: "A255FF")], startIndex: 0, topBarHeight: toTopHeight)
        pageMenuController?.delegate = self
        self.addChild(pageMenuController!)
        self.view.addSubview(pageMenuController!.view)
        pageMenuController?.didMove(toParent: self)
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
        
        let requestParams = HomeAPI.authorCollectionPathAndParams(musician_id: authorId)
        postRequest(pathAndParams: requestParams,showHUD:false)
     }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createRightNavItem()
        loadData()
        initHeadView()
        if isFromMine {
            self.title = "我的主页"
        }else{
            self.title = "他/她的主页"
        }
        
        toTopHeight = navigationHeaderAndStatusbarHeight + 188
 
        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        
        if isFromMine {
            let requestParams = HomeAPI.userinfoPathAndParam()
            getRequest(pathAndParams: requestParams,showHUD:false)
        }else{
            if authorId == 0{
                authorId = getUserId()
            }
            if authorId == getUserId(){
                let requestParams = HomeAPI.userinfoPathAndParam()
                getRequest(pathAndParams: requestParams,showHUD:false)
            }else{
                let requestParams = HomeAPI.authorDetailPathAndParams(id: authorId)
                postRequest(pathAndParams: requestParams,showHUD:false)
            }
           
        }
     }

    override func onFailure(responseCode: String, description: String, requestPath: String) {
        DialogueUtils.dismiss()
        DialogueUtils.showError(withStatus: description)
     
    }
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
 
        if requestPath == HomeAPI.authorCollectionPath{
            isCollect = responseResult["if_collection"].intValue
            if isCollect == 1{
                rightBarButton.setBackgroundImage(UIImage.init(named: "shoucangzhong"), for: .normal)
                showOnlyTextHUD(text: "收藏成功")
            }else{
                rightBarButton.setBackgroundImage(UIImage.init(named: "shoucangs"), for: .normal)
                showOnlyTextHUD(text: "取消收藏")
            }
        }else{
            userModel = Mapper<UserModel>().map(JSONObject: responseResult.rawValue)
            dataList = getArrayFromJsonByArrayName(arrayName: "audio_list", content: responseResult)
            if userModel?.music_num == 0{
                userModel?.music_num = dataList.count
            }
            headView.configModel(model: userModel!)
            initPageView()
        }
  }
 

  
}
extension MyHomePageController: PMKPageMenuControllerDelegate
{
    func pageMenuController(_ pageMenuController: PMKPageMenuController, willMoveTo viewController: UIViewController, at menuIndex: Int) {
    }
    
    func pageMenuController(_ pageMenuController: PMKPageMenuController, didMoveTo viewController: UIViewController, at menuIndex: Int) {
        print(menuIndex)
        
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


