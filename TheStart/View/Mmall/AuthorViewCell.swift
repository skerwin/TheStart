//
//  AuthorViewCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/19.
//

import UIKit

class AuthorViewCell: UITableViewCell {

    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var workTypeLabel: UILabel!
    
    @IBOutlet weak var audioNunLabel: UILabel!
    
    @IBOutlet weak var vipImage: UIImageView!
    
    var model:AuthorModel? {
        didSet {
            if model?.is_vip == 1 && !checkMarketVer(){
                vipImage.isHidden = false
            }else{
                vipImage.isHidden = true
            }
            
            if model?.real_name == ""{
                namelabel.text = model?.nickname
            }else{
                namelabel.text = model?.real_name
            }
                
            headImage.displayImageWithURL(url: model?.avatar)
            workTypeLabel.text = model!.work_name
            audioNunLabel.text = "共发布了" + "\(String(describing: model!.audio_num))" + "首音乐作品"
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vipImage.isHidden = true
        headImage.layer.masksToBounds = true
        headImage.layer.cornerRadius = 29
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
