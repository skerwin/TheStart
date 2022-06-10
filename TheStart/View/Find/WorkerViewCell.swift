//
//  WorkerViewCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/20.
//

import UIKit

protocol WorkerViewCellDelegate {
    func WorkerCellCommunicateAction(mobile:String)
}


class WorkerViewCell: UITableViewCell {

    var delegate: WorkerViewCellDelegate!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var needsLabel: UILabel!
    
    @IBOutlet weak var communiteBtn: UIButton!
    
    @IBOutlet weak var headImg: UIImageView!
    
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var pubtimeLabel: UILabel!
    
    @IBAction func communiteBtnAction(_ sender: Any) {
        delegate.WorkerCellCommunicateAction(mobile: model!.mobile)
    }
    
    var model:JobModel? {
        didSet {
            titleLabel.text = model!.title
            var cateName = model!.cate
            if cateName == ""{
                cateName = model!.cate_name
            }
            if model!.gender == "保密" || model!.gender == "不限"{
                
                needsLabel.text = cateName
            }else{
                needsLabel.text = cateName + "   " + model!.gender
            }
            headImg.displayImageWithURL(url: model?.avatar)
            nickname.text = model!.nickname
            pubtimeLabel.text = model!.add_time + "发布"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        communiteBtn.layer.masksToBounds = true
        communiteBtn.layer.cornerRadius = 3
        
        headImg.layer.masksToBounds = true
        headImg.layer.cornerRadius = 5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
