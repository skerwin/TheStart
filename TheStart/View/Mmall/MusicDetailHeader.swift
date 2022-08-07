//
//  MusicDetailHeader.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/09.
//

import UIKit
import SwiftUI

class MusicDetailHeader: UIView {

    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UIButton!
    
    
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var aunameLabel: UILabel!
    
    
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var isrenameLabel: UILabel!
    
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var chatbtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    
    var parentNavigationController: UINavigationController?
    var author = UserModel()
    
    override func awakeFromNib(){
 
        chatbtn.layer.masksToBounds = true
        chatbtn.layer.cornerRadius = 5
        
        isrenameLabel.layer.masksToBounds = true
        isrenameLabel.layer.cornerRadius = 8
        isrenameLabel.layer.borderWidth = 1
        isrenameLabel.textColor = ZYJColor.blueTextColor
        isrenameLabel.layer.borderColor = ZYJColor.blueTextColor.cgColor
        
        addGestureRecognizerToView(view: leftImage, target: self, actionName: "tapOnmusicleftImage")

    }
    @objc func tapOnmusicleftImage() {
        
        EWImageAmplification.shared.scanBigImageWithImageView(currentImageView: leftImage, alpha: 1)

     }
    
    @IBAction func homeBtnAction(_ sender: Any) {
        
        let controller = MyHomePageController()
        controller.authorId = author!.uid
        self.parentNavigationController?.pushViewController(controller, animated: true)
    }
    
    
    @IBAction func chatBtnAction(_ sender: Any) {
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
    
    func configModel(model:AudioModel){
        
        
        if model.type == 1{
            typeLabel.text = "类型：开场"
        }else if model.type == 2{
            typeLabel.text = "类型：颗粒or爆点 "
        }else if model.type == 3{
            typeLabel.text = "类型：set套曲"
        }else if model.type == 4{
            typeLabel.text = "类型：其他"
        }else{
            typeLabel.text = "类型：其他"
        }
 
        author = model.author
        
        if author!.is_shiming == 2{
            isrenameLabel.text = "已实名"
        }else{
            isrenameLabel.text = "未实名"
        }
        headImage.displayHeadImageWithURL(url: author?.avatar)
        
        if author?.nickname == ""{
            aunameLabel.text =  author!.real_name
        }else{
            aunameLabel.text =  author!.nickname
        }
        leftImage.layer.masksToBounds = true
        leftImage.layer.cornerRadius = 2
        leftImage.displayImageWithURL(url: model.image)
        nameLabel.text = model.name
        
        if checkMarketVer(){
            priceLabel.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            priceLabel.setTitle("发布于百度网盘", for: .normal)
            priceLabel.setTitleColor(UIColor.darkGray, for: .normal)
            priceLabel.setImage(nil, for: .normal)
        }else{
            priceLabel.setTitle(model.price, for: .normal)
            priceLabel.setImage(UIImage.init(named: "jifen"), for: .normal)
        }
       
       // infoLabel.text = "简介:" + model.info
        countLabel.text = "浏览:" + intToString(number:  model.browse) + "   " +  "下载:" + intToString(number: model.order_count)
        
    }
}
