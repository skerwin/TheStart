//
//  MusicDetailHeader.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/09.
//

import UIKit
import SwiftUI

class MusicDetailHeader: UIView {

    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UIButton!
    
   // @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    

    func configModel(model:AudioModel){
        leftImage.layer.masksToBounds = true
        leftImage.layer.cornerRadius = 2
        leftImage.displayImageWithURL(url: model.image)
        nameLabel.text = model.name
        
        if checkMarketVer(){
            priceLabel.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            priceLabel.setTitle("发布于百度网盘", for: .normal)
            priceLabel.setTitleColor(UIColor.darkGray, for: .normal)
            priceLabel.setImage(nil, for: .normal)
        }else{
            priceLabel.setTitle(model.price, for: .normal)
            priceLabel.setImage(UIImage.init(named: "jifen"), for: .normal)
        }
       
       // infoLabel.text = "简介:" + model.info
        countLabel.text = "浏览:" + intToString(number:  model.browse) + "   " +  "下载:" + intToString(number: model.order_count)
        
    }
}
