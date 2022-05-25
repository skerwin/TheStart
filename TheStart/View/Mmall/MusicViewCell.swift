//
//  MusicViewCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/19.
//

import UIKit

class MusicViewCell: UICollectionViewCell {

    @IBOutlet weak var imageV: UIImageView!
    
    
    @IBOutlet weak var moneyLabel: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    var model:AudioModel? {
        didSet {
            moneyLabel.titleLabel?.text = model?.price
            moneyLabel.setTitle(model?.price, for: .normal)
            nameLabel.text = model!.name
            imageV.displayImageWithURL(url: model?.image)
            
        }
    }
    
    func configModel(model:GoodsModel){
        moneyLabel.titleLabel?.text = model.price
        moneyLabel.setTitle( "¥" + model.price, for: .normal)
        nameLabel.text = model.goods_name
        imageV.displayImageWithURL(url: model.image)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageV.layer.masksToBounds = true
        imageV.layer.cornerRadius = 5
        // Initialization code
    }

}
