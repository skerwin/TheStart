//
//  TipOffListCell1.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/02.
//

import UIKit

import UIKit

class TipOffListCell1: UITableViewCell {

    
    
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var visitLabel: UILabel!
    
    @IBOutlet weak var likeLbael: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var comentLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imageV1: UIImageView!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        tipsLabel.layer.masksToBounds = true
        tipsLabel.layer.cornerRadius = 2
        addGestureRecognizerIgnoreTableView(view: imageV1, target: self, actionName: "imageV1Action")
       
    }
    var model:TipOffModel? {
        didSet {
            
            if model?.type == 1{
                tipsLabel.text = "嘿人曝光"
                tipsLabel.backgroundColor = colorWithHexString(hex: "903207")
            }else{
                tipsLabel.backgroundColor = colorWithHexString(hex: "E19522")
                tipsLabel.text = "澄清声明"
            }
             
          //  headImage.displayHeadImageWithURL(url: model?.avatar)
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
           
            imageV1.displayImageWithURL(url: model?.images.first)
         
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
    
    @objc private func imageV1Action() {
           EWImageAmplification.shared.scanBigImageWithImageView(currentImageView: imageV1, alpha: 1)
     }
   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
