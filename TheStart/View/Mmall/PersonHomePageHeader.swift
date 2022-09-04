//
//  PersonHomePageHeader.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/08/21.
//

import UIKit

protocol PersonHomePageHeaderDelegate {
    
    func chatactionBtn()
 }

class PersonHomePageHeader: UIView {
    
    var delegate:PersonHomePageHeaderDelegate!

    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var orangeLabel: UILabel!
    
    @IBOutlet weak var bigbtn: UIButton!
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var isrealNameLabel: UILabel!
    @IBOutlet weak var vipImage: UIImageView!
    
    @IBOutlet weak var careNumLabel: UILabel!
    
    @IBOutlet weak var pingtairenzhengLabel: UILabel!
    
    @IBOutlet weak var workTypelabel: UILabel!
    
    @IBOutlet weak var scorelabel: UILabel!
    
    @IBOutlet weak var orangeNumLabel: UILabel!
    
    @IBOutlet weak var chatBtn: UIButton!
    
    var parentNavigationController: UINavigationController?
    var author = UserModel()
    
    @IBOutlet weak var bgView1: UIView!
    
    @IBAction func bigBtnAction(_ sender: Any) {
        EWImageAmplification.shared.scanBigImageWithImageView(currentImageView: headImg, alpha: 1)
     }
    
    @IBAction func chatactionBtn(_ sender: Any) {
        
      //  delegate.chatactionBtn()
        if author!.uid == getUserId(){
            DialogueUtils.showWarning(withStatus: "不能跟自己发起聊天哦")
            return
        }

        let controller = UIStoryboard.getMessageController()
        controller.toID = author!.uid
        
        if author?.nickname == ""{
            controller.nameTitle = author!.real_name
        }else{
            controller.nameTitle = author!.nickname
        }

        self.parentNavigationController?.pushViewController(controller, animated: true)
    }
    
    
 
    func configModel(model:UserModel){
        author = model
        nameLabel.text = model.nickname
        headImg.displayImageWithURL(url: model.avatar)
        
        scoreLabel.text = "音乐人指标:" + intToString(number: model.audio_score)
        orangeLabel.text = "🍊橙子数:：" + intToString(number: model.integral)
        
        workTypelabel.text = "工种：" + model.shiming_work_name
        
        if ((model.is_vip == 1 || model.vip == 1) && !checkMarketVer()){
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
            if model.shiming_work_name == ""{
                workTypelabel.text = "工种：" + "未填写"
            }else{
                workTypelabel.text = "工种：" + model.shiming_work_name
            }
            
        }else{
            workTypelabel.text = "工种：" + model.work_name
        }
       
        if model.collection_count == 0{
            careNumLabel.isHidden = true
        }else{
            careNumLabel.isHidden = false
            careNumLabel.text = int2str(num: model.collection_count) + "人已关注"
            
        }
        addGestureRecognizerToView(view: headImg, target: self, actionName: "tapOnImage")

        
        //introLabel.text = model.introduce
        
    }
    
    override func awakeFromNib(){
        bgView1.layer.masksToBounds = true
        bgView1.layer.cornerRadius = 8
        
        chatBtn.layer.masksToBounds = true
        chatBtn.layer.cornerRadius = 8
        
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
        pingtairenzhengLabel.layer.borderColor = UIColor.lightGray.cgColor
        pingtairenzhengLabel.textAlignment = .center
        
        
        workTypelabel.layer.masksToBounds = true
        workTypelabel.layer.cornerRadius = 8
        workTypelabel.layer.borderWidth = 1
        workTypelabel.layer.borderColor = UIColor.lightGray.cgColor
        workTypelabel.textAlignment = .center
    }
    
  
    @objc func tapOnImage() {
          //addGestureRecognizerToView(view: headImage, target: self, actionName: "tapOnImageheadImage")
          EWImageAmplification.shared.scanBigImageWithImageView(currentImageView: headImg, alpha: 1)
    }
    
  

}
