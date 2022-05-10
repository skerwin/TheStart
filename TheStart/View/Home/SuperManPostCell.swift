//
//  SuperManPostCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/29.
//

import UIKit

class SuperManPostCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        postImage.layer.masksToBounds = true
        postImage.layer.cornerRadius = 10
        //postImage.image = UIImage.init(named: "111222.jpg")
        // Initialization code
    }
    
    var model:TipOffModel? {
        didSet {
            if model?.images.count != 0{
                postImage.displayImageWithURL(url: model?.images.first)
            }
            
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
