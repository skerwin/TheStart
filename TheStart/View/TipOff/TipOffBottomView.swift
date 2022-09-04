//
//  TipOffBottomView.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/15.
//

import UIKit

protocol TipOffBottomViewDelegate {
    func defecateViewAction()
    func commentViewAction()
    func goodViewAction()
    func caiViewAction()
}
class TipOffBottomView: UIView {

 
    @IBOutlet weak var commentImg: UIImageView!
    @IBOutlet weak var defecateImg: UIImageView!
    @IBOutlet weak var goodImg: UIImageView!
    
    @IBOutlet weak var defecateLabel: UILabel!
    @IBOutlet weak var goodLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var defecateView: UIView!
    @IBOutlet weak var goodView: UIView!
    
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var caiView: UIView!
    @IBOutlet weak var caiLabel: UILabel!
    var delegate: TipOffBottomViewDelegate!
    
    override func awakeFromNib(){
        
 
        
        addGestureRecognizerToView(view: defecateView, target: self, actionName: "defecateViewAction")
        addGestureRecognizerToView(view: commentView, target: self, actionName: "commentViewAction")
        addGestureRecognizerToView(view: goodView, target: self, actionName: "goodViewAction")
        addGestureRecognizerToView(view: caiView, target: self, actionName: "caiViewAction")

        
     }
    
 
    func configModel(model:TipOffModel){
      
        if model.type == 1{
            defecateLabel.text = "我要澄清"
        }else if model.type == 3{
            defecateLabel.text = "原文链接"
        }else{
            defecateLabel.text = "原文分享"
        }
        if model.is_dianzan == 1{
            goodImg.image = UIImage.init(named: "dianzanzhong")
        }else{
            goodImg.image = UIImage.init(named: "dianzan")
        }
        goodLabel.text = "\(String(describing: model.dianzan))"
        caiLabel.text = "\(String(describing: model.cai))"
 
    }
    @objc func defecateViewAction(){
        
        delegate.defecateViewAction()
       
    }
    @objc func commentViewAction(){
     
        delegate.commentViewAction()
    }
    @objc func goodViewAction(){
      
        delegate.goodViewAction()
    }
    @objc func caiViewAction(){
      
        delegate.caiViewAction()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
