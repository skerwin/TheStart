//
//  MyHomePageController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/08/21.
//

import UIKit

class MyHomePageController: BaseViewController {

    
    var headView:PersonHomePageHeader!
    var headerBgView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHeadView()
        self.title = "他的主页"

        // Do any additional setup after loading the view.
    }
    
    func initHeadView(){
        headView = Bundle.main.loadNibNamed("PersonHomePageHeader", owner: nil, options: nil)!.first as? PersonHomePageHeader
        headView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height:202)
        //headView.delegate = self
        
        headerBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 202))
        headerBgView.backgroundColor = UIColor.red
        headerBgView.addSubview(headView)
        
        
        self.view.addSubview(headerBgView)
        
    }

}
