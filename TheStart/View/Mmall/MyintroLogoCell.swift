//
//  MyintroLogoCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/08/22.
//

import UIKit

class MyintroLogoCell: UITableViewCell {

    @IBOutlet weak var logoimg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        logoimg.addcornerRadius(radius: 40)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
