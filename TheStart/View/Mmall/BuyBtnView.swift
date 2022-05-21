//
//  BuyBtnView.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/21.
//

import UIKit
 
protocol BuyBtnViewDelegate {
    func buyBtnAction()
    func vipBtnAction()
}
 

class BuyBtnView: UIView {

    var delegate:BuyBtnViewDelegate!
    
    @IBOutlet weak var buyBtn: UIButton!
    
    @IBOutlet weak var vipBtn: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func buyBtnAction(_ sender: Any) {
        delegate.buyBtnAction()
    }
    
    @IBAction func vipBtnAction(_ sender: Any) {
        delegate.vipBtnAction()
    }
    
    override func awakeFromNib(){
 
        buyBtn.layer.masksToBounds = true
        buyBtn.layer.cornerRadius = 20
        
        vipBtn.layer.masksToBounds = true
        vipBtn.layer.cornerRadius = 20
 
    }
}
