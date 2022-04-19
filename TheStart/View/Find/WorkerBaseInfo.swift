//
//  WorkerBaseInfo.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/18.
//

import UIKit

class WorkerBaseInfo: UIView {

  
    @IBOutlet weak var headImg: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isAuthLabel: UILabel!
    
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
   
    @IBAction func phoneBtnAction(_ sender: Any) {
    }
    @IBOutlet weak var phoneBtn: UIButton!
    override func awakeFromNib(){
 
        phoneBtn.layer.masksToBounds = true
        phoneBtn.layer.cornerRadius = 15
        
        
        infoLabel.font = UIFont.boldSystemFont(ofSize: 16)
        isAuthLabel.layer.masksToBounds = true
        isAuthLabel.layer.cornerRadius = 8
        isAuthLabel.layer.borderWidth = 1
        isAuthLabel.textColor = ZYJColor.blueTextColor
        isAuthLabel.layer.borderColor = ZYJColor.blueTextColor.cgColor
        
        jobLabel.layer.masksToBounds = true
        jobLabel.layer.cornerRadius = 4
        jobLabel.layer.borderWidth = 1
        jobLabel.layer.borderColor = UIColor.white.cgColor
        
        salaryLabel.layer.masksToBounds = true
        salaryLabel.layer.cornerRadius = 4
        salaryLabel.layer.borderWidth = 1
        salaryLabel.layer.borderColor = UIColor.white.cgColor
    }
   
}
