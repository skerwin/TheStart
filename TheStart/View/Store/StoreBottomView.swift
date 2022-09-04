//
//  StoreBottomView.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/08/21.
//

import UIKit
protocol StoreBottomViewDelegate {
    func callPhoneAction()
    func commetnAction()
    func likeViewAction()
   
}
class StoreBottomView: UIView {

    @IBOutlet weak var callPhone: UIView!
    
    @IBOutlet weak var commetn: UIView!
    
    @IBOutlet weak var likeView: UIView!
    
    @IBOutlet weak var likeImage: UIImageView!
    
    @IBOutlet weak var likeLabel: UILabel!
    
    var delegate: StoreBottomViewDelegate!
    
    func configModel(model:StoreModel){
       
        if model.if_like == 1{
            likeImage.image = UIImage.init(named: "dianzanzhong")
            likeLabel.text = "已点赞"
        }else{
            likeImage.image = UIImage.init(named: "dianzan")
            likeLabel.text = "点赞"
        }
       // goodLabel.text = "\(String(describing: model.dianzan))"
 
    }
    override func awakeFromNib(){
        
        addGestureRecognizerToView(view: callPhone, target: self, actionName: "callPhoneAction")
        addGestureRecognizerToView(view: commetn, target: self, actionName: "commetnAction")
        addGestureRecognizerToView(view: likeView, target: self, actionName: "likeViewAction")
 
     }
    @objc private func callPhoneAction() {
        delegate.callPhoneAction()
    }
    @objc private func commetnAction() {
        delegate.commetnAction()
    }
    @objc private func likeViewAction() {
        delegate.likeViewAction()
    }
}
