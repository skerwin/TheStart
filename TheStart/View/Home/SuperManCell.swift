//
//  SubscribeCell.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/15.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit



protocol SuperManCellDelegate: NSObjectProtocol {
    func careBtnAction(num:Int)
}


class SuperManCell: UICollectionViewCell {
    
    @IBOutlet weak var typeLabe: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deseLabel: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var bgView: UIView!
    var num = 0
    
    weak var delegate: SuperManCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leftImage.layer.cornerRadius = 20;
        leftImage.layer.masksToBounds = true
        
        bgView.layer.cornerRadius = 15;
        bgView.layer.masksToBounds = true

    }
    var model:JobModel? {
        didSet {
            deseLabel.text = model?.title
            typeLabe.text = model!.cate + "   " + model!.gender
            leftImage.displayImageWithURL(url: model?.avatar)
            nameLabel.text = model?.nickname
        }
    }

 
}
