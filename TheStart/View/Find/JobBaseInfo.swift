//
//  JobBaseInfo.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/19.
//

import UIKit

class JobBaseInfo: UIView {

    @IBOutlet weak var headImg: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isAuthLabel: UILabel!
    
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
   
    @IBAction func phoneBtnAction(_ sender: Any) {
    }
    @IBOutlet weak var phoneBtn: UIButton!
    
    override func awakeFromNib(){
 
        phoneBtn.layer.masksToBounds = true
        phoneBtn.layer.cornerRadius = 15
        
        
        isAuthLabel.layer.masksToBounds = true
        isAuthLabel.layer.cornerRadius = 8
        isAuthLabel.layer.borderWidth = 1
        isAuthLabel.textColor = ZYJColor.blueTextColor
        isAuthLabel.layer.borderColor = ZYJColor.blueTextColor.cgColor
        
     
    }
}
