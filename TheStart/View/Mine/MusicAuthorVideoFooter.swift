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
    
    var isOrigin = false
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func changeBtnAction(_ sender: Any) {
        isOrigin = false
        
        changeBtn.layer.masksToBounds = true
        changeBtn.layer.cornerRadius = 8
        changeBtn.layer.borderWidth = 1
        changeBtn.layer.borderColor = ZYJColor.blueTextColor.cgColor
        
        originBtn.layer.borderWidth = 0
        originBtn.layer.borderColor = ZYJColor.main.cgColor
    }
    
    @IBAction func originBtnAction(_ sender: Any) {
        isOrigin = true
        
        originBtn.layer.masksToBounds = true
        originBtn.layer.cornerRadius = 8
        originBtn.layer.borderWidth = 1
        originBtn.layer.borderColor = ZYJColor.blueTextColor.cgColor
        
        changeBtn.layer.borderWidth = 0
        changeBtn.layer.borderColor = ZYJColor.main.cgColor
    }
    
    override func awakeFromNib(){
 
 
        
        originBtn.layer.masksToBounds = true
        originBtn.layer.cornerRadius = 8
        originBtn.layer.borderWidth = 1
        originBtn.layer.borderColor = ZYJColor.blueTextColor.cgColor
        
    }
}
