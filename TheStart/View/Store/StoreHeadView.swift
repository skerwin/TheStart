//
//  StoreHeadView.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/08/21.
//

import UIKit
import SDCycleScrollView
class StoreHeadView: UIView {

    @IBOutlet weak var bannView: SDCycleScrollView!
    
    @IBOutlet weak var zhuliBtn: UIButton!
    @IBOutlet weak var guanzhubtn: UIButton!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var browseNum: UILabel!
    
    @IBOutlet weak var moreImgView: UIView!
    
    @IBOutlet weak var phoneStrore: UIView!
    
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var commetNumlabel: UILabel!
    var parentNavigationController: UINavigationController?
    
    @IBAction func zhuliBtnAction(_ sender: Any) {
    }
    @IBAction func guanzhubtnAction(_ sender: Any) {
    }
    
    override func awakeFromNib(){
        
        zhuliBtn.addcornerRadius(radius: 15)
        guanzhubtn.addcornerRadius(radius: 15)
    
        let imageArrTemp = ["https://www.qichen123.com/uploads/attach/2022/06/20220625/2d0f09a94d6c4b9db0e96c6aeb53f3fb.png","https://www.qichen123.com/uploads/attach/2022/06/20220625/2d37e4bee97edba220d4eb9cd3a6015a.jpg","https://www.qichen123.com/uploads/attach/2022/06/20220625/56538d4c3c47cb087f917c34b35f34d0.jpg"]
        bannView.pageControlAliment = SDCycleScrollViewPageContolAliment(rawValue: 1)
        bannView.pageControlStyle = SDCycleScrollViewPageContolStyle(rawValue: 1)
       //pageControlBottomOffset
       // bannView.delegate = self
        bannView.backgroundColor = ZYJColor.main
        //bannView.layer.cornerRadius = 5;
       // bannView.layer.masksToBounds = true;
        bannView.imageURLStringsGroup = imageArrTemp
    }
    
 
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
