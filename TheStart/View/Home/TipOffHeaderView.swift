//
//  TipOffHeaderView.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/15.
//

import UIKit

class TipOffHeaderView: UIView {

    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var msgBtn: UIButton!
    @IBAction func msgBtnAction(_ sender: Any) {
    }
    override func awakeFromNib(){
        

        
        
        headImage.layer.cornerRadius = 27
        headImage.layer.masksToBounds = true
 
        msgBtn.layer.cornerRadius = 10
        msgBtn.layer.masksToBounds = true
        
        tipLabel.layer.cornerRadius = 5
        tipLabel.layer.masksToBounds = true
        
     
    }

}
