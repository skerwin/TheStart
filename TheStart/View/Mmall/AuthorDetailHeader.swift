//
//  AuthorDetailHeader.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/09.
//

import UIKit
import SwiftUI

class AuthorDetailHeader: UICollectionReusableView {

    @IBOutlet weak var headImage: UIImageView!
   
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var isMusicLabel: UILabel!
    @IBOutlet weak var isRealabel: UILabel!
    @IBOutlet weak var musicNumLabel: UILabel!
    
    override func awakeFromNib(){
        
        headImage.layer.masksToBounds = true
        headImage.layer.cornerRadius = 29
        
        isRealabel.layer.masksToBounds = true
        isRealabel.layer.cornerRadius = 8
        isRealabel.layer.borderWidth = 1
        isRealabel.textColor = ZYJColor.blueTextColor
        isRealabel.layer.borderColor = ZYJColor.blueTextColor.cgColor
    }
    
    func configModel(model:UserModel){
        headImage.displayImageWithURL(url: model.avatar)
        if model.real_name == ""{
            nameLabel.text = model.nickname
        }else{
            nameLabel.text = model.real_name
        }
        if model.is_audio == 2{
            isMusicLabel.text = "已通过音乐人认证"
        }else{
            isMusicLabel.text = "未音乐人认证"
        }
        if model.is_shiming == 2{
            isRealabel.text = "已实名"
        }else{
            isRealabel.text = "未实名"
        }
        
        musicNumLabel.text = "作品集(" + intToString(number: model.music_num) + ")"
        
    }
    
}
