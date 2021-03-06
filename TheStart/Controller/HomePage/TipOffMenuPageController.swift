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
    
    var tipOffVCButton:UIButton!
    
    var clarifyButton:UIButton!
    
    var navView:UIView!
    
    var pubBtn:UIButton!
    
    var lineView1:UIView!
    var lineView2:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tipOffVC = TipOffViewController()
        clarifyVC = ClarifyViewController()
        
        navView = UIView.init(frame: CGRect.init(x: (screenWidth - 200)/2, y: 2, width:200, height: 38))
        
        tipOffVCButton = UIButton.init()
        tipOffVCButton.frame = CGRect.init(x: 0, y: 0, width: 100, height: 44)
        tipOffVCButton.addTarget(self, action: #selector(tipOffButtonACtion(_:)), for: .touchUpInside)
        tipOffVCButton.setTitle("吐槽馆", for: .normal)
        tipOffVCButton.setTitleColor(ZYJColor.barText, for: .normal)
        tipOffVCButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        lineView1 = UIView.init(frame: CGRect.init(x: (100 - 30)/2, y: 40, width:23, height: 2))
        lineView1.backgroundColor = UIColor.white
        
        clarifyButton = UIButton.init()
        clarifyButton.frame = CGRect.init(x: 100, y: 2, width: 100, height: 38)
        clarifyButton.addTarget(self, action: #selector(clarifyButtonACtion(_:)), for: .touchUpInside)
        clarifyButton.setTitle("澄清馆", for: .normal)
        clarifyButton.setTitleColor(UIColor.darkGray, for: .normal)
        clarifyButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        lineView2 = UIView.init(frame: CGRect.init(x: 100 + (100 - 30)/2, y: 40, width:23, height: 2))
        lineView2.backgroundColor = UIColor.white
        
        navView.addSubview(tipOffVCButton)
        navView.addSubview(clarifyButton)
        navView.addSubview(lineView1)
        navView.addSubview(lineView2)
        lineView1.isHidden = false
        lineView2.isHidden = true
        //self.navigationController?.navigationBar.addSubview(navView)
        
        self.addChild(tipOffVC)
        self.view.addSubview(tipOffVC.view)
        //createPubBtn()
        
        
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
    
    @objc func tipOffButtonACtion(_ btn: UIButton){
        
        if self.children.contains(clarifyVC){
            clarifyVC.removeFromParent()
            clarifyVC.view.removeFromSuperview()
        }
        
        clarifyButton.setTitleColor(UIColor.darkGray, for: .normal)
        clarifyButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        tipOffVCButton.setTitleColor(ZYJColor.barText, for: .normal)
        tipOffVCButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
 
        lineView1.isHidden = false
        lineView2.isHidden = true
        self.addChild(tipOffVC)
        self.view.addSubview(tipOffVC.view)
 
     }
    
    
    @objc func clarifyButtonACtion(_ btn: UIButton){
        if self.children.contains(tipOffVC){
            tipOffVC.removeFromParent()
            tipOffVC.view.removeFromSuperview()
        }
        
        
        tipOffVCButton.setTitleColor(UIColor.darkGray, for: .normal)
        tipOffVCButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        clarifyButton.setTitleColor(ZYJColor.barText ,for: .normal)
        clarifyButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        lineView1.isHidden = true
        lineView2.isHidden = false
 
        self.addChild(clarifyVC)
        self.view.addSubview(clarifyVC.view)
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
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
