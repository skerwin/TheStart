//
//  TipOffListNoImgCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/17.
//

import UIKit

class TipOffListNoImgCell: UITableViewCell {

    
    @IBOutlet weak var vipImage: UIImageView!
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var visitLabel: UILabel!
    
    @IBOutlet weak var likeLbael: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var comentLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
 
    @IBOutlet weak var tip2Label: UILabel!
    var model:TipOffModel? {
        didSet {
            
            if model?.is_vip == 1 && !checkMarketVer(){
                vipImage.isHidden = false
            }else{
                vipImage.isHidden = true
            }
            if model?.type == 1{
                if model?.type1 == 2{
                    tipsLabel.text = "嘿场曝光"
                    tipsLabel.backgroundColor = colorWithHexString(hex: "903207")
                  
                }else{
                    tipsLabel.text = "嘿人曝光"
                    tipsLabel.backgroundColor = colorWithHexString(hex: "903207")
                }
               
            }else if model?.type == 3{
                tipsLabel.backgroundColor = colorWithHexString(hex: "E19522")
                tipsLabel.text = "澄清声明"
            }
            else if model?.type == 4{
                tipsLabel.backgroundColor = colorWithHexString(hex: "E19522")
                tipsLabel.text = "巅峰论坛"
            }else{
                
                tipsLabel.isHidden = true
            }
            headImage.displayHeadImageWithURL(url: model?.avatar)
            
            if model?.images.count != 0{
                tip2Label.text = "图文"
            }else{
                tip2Label.text = "文字"
            }
            nameLabel.text = model?.nickname
            if model?.title != ""{
                if model!.content == ""{
                    contentLabel.text = model!.title
                }else{
                    contentLabel.text = model!.title + "\n" + model!.content
                }
 
            }else{
                contentLabel.text = model?.content
            }
            timeLabel.text = model!.add_time + "发布"
            visitLabel.text = "浏览:" + "\(String(describing: model!.visit))"
            likeLbael.text = "赞:" + "\(String(describing: model!.dianzan))"
            comentLabel.text = "评论:" + "\(String(describing: model!.comment))"
            
            if model?.address == ""{
                addressLabel.text = "位置:" + "未知"
            }else{
                addressLabel.text = "位置:" + model!.address
            }
            
         }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vipImage.isHidden = true
        tipsLabel.layer.masksToBounds = true
        tipsLabel.layer.cornerRadius = 2
        tip2Label.layer.masksToBounds = true
        tip2Label.layer.cornerRadius = 2
        
        
        headImage.layer.masksToBounds = true
        headImage.layer.cornerRadius = 19
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
