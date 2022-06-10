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
        
        self.layer.cornerRadius = 5;
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.2
        
        // Initialization code
    }
    
    var model:DictModel? {
        didSet {
            priceLabel.text =  "¥" + " " +  model!.price
            coinBtn.setTitle(model!.give_money + "星币", for: .normal)
            coinBtn.titleLabel!.text = model!.give_money + "星币"
          
        }
    }

}
