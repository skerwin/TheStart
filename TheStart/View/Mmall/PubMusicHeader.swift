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
    
    override func awakeFromNib(){
         
        
        let attributedName = NSAttributedString.init(string: "请输入音乐名称", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        nameTV.attributedPlaceholder = attributedName
        
        let attributedMoney = NSAttributedString.init(string: "请输入音乐价格", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
         MoneyTF.attributedPlaceholder = attributedMoney
        
        let attributedWangpan = NSAttributedString.init(string: "请输入网盘链接", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        wanpanTV.attributedPlaceholder = attributedWangpan
        
        let attributedCode = NSAttributedString.init(string: "请输入提取码", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        wangpanCode.attributedPlaceholder = attributedCode
        
    }

}
