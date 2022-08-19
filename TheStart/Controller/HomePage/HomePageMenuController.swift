//
//  HomePageMenuController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/06/16.
//
 
import UIKit


class HomePageMenuController: BaseViewController,Requestable {
 
 
    var  homeVc:HomePageController!
    var  jobVc:JobListViewController!
    var  workVc:WorkListViewController!
    var  goodsVc:goodsListController!
    
    var homeVcButton:UIButton!
    
    var jobVcButton:UIButton!
 
    var workVcButton:UIButton!
    
    var goodsVcButton:UIButton!
    
    var navView:UIView!
    
    var rightBarButton:UIButton!
 
    override func viewDidLoad() {
        super.viewDidLoad()
 
        homeVc = HomePageController()
        
        jobVc = JobListViewController()
        jobVc.isFromHome = true
        
        workVc = WorkListViewController()
        workVc.isFromHome = true
        
        goodsVc = goodsListController()
        
        
        navView = UIView.init(frame: CGRect.init(x: (screenWidth - 240)/2, y: 0, width:240, height: 44))
 
        homeVcButton = UIButton.init()
        homeVcButton.frame = CGRect.init(x: 0, y: 0, width: 60, height: 44)
        homeVcButton.addTarget(self, action: #selector(homeVcButtonACtion(_:)), for: .touchUpInside)
        homeVcButton.setTitle("首页", for: .normal)
        homeVcButton.setTitleColor(ZYJColor.barText, for: .normal)
        homeVcButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
      
        jobVcButton = UIButton.init()
        jobVcButton.frame = CGRect.init(x: 60, y: 0, width: 60, height: 44)
        jobVcButton.addTarget(self, action: #selector(jobVcButtonACtion(_:)), for: .touchUpInside)
        jobVcButton.setTitle("找场", for: .normal)
        jobVcButton.setTitleColor(UIColor.darkGray, for: .normal)
        jobVcButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        workVcButton = UIButton.init()
        workVcButton.frame = CGRect.init(x: 120, y: 0, width: 60, height: 44)
        workVcButton.addTarget(self, action: #selector(workVcuttonACtion(_:)), for: .touchUpInside)
        workVcButton.setTitle("找人", for: .normal)
        workVcButton.setTitleColor(UIColor.darkGray, for: .normal)
        workVcButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        
        goodsVcButton = UIButton.init()
        goodsVcButton.frame = CGRect.init(x: 180, y: 0, width: 60, height: 44)
        goodsVcButton.addTarget(self, action: #selector(goodsVcButtonACtion(_:)), for: .touchUpInside)
        goodsVcButton.setTitle("商店", for: .normal)
        goodsVcButton.setTitleColor(UIColor.darkGray, for: .normal)
        goodsVcButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        navView.addSubview(homeVcButton)
        navView.addSubview(jobVcButton)
        navView.addSubview(workVcButton)
        navView.addSubview(goodsVcButton)
        
        self.navigationController?.navigationBar.addSubview(navView)
        self.addChild(homeVc)
        self.view.addSubview(homeVc.view)
    }
 
    
    func createRightNavItem() {
        
        rightBarButton = UIButton.init()
        rightBarButton.frame = CGRect.init(x: 0, y: 100, width: 28, height: 28)
        rightBarButton.addTarget(self, action: #selector(rightNavBtnClic(_:)), for: .touchUpInside)
        rightBarButton.setBackgroundImage(UIImage.init(named: "add"), for: .normal)
        //rightBarButton.setImage(UIImage.init(named: "add"), for: .normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBarButton)
 
    }
    @objc func rightNavBtnClic(_ btn: UIButton){
         YBPopupMenu.showRely(on: btn, titles: ["我要找场","我要找人",], icons: [], menuWidth: 125, delegate: self)
    }
    
    @objc func homeVcButtonACtion(_ btn: UIButton){
        
        let cons = self.children
        
        for con in cons {
            if con != homeVc{
                con.removeFromParent()
                con.view.removeFromSuperview()
            }
        }
 

        homeVcButton.setTitleColor(ZYJColor.barText, for: .normal)
        homeVcButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)

        jobVcButton.setTitleColor(UIColor.darkGray, for: .normal)
        jobVcButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        workVcButton.setTitleColor(UIColor.darkGray, for: .normal)
        workVcButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        goodsVcButton.setTitleColor(UIColor.darkGray, for: .normal)
        goodsVcButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        

        self.addChild(homeVc)
        self.view.addSubview(homeVc.view)
 
     }
    
    
    @objc func jobVcButtonACtion(_ btn: UIButton){
        let cons = self.children
        
        for con in cons {
            if con != jobVc{
                con.removeFromParent()
                con.view.removeFromSuperview()
            }
        }
 

        homeVcButton.setTitleColor(UIColor.darkGray, for: .normal)
        homeVcButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)

        jobVcButton.setTitleColor(ZYJColor.barText, for: .normal)
        jobVcButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        workVcButton.setTitleColor(UIColor.darkGray, for: .normal)
        workVcButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        goodsVcButton.setTitleColor(UIColor.darkGray, for: .normal)
        goodsVcButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)

        self.addChild(jobVc)
        self.view.addSubview(jobVc.view)
     }
    
    @objc func workVcuttonACtion(_ btn: UIButton){
        let cons = self.children
        
        for con in cons {
            if con != workVc{
                con.removeFromParent()
                con.view.removeFromSuperview()
            }
        }
 
        homeVcButton.setTitleColor(UIColor.darkGray, for: .normal)
        homeVcButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)

        jobVcButton.setTitleColor(UIColor.darkGray, for: .normal)
        jobVcButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        workVcButton.setTitleColor(ZYJColor.barText, for: .normal)
        workVcButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        goodsVcButton.setTitleColor(UIColor.darkGray, for: .normal)
        goodsVcButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)

        self.addChild(workVc)
        self.view.addSubview(workVc.view)
    }
    
    @objc func goodsVcButtonACtion(_ btn: UIButton){
        let cons = self.children
        
        for con in cons {
            if con != goodsVc{
                con.removeFromParent()
                con.view.removeFromSuperview()
            }
        }
 
        homeVcButton.setTitleColor(UIColor.darkGray, for: .normal)
        homeVcButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)

        jobVcButton.setTitleColor(UIColor.darkGray, for: .normal)
        jobVcButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        workVcButton.setTitleColor(UIColor.darkGray, for: .normal)
        workVcButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        goodsVcButton.setTitleColor(ZYJColor.barText, for: .normal)
        goodsVcButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
       

        self.addChild(goodsVc)
        self.view.addSubview(goodsVc.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navView.removeFromSuperview()
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.addSubview(navView)
    }
      
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
    }
 

}
 
extension HomePageMenuController:YBPopupMenuDelegate{
    func ybPopupMenuDidSelected(at index: Int, ybPopupMenu: YBPopupMenu!) {
        ybPopupMenu.isHidden = true
        
        if index == 0{
            let controller = WorkerPubViewController()
            controller.pubType = 2
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
            let controller = WorkerPubViewController()
            controller.pubType = 1
            self.navigationController?.pushViewController(controller, animated: true)
 
        }
      
        
    }
}
