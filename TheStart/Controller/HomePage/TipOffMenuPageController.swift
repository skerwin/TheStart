//
//  TipOffMenuPageController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/29.
//

import UIKit

class TipOffMenuPageController: BaseViewController {

    
    var  tipOffVC:TipOffViewController!
    var  clarifyVC:ClarifyViewController!
    
    var  superbbsVC:TipOffViewController!
    
    var  goodsVc:goodsListController!

    var tipOffVCButton:UIButton!
    
    var clarifyButton:UIButton!
    
    var supermanButton:UIButton!
    
    var goodsVcButton:UIButton!

    
    var navView:UIView!
    
    var pubBtn:UIButton!
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        if navView == nil{
            createNavView()
        }
      
        //self.navigationController?.navigationBar.addSubview(navView)
        
     
        
        self.navigationController?.navigationBar.addSubview(navView)
        //createPubBtn()
    }
    
    func createNavView() {
        
        tipOffVC = TipOffViewController()
        clarifyVC = ClarifyViewController()
        superbbsVC = TipOffViewController()
        goodsVc = goodsListController()

        tipOffVC.type = 1
        superbbsVC.type = 4
        
        
        navView = UIView.init(frame: CGRect.init(x: (screenWidth - 280)/2, y: 2, width:280, height: 38))
        
        tipOffVC.view.frame = CGRect.init(x: 0, y:navigationHeaderAndStatusbarHeight, width: screenWidth, height: screenHeight)
        superbbsVC.view.frame = CGRect.init(x: 0, y:navigationHeaderAndStatusbarHeight, width: screenWidth, height: screenHeight)
        goodsVc.view.frame = CGRect.init(x: 0, y:navigationHeaderAndStatusbarHeight, width: screenWidth, height: screenHeight)

        
        self.addChild(tipOffVC)
        self.view.addSubview(tipOffVC.view)
        
        tipOffVCButton = UIButton.init()
        tipOffVCButton.frame = CGRect.init(x: 0, y: 0, width: 70, height: 44)
        tipOffVCButton.addTarget(self, action: #selector(tipOffButtonACtion(_:)), for: .touchUpInside)
        tipOffVCButton.setTitle("嘿人馆", for: .normal)
        tipOffVCButton.setTitleColor(ZYJColor.barText, for: .normal)
        tipOffVCButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        clarifyButton = UIButton.init()
        clarifyButton.frame = CGRect.init(x: 70, y: 2, width: 70, height: 38)
        clarifyButton.addTarget(self, action: #selector(clarifyButtonACtion(_:)), for: .touchUpInside)
        clarifyButton.setTitle("澄清馆", for: .normal)
        clarifyButton.setTitleColor(UIColor.systemGray6, for: .normal)
        clarifyButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        supermanButton = UIButton.init()
        supermanButton.frame = CGRect.init(x: 140, y: 2, width: 75, height: 38)
        supermanButton.addTarget(self, action: #selector(supermanButtonACtion(_:)), for: .touchUpInside)
        supermanButton.setTitle("巅峰论坛", for: .normal)
        supermanButton.setTitleColor(UIColor.systemGray6, for: .normal)
        supermanButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        
        
        goodsVcButton = UIButton.init()
        goodsVcButton.frame = CGRect.init(x: 220, y: 2, width: 50, height: 38)
        goodsVcButton.addTarget(self, action: #selector(goodsVcButtonACtion(_:)), for: .touchUpInside)
        goodsVcButton.setTitle("商店", for: .normal)
        goodsVcButton.setTitleColor(UIColor.white, for: .normal)
        goodsVcButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
 
        navView.addSubview(tipOffVCButton)
        navView.addSubview(clarifyButton)
        navView.addSubview(supermanButton)
        navView.addSubview(goodsVcButton)

    
     
    }
    func createPubBtn() {
        
        pubBtn = UIButton.init()
        pubBtn.frame = CGRect.init(x: 0, y: 4, width: 60, height: 60)
        pubBtn.addTarget(self, action: #selector(pubBtnClick(_:)), for: .touchUpInside)
        pubBtn.setImage(UIImage.init(named: "tipOffPost"), for: .normal)
        
        let bgview = UIView.init()
        bgview.frame = CGRect.init(x: screenWidth - 100, y: screenHeight - 120, width: 60, height: 60)
        bgview.addSubview(pubBtn)
        
      
        self.view.addSubview(bgview)
        
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: bgview)
    }
    @objc func pubBtnClick(_ btn: UIButton){
    
        let controller = TipOffPostViewController()
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func goodsVcButtonACtion(_ btn: UIButton){
//        if self.children.contains(goodsVc){
//            goodsVc.removeFromParent()
//            goodsVc.view.removeFromSuperview()
//        }
//
//        if self.children.contains(superbbsVC){
//            superbbsVC.removeFromParent()
//            superbbsVC.view.removeFromSuperview()
//        }
//
        
        let cons = self.children
        for con in cons {
            if con != goodsVc{
                con.removeFromParent()
                con.view.removeFromSuperview()
            }
        }
        
        
        goodsVcButton.setTitleColor(ZYJColor.barText, for: .normal)
        goodsVcButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        clarifyButton.setTitleColor(UIColor.systemGray6 ,for: .normal)
        clarifyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        
        supermanButton.setTitleColor(UIColor.systemGray6, for: .normal)
        supermanButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        tipOffVCButton.setTitleColor(UIColor.systemGray6, for: .normal)
        tipOffVCButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
//        lineView1.isHidden = true
//        lineView2.isHidden = false
 
        self.addChild(goodsVc)
        self.view.addSubview(goodsVc.view)
    }
    
    
    @objc func supermanButtonACtion(_ btn: UIButton){
        
//        if self.children.contains(tipOffVC){
//            tipOffVC.removeFromParent()
//            tipOffVC.view.removeFromSuperview()
//        }
//
//        if self.children.contains(clarifyVC){
//            clarifyVC.removeFromParent()
//            clarifyVC.view.removeFromSuperview()
//        }
        
        let cons = self.children
        for con in cons {
            if con != superbbsVC{
                con.removeFromParent()
                con.view.removeFromSuperview()
            }
        }
        
        
        tipOffVCButton.setTitleColor(UIColor.systemGray6, for: .normal)
        tipOffVCButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        supermanButton.setTitleColor(ZYJColor.barText ,for: .normal)
        supermanButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        
        clarifyButton.setTitleColor(UIColor.systemGray6, for: .normal)
        clarifyButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        
        goodsVcButton.setTitleColor(UIColor.systemGray6, for: .normal)
        goodsVcButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        self.addChild(superbbsVC)
        self.view.addSubview(superbbsVC.view)
        
    }
    
    @objc func tipOffButtonACtion(_ btn: UIButton){
        
      
//        if self.children.contains(clarifyVC){
//            clarifyVC.removeFromParent()
//            clarifyVC.view.removeFromSuperview()
//        }
//
//        if self.children.contains(superbbsVC){
//            superbbsVC.removeFromParent()
//            superbbsVC.view.removeFromSuperview()
//        }
//
        let cons = self.children
        for con in cons {
            if con != tipOffVC{
                con.removeFromParent()
                con.view.removeFromSuperview()
            }
        }
        
        tipOffVCButton.setTitleColor(ZYJColor.barText, for: .normal)
        tipOffVCButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        clarifyButton.setTitleColor(UIColor.systemGray6, for: .normal)
        clarifyButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        supermanButton.setTitleColor(UIColor.systemGray6, for: .normal)
        supermanButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        goodsVcButton.setTitleColor(UIColor.systemGray6, for: .normal)
        goodsVcButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
   
 
//        lineView1.isHidden = false
//        lineView2.isHidden = true
        self.addChild(tipOffVC)
        self.view.addSubview(tipOffVC.view)
        //tipOffVC.refreshList()
 
     }
    
    
    @objc func clarifyButtonACtion(_ btn: UIButton){
//        if self.children.contains(tipOffVC){
//            tipOffVC.removeFromParent()
//            tipOffVC.view.removeFromSuperview()
//        }
//
//        if self.children.contains(superbbsVC){
//            superbbsVC.removeFromParent()
//            superbbsVC.view.removeFromSuperview()
//        }
//
        let cons = self.children
        for con in cons {
            if con != clarifyVC{
                con.removeFromParent()
                con.view.removeFromSuperview()
            }
        }
        
        tipOffVCButton.setTitleColor(UIColor.systemGray6, for: .normal)
        tipOffVCButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        clarifyButton.setTitleColor(ZYJColor.barText ,for: .normal)
        clarifyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        
        supermanButton.setTitleColor(UIColor.systemGray6, for: .normal)
        supermanButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        goodsVcButton.setTitleColor(UIColor.systemGray6, for: .normal)
        goodsVcButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
//        lineView1.isHidden = true
//        lineView2.isHidden = false
 
        self.addChild(clarifyVC)
        self.view.addSubview(clarifyVC.view)
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navView.removeFromSuperview()
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if navView == nil{
            createNavView()
        }
        self.navigationController?.navigationBar.addSubview(navView)
    }
      
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
    }
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
