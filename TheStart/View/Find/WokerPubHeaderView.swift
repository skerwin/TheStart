//
//  WokerPubHeaderView.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/18.
//

import UIKit

class WokerPubHeaderView: UIView {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var jobTypeLabel: UILabel!
    @IBOutlet weak var jobTypeView: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib(){
 
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 15
        
      
    }
}
