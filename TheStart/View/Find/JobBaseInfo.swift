//
//  JobBaseInfo.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/19.
//

import UIKit

protocol JobBaseInfoDelegate {
    func JobCommunicateAction()
}

class JobBaseInfo: UIView {

    
    var delegate: JobBaseInfoDelegate!
    @IBOutlet weak var headImg: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isAuthLabel: UILabel!
    
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var vipImage: UIImageView!
    @IBAction func phoneBtnAction(_ sender: Any) {
        delegate.JobCommunicateAction()
    }
    @IBOutlet weak var phoneBtn: UIButton!
    
    
    func configModel(model:JobModel){
        
        
        if model.is_vip == 1 && !checkMarketVer(){
            vipImage.isHidden = false
        }else{
            vipImage.isHidden = true
        }
        
        headImg.displayImageWithURL(url: model.avatar)
        nameLabel.text = model.nickname
        if model.is_shiming == 2{
            isAuthLabel.text = "已实名"
        }else{
            isAuthLabel.text = "未实名"
        }
        jobLabel.text = model.cate_name
        salaryLabel.text = model.salary_value
        addressLabel.text = model.city
        timeLabel.text = model.add_time + "发布"
        titleLabel.text = model.title
        
    }
    @objc private func tapOnImageheadImage() {
         
          EWImageAmplification.shared.scanBigImageWithImageView(currentImageView: headImg, alpha: 1)
    }
    override func awakeFromNib(){
 
        vipImage.isHidden = true
        phoneBtn.layer.masksToBounds = true
        phoneBtn.layer.cornerRadius = 5
        
        addGestureRecognizerToView(view: headImg, target: self, actionName: "tapOnImageheadImage")
        isAuthLabel.layer.masksToBounds = true
        isAuthLabel.layer.cornerRadius = 8
        isAuthLabel.layer.borderWidth = 1
        isAuthLabel.textColor = ZYJColor.blueTextColor
        isAuthLabel.layer.borderColor = ZYJColor.blueTextColor.cgColor
        
     
    }
   
}
