//
//  WorkerBaseInfo.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/18.
//

import UIKit

protocol WorkerBaseInfoDelegate {
    func WorkerCommunicateAction()
}

class WorkerBaseInfo: UIView {

  
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headImg: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isAuthLabel: UILabel!
    
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var delegate: WorkerBaseInfoDelegate!
    
    @IBOutlet weak var infoLabel: UILabel!
    
   
    @IBAction func phoneBtnAction(_ sender: Any) {
        delegate.WorkerCommunicateAction()
    }
    @IBOutlet weak var phoneBtn: UIButton!
    
    
    func configModel(model:JobModel){
        headImg.displayImageWithURL(url: model.avatar)
        nameLabel.text = model.nickname
        if model.is_shiming == 1{
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
    override func awakeFromNib(){
 
        phoneBtn.layer.masksToBounds = true
        phoneBtn.layer.cornerRadius = 15
        
        
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
