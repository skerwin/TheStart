//
//  HomePageController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/14.
//

import UIKit

class HomePageController: BaseViewController {

    
    var rightBarButton:UIButton!
    var rightBarButton1:UIButton!
    var rightBarButton2:UIButton!
    
    var rightBarButton3:UIButton!
    var rightBarButton4:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        rightBarButton = UIButton.init()
        rightBarButton.setTitle("黑人馆", for: .normal)
        rightBarButton.setTitleColor(.white, for: .normal)
        rightBarButton.frame = CGRect.init(x: 0, y: 200, width: screenWidth, height: 50)
        rightBarButton.addTarget(self, action: #selector(rightNavBtnAction(_:)), for: .touchUpInside)
        self.view.addSubview(rightBarButton)
        
        rightBarButton1 = UIButton.init()
        rightBarButton1.setTitle("找场的人详情", for: .normal)
        rightBarButton1.setTitleColor(.white, for: .normal)
        rightBarButton1.frame = CGRect.init(x: 0, y: 250, width: screenWidth, height: 50)
        rightBarButton1.addTarget(self, action: #selector(rightNavBtnAction1(_:)), for: .touchUpInside)
        self.view.addSubview(rightBarButton1)
        
        
        rightBarButton2 = UIButton.init()
        rightBarButton2.setTitle("发布找场", for: .normal)
        rightBarButton2.setTitleColor(.white, for: .normal)
        rightBarButton2.frame = CGRect.init(x: 0, y: 300, width: screenWidth, height: 50)
        rightBarButton2.addTarget(self, action: #selector(rightNavBtnAction2(_:)), for: .touchUpInside)
        self.view.addSubview(rightBarButton2)
        
        
        rightBarButton3 = UIButton.init()
        rightBarButton3.setTitle("发布黑料", for: .normal)
        rightBarButton3.setTitleColor(.white, for: .normal)
        rightBarButton3.frame = CGRect.init(x: 0, y: 350, width: screenWidth, height: 50)
        rightBarButton3.addTarget(self, action: #selector(rightNavBtnAction3(_:)), for: .touchUpInside)
        self.view.addSubview(rightBarButton3)
        
        
        rightBarButton4 = UIButton.init()
        rightBarButton4.setTitle("个人中心", for: .normal)
        rightBarButton4.setTitleColor(.white, for: .normal)
        rightBarButton4.frame = CGRect.init(x: 0, y: 400, width: screenWidth, height: 50)
        rightBarButton4.addTarget(self, action: #selector(rightNavBtnAction4(_:)), for: .touchUpInside)
        self.view.addSubview(rightBarButton4)
    }
    
    @objc func rightNavBtnAction(_ btn: UIButton){
        //let controller = UIStoryboard.getFindPersonController()
       // let controller = TipOffDetailViewController()
        
        //let controller = TipOffPostViewController()
        let controller = TipOffViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func rightNavBtnAction1(_ btn: UIButton){
        //let controller = UIStoryboard.getFindPersonController()
       // let controller = TipOffDetailViewController()
        
        //let controller = TipOffPostViewController()
        let controller = WorkerInfoViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
   
    @objc func rightNavBtnAction2(_ btn: UIButton){
         let controller = WorkerPubViewController()

         self.navigationController?.pushViewController(controller, animated: true)
    }
    @objc func rightNavBtnAction3(_ btn: UIButton){
         let controller = TipOffPostViewController()
         self.navigationController?.pushViewController(controller, animated: true)
    }
    @objc func rightNavBtnAction4(_ btn: UIButton){
        let controller = UIStoryboard.getMineViewController()
   
        self.navigationController?.pushViewController(controller, animated: true)
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
