//
//  MusicAuthorVideoFooter.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/10.
//

import UIKit

class MusicAuthorVideoFooter: UIView {

    
    
    @IBOutlet weak var originBtn: UIButton!
    
    @IBOutlet weak var changeBtn: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func changeBtnAction(_ sender: Any) {
    }
    
    @IBAction func originBtnAction(_ sender: Any) {
    }
    
    override func awakeFromNib(){
 
 
        
        originBtn.layer.masksToBounds = true
        originBtn.layer.cornerRadius = 8
        originBtn.layer.borderWidth = 1
        //originBtn.textColor = ZYJColor.blueTextColor
        originBtn.layer.borderColor = ZYJColor.blueTextColor.cgColor
        
    }
}
