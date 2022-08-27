//
//  TipOffAddressView.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/29.
//

import UIKit
protocol TipOffAddressViewDelegate {
    func addrerssAction()
 
}


class TipOffAddressView: UIView {

    @IBOutlet weak var titleLabel: UITextField!
    
    @IBOutlet weak var addrerssLabel: UILabel!
    
    var delegate: TipOffAddressViewDelegate!
    
    override func awakeFromNib(){
         
        addGestureRecognizerToView(view: addrerssLabel, target: self, actionName: "addrerssViewAction")
        let attributedName = NSAttributedString.init(string: "请输入标题", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        titleLabel.attributedPlaceholder = attributedName
        
//
//        let attributedName = NSAttributedString.init(string: "请输入标题", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
//        titleLabel.attributedPlaceholder = attributedName

      
    }
    
    @objc func addrerssViewAction(){
        delegate.addrerssAction()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
