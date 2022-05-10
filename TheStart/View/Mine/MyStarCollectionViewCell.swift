//
//  MyStarCollectionViewCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/06.
//

import UIKit

class MyStarCollectionViewCell: UICollectionViewCell {

    
    
    @IBOutlet weak var coinBtn: UIButton!
    @IBOutlet weak var BgView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    //@IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        BgView.layer.masksToBounds = true
        BgView.layer.cornerRadius = 12
        priceLabel.layer.masksToBounds = true
        priceLabel.layer.cornerRadius = 10
        priceLabel.layer.borderWidth = 1
        priceLabel.layer.borderColor = UIColor.initcolorWithAlpha(value: 0xF1C14D).cgColor
        
        // Initialization code
    }
    
    var model:DictModel? {
        didSet {
             priceLabel.text =  "¥" + " " +  model!.give_money
            coinBtn.setTitle(model!.price, for: .normal)
            coinBtn.titleLabel!.text = model!.price
        }
    }

}
