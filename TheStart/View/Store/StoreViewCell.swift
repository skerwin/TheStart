//
//  StoreViewCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/08/20.
//

import UIKit

class StoreViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imagev: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imagev.layer.masksToBounds = true
        imagev.layer.cornerRadius = 5
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        // Initialization code
    }
    var model:StoreModel? {
        didSet {
            imagev.displayImageWithURL(url: model?.image)
            nameLabel.text = model?.name
            scoreLabel.setTitle("声望值:" + intToString(number:model!.prestige), for: .normal)
        }
    }

}
