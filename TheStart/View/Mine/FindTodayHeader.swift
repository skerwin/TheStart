//
//  FindTodayHeader.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/10.
//

import UIKit

class FindTodayHeader: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib(){
 
        titleLabel.layer.masksToBounds = true
        titleLabel.layer.cornerRadius = 16
        //titleLabel.layer.borderWidth = 1
        //titleLabel.layer.borderColor = ZYJColor.blueTextColor.cgColor
        
    }

}


 
