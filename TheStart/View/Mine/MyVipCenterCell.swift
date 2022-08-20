//
//  MyVipCenterCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/06.
//

import UIKit

class MyVipCenterCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var images: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 5;
        self.layer.shadowColor = ZYJColor.main.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.2
        // Initialization code
    }

}
