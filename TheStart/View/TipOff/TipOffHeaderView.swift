//
//  TipOffHeaderView.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/15.
//

import UIKit
import SwiftUI

protocol TipOffHeaderViewDelegate {
    func msgBtnAction()
  
}

class TipOffHeaderView: UIView {

    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var msgBtn: UIButton!
    
    var delegate: TipOffHeaderViewDelegate!
    
    
    var model = TipOffModel()
    
    var parentNavigationController: UINavigationController?
    
    @IBAction func msgBtnAction(_ sender: Any) {
        delegate.msgBtnAction()
    }
    override func awakeFromNib(){
 
        addGestureRecognizerToView(view: nameLabel, target: self, actionName: "tapONameLabel")

        addGestureRecognizerToView(view: headImage, target: self, actionName: "tapOnImageheadImage")
        headImage.layer.cornerRadius = 27
        headImage.layer.masksToBounds = true
 
        msgBtn.layer.cornerRadius = 10
        msgBtn.layer.masksToBounds = true
        
        tipLabel.layer.cornerRadius = 5
        tipLabel.layer.masksToBounds = true
 
        msgBtn.isHidden = true
    }
    
    @objc private func tapOnImageheadImage() {
        
          EWImageAmplification.shared.scanBigImageWithImageView(currentImageView: headImage, alpha: 1)
    }
 
    @objc private func tapONameLabel() {
        if  model!.uid != 0{
            let controller = MyHomePageController()
            controller.authorId = model!.uid
            self.parentNavigationController?.pushViewController(controller, animated: true)
        }
      
     }
    
    func configModel(model:TipOffModel){
        
        self.model = model
        
        headImage.displayHeadImageWithURL(url: model.avatar)
        nameLabel.text = model.nickname
      
        if model.type == 1{
            tipLabel.text = "嘿人"
            tipLabel.backgroundColor = colorWithHexString(hex: "903207")
        }else{
            tipLabel.text = "澄清"
            tipLabel.backgroundColor = colorWithHexString(hex: "E19522")
        }
        timeLabel.text = model.add_time + "发布"
        
    }

}
