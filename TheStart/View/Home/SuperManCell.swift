//
//  SubscribeCell.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/15.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit



protocol SuperManCellDelegate: NSObjectProtocol {
    func careBtnAction(num:Int)
}


class SuperManCell: UICollectionViewCell {
    
    @IBOutlet weak var deseLabel: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var bgView: UIView!
    var num = 0
    
    weak var delegate: SuperManCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leftImage.layer.cornerRadius = 20;
        leftImage.layer.masksToBounds = true
        
        bgView.layer.cornerRadius = 15;
        bgView.layer.masksToBounds = true

    }


//    var model:SubscribeModel? {
//            didSet {
//
//                if model?.is_collect == 0{
//                    careBtn.titleLabel?.text = "订阅"
//                    careBtn.setTitle("订阅", for: .normal)
//                    careBtn.backgroundColor = ZYJColor.main
//                }else{
//                    careBtn.setTitle("已订阅", for: .normal)
//                    careBtn.titleLabel?.text = "已订阅"
//                    careBtn.backgroundColor = UIColor.lightGray
//                }
//
//
//                leftImage.displayImageWithURL(url: model!.cover)
//                deseLabel.text = model?.name
//                wenzhangCount.text = model!.article_count
//                bingliCount.text = model!.case_count
//                shipinCount.text = model!.video_count
//                //contentLabel.text =   + "文章·" + model!.case_count + "病例·" + model!.video_count + "视频"
//
//            }
//     }
}
