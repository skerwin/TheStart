//
//  ChatBtnView.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/18.
//

import UIKit

class ChatBtnView: UIView {

    @IBOutlet weak var chatBtn: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func chatBtnAction(_ sender: Any) {
    }
    override func awakeFromNib(){
 
        chatBtn.layer.masksToBounds = true
        chatBtn.layer.cornerRadius = 20
 
    }
}
