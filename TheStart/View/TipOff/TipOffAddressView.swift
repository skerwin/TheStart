//
//  TipOffAddressView.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/29.
//

import UIKit
protocol TipOffAddressViewDelegate {
    func addrerssAction()
    func heirenAction()
    func heichangAction()
}


class TipOffAddressView: UIView {

    @IBOutlet weak var titleLabel: UITextField!
    
    @IBOutlet weak var addrerssLabel: UILabel!
    
    @IBOutlet weak var hieRenBtn: UIButton!
    
    @IBOutlet weak var heiChangBtn: UIButton!
    
    @IBOutlet weak var nameLabel: UITextField!
    
    var delegate: TipOffAddressViewDelegate!
    
    @IBAction func heiRenAction(_ sender: Any) {
        hieRenBtn.setImage(UIImage.init(named: "quanYES"), for: .normal)
        heiChangBtn.setImage(UIImage.init(named: "quanNO"), for: .normal)
        delegate.heirenAction()
    }
    
    @IBAction func heiChangAction(_ sender: Any) {
       
        heiChangBtn.setImage(UIImage.init(named: "quanYES"), for: .normal)
        hieRenBtn.setImage(UIImage.init(named: "quanNO"), for: .normal)
        delegate.heichangAction()
    }
    
    
 
    
    
    override func awakeFromNib(){
         
        addGestureRecognizerToView(view: addrerssLabel, target: self, actionName: "addrerssViewAction")
        let attributedtitle = NSAttributedString.init(string: "请输入标题", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        titleLabel.attributedPlaceholder = attributedtitle
        
        let attributedname = NSAttributedString.init(string: "请输入名称", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        nameLabel.attributedPlaceholder = attributedname
 
        hieRenBtn.setImage(UIImage.init(named: "quanYES"), for: .normal)
        heiChangBtn.setImage(UIImage.init(named: "quanNO"), for: .normal)
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
