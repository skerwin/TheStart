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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageV.layer.masksToBounds = true
        imageV.layer.cornerRadius = 5
        // Initialization code
    }

}
