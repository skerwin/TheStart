//
//  TipOffListNoImgCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/17.
//

import UIKit

class TipOffListNoImgCell: UITableViewCell {

    
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
