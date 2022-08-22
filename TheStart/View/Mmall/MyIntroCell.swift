//
//  MyIntroCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/08/22.
//

import UIKit

class MyIntroCell: UITableViewCell {
    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var realNamelabel: UILabel!
    
    @IBOutlet weak var workTypeLabel: UILabel!
    @IBOutlet weak var addresslabel: UILabel!
    
    @IBOutlet weak var workAddressLabel: UILabel!
    
    @IBOutlet weak var introTv: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configModel(model:UserModel){
        
        let blankStr = "暂未填写"
        
        if model.nickname == ""{
            nameLabel.text = blankStr
        }else{
            nameLabel.text = model.nickname
        }
        
        if model.real_name == ""{
            realNamelabel.text = blankStr
        }else{
            realNamelabel.text = model.real_name
        }
        
        if model.work_name == ""{
            workTypeLabel.text = blankStr
        }else{
            workTypeLabel.text = model.work_name
        }
        
        if model.address == ""{
            addresslabel.text = blankStr
        }else{
            addresslabel.text = model.address
        }
        
        if model.shiming_company == ""{
            workAddressLabel.text = blankStr
        }else{
            workAddressLabel.text = model.shiming_company
        }
        if model.introduce == ""{
            introTv.text = blankStr
        }else{
            introTv.text = model.introduce
        }
        
        }
        
 
        
        
 
 }
