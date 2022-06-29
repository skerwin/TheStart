//
//  TipOffListCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/17.
//

import UIKit

class TipOffListCell: UITableViewCell {

    
    
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
    @IBOutlet weak var imageV2: UIImageView!
    @IBOutlet weak var imageV3: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        tipsLabel.layer.masksToBounds = true
        tipsLabel.layer.cornerRadius = 2
        addGestureRecognizerIgnoreTableView(view: imageV1, target: self, actionName: "imageV1Action")
        addGestureRecognizerIgnoreTableView(view: imageV2, target: self, actionName: "imageV2Action")
        addGestureRecognizerIgnoreTableView(view: imageV3, target: self, actionName: "imageV3Action")
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
             
            
            //headImage.sd_setImage(with: model?.avatar)

            //headImage.displayHeadImageWithURL(url: model?.avatar)
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
           
//            if model?.images.count == 1{
//                //imageV1.displayImageWithURL(url: model?.images.first)
//            }else if  model?.images.count == 2 {
//                //imageV1.displayImageWithURL(url: model?.images.first)
//                //imageV2.displayImageWithURL(url: model?.images[1])
//            }else{
            imageV1.displayImageWithURL(url: model?.images.first)
            imageV2.displayImageWithURL(url: model?.images[1])
            imageV3.displayImageWithURL(url: model?.images[2])
            //}
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
    @objc private func imageV2Action() {
          EWImageAmplification.shared.scanBigImageWithImageView(currentImageView: imageV2, alpha: 1)
    }
    @objc private func imageV3Action() {
          EWImageAmplification.shared.scanBigImageWithImageView(currentImageView: imageV3, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
