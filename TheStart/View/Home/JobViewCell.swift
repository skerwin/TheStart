//
//  JobViewCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/19.
//

import UIKit

class JobViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var needsLabel: UILabel!
    
    @IBOutlet weak var communiteBtn: UIButton!
    
    @IBOutlet weak var headImg: UIImageView!
    
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var pubtimeLabel: UILabel!
    
    @IBAction func communiteBtnAction(_ sender: Any) {
    }
    
    var model:JobModel? {
        didSet {
            titleLabel.text = model?.title
            needsLabel.text = "DJ" + "   " + "男性"
            //model?.cateValue + model?.gender
            headImg.displayImageWithURL(url: model?.avatar)
            nickname.text = model?.nickname
            pubtimeLabel.text = model!.add_time + "发布"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        communiteBtn.layer.masksToBounds = true
        communiteBtn.layer.cornerRadius = 3
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
