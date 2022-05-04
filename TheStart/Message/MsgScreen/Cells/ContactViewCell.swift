//
//  ContactViewCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/21.
//

import UIKit

class ContactViewCell: UITableViewCell {

    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var firstContentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        headImg.layer.masksToBounds = true
        headImg.layer.cornerRadius = 5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
