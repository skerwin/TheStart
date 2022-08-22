//
//  PersonHomePageHeader.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/08/21.
//

import UIKit

class PersonHomePageHeader: UIView {

    
    
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var isrealNameLabel: UILabel!
    @IBOutlet weak var vipImage: UIImageView!
    
    @IBOutlet weak var careNumLabel: UILabel!
    
    @IBOutlet weak var pingtairenzhengLabel: UILabel!
    
    @IBOutlet weak var workTypelabel: UILabel!
    
    @IBOutlet weak var introLabel: UILabel!
    
    override func awakeFromNib(){
        
        vipImage.isHidden = true
        headImg.layer.masksToBounds = true
        headImg.layer.cornerRadius = 32.5
        isrealNameLabel.layer.masksToBounds = true
        isrealNameLabel.layer.cornerRadius = 8
        isrealNameLabel.layer.borderWidth = 1
        isrealNameLabel.textColor = ZYJColor.blueTextColor
        isrealNameLabel.layer.borderColor = ZYJColor.blueTextColor.cgColor
        
        pingtairenzhengLabel.layer.masksToBounds = true
        pingtairenzhengLabel.layer.cornerRadius = 8
        pingtairenzhengLabel.layer.borderWidth = 1
        pingtairenzhengLabel.textColor = UIColor.darkGray
        pingtairenzhengLabel.layer.borderColor = UIColor.lightGray.cgColor
        pingtairenzhengLabel.textAlignment = .center
        
        
        workTypelabel.layer.masksToBounds = true
        workTypelabel.layer.cornerRadius = 8
        workTypelabel.layer.borderWidth = 1
        workTypelabel.textColor = UIColor.darkGray
        workTypelabel.layer.borderColor = UIColor.lightGray.cgColor
        workTypelabel.textAlignment = .center
        addGestureRecognizerToView(view: headImg, target: self, actionName: "tapOnImageheadImage1")
    }
 
    @objc private func tapOnImageheadImage1() {
          //addGestureRecognizerToView(view: headImage, target: self, actionName: "tapOnImageheadImage")
          EWImageAmplification.shared.scanBigImageWithImageView(currentImageView: headImg, alpha: 1)
    }
    
    func configModel(model:UserModel){
        
        nameLabel.text = model.nickname
        headImg.displayImageWithURL(url: model.avatar)
        
        if model.is_vip == 1 && !checkMarketVer(){
            vipImage.isHidden = false
        }else{
            vipImage.isHidden = true //
        }
        
        if model.real_name == ""{
            nameLabel.text = model.nickname
        }else{
            nameLabel.text = model.real_name
        }
        if model.is_audio == 2{
            pingtairenzhengLabel.text = "平台认证音乐人"
        }else{
            pingtairenzhengLabel.text = "未认证音乐人"
        }
        if model.is_shiming == 2{
            isrealNameLabel.text = "已实名"
        }else{
            isrealNameLabel.text = "未实名"
        }
        if model.work_name == ""{
            workTypelabel.text = "工种：" + "未填写"
        }else{
            workTypelabel.text = "工种：" + model.work_name
        }
       
        introLabel.text = model.introduce
        
    }

}
