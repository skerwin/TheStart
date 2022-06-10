//
//  VipCenterHeader1.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/11.
//

import UIKit

protocol VipCenterHeader1Delegate {
    func sureOpenAction()
 }


class VipCenterHeader1: UICollectionReusableView {
    
    var delegate: VipCenterHeader1Delegate!
    
    @IBOutlet weak var isVipLabel: UIImageView!
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var vipNumLabel: UILabel!
    @IBOutlet weak var isKaitongLabel: UIButton!
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var sureOpen: UIButton!
    
    
    
    @IBAction func sureOpenAction(_ sender: Any) {
        delegate.sureOpenAction()
    }
    
    func configModel(user:UserModel){
        headImage.displayHeadImageWithURL(url: user.avatar)
        nameLabel.text = user.nickname
        
        if user.vip == 1{
            isVipLabel.isHidden = false
            vipNumLabel.text = "NO." + intToString(number: user.vip_id)
            isKaitongLabel.setTitle("已开通", for: .normal)
            isKaitongLabel.setTitleColor(ZYJColor.coinColor, for: .normal)
            tipLabel.text = "您已开通年会员正在享受全部会员权益"
            sureOpen.setTitle("您已开通年会员", for: .normal)
            sureOpen.isEnabled = false
        }else{
            isVipLabel.isHidden = true
            vipNumLabel.text = "NO." + "--"
            isKaitongLabel.setTitle("未开通", for: .normal)
            isKaitongLabel.setTitleColor(UIColor.white, for: .normal)
            tipLabel.text = "98元开通年会员即可享受全部会员权益"
            sureOpen.setTitle("98¥ 确认开通年会员", for: .normal)
            sureOpen.isEnabled = true
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
