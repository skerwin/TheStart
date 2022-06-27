//
//  PubMusicHeader.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/19.
//

import UIKit

class PubMusicHeader: UIView {

    @IBOutlet weak var nameTV: UITextField!
    @IBOutlet weak var MoneyTF: UITextField!
    @IBOutlet weak var wanpanTV: UITextField!
    @IBOutlet weak var wangpanCode: UITextField!
    
    @IBOutlet weak var BGView: UIView!
    @IBOutlet weak var yesBtn: UIButton!
    
    @IBOutlet weak var nobtn: UIButton!
    
    var isFree = -1
    
    @IBOutlet weak var privateLabel1: UILabel! //音乐价格(金币):
    
    @IBOutlet weak var privateLabel2: UILabel! //会员免费下载
    
    
    
    
    override func awakeFromNib(){
         
 
        BGView.layer.masksToBounds = true
        BGView.layer.cornerRadius = 15
        
        
        if checkMarketVer(){
            privateLabel1.text = "音乐类型:"
            privateLabel2.text = "是否为原创音乐"
            let attributedMoney = NSAttributedString.init(string: "请输入音乐类型", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
             MoneyTF.attributedPlaceholder = attributedMoney
            MoneyTF.keyboardType = .default
        }else{
            privateLabel1.text = "音乐价格(金币):"
            privateLabel2.text = "会员免费下载"
            let attributedMoney = NSAttributedString.init(string: "请输入音乐价格", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
             MoneyTF.attributedPlaceholder = attributedMoney
             MoneyTF.keyboardType = .numberPad
        }
        
     
        
        let attributedName = NSAttributedString.init(string: "请输入音乐名称", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        nameTV.attributedPlaceholder = attributedName
        
      
        
        let attributedWangpan = NSAttributedString.init(string: "请输入网盘链接", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        wanpanTV.attributedPlaceholder = attributedWangpan
        
        let attributedCode = NSAttributedString.init(string: "请输入提取码", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        wangpanCode.attributedPlaceholder = attributedCode
        
        isFree = 0
        nobtn.setImage(UIImage.init(named: "quanYES"), for: .normal)
        yesBtn.setImage(UIImage.init(named: "quanNO"), for: .normal)
        
    }

    @IBAction func yesBtnAction(_ sender: Any) {
        isFree = 1
        yesBtn.setImage(UIImage.init(named: "quanYES"), for: .normal)
        nobtn.setImage(UIImage.init(named: "quanNO"), for: .normal)
    }
    
    @IBAction func noBtnAction(_ sender: Any) {
        isFree = 0
        nobtn.setImage(UIImage.init(named: "quanYES"), for: .normal)
        yesBtn.setImage(UIImage.init(named: "quanNO"), for: .normal)
    }
    
}
