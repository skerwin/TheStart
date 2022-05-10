//
//  HomeJobCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/29.
//

import UIKit

protocol JobHomeCellDelegate {
    func JobHomeCommunicateAction(mobile:String)
}

class HomeJobCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var needsLabel: UILabel!
    @IBOutlet weak var contactBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var delegate:JobHomeCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 10
        
        contactBtn.layer.masksToBounds = true
        contactBtn.layer.cornerRadius = 8
        // Initialization code
    }

    var model:JobModel? {
        didSet {
            titleLabel.text = model?.title
            needsLabel.text = model!.cate + "   " + model!.gender
            //model?.cateValue + model?.gender
            headImg.displayImageWithURL(url: model?.avatar)
            nameLabel.text = model?.nickname
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func contactBtnAction(_ sender: Any) {
        delegate.JobHomeCommunicateAction(mobile: "")
    }
}
