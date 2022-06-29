//
//  GoodDetailHeader.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/25.
//

import UIKit

class GoodDetailHeader: UIView {

    
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var saleCountLabel: UILabel!
    
    
    func configModel(model:GoodsModel){
     
        leftImage.displayImageWithURL(url: model.image)
        priceLabel.text = "价格:" + model.price
        nameLabel.text = "商品名称:" + model.goods_name
        descLabel.text = "商品简介:" + model.description
        saleCountLabel.text = "销量: " + intToString(number: model.sales_num)
 
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
     价格:  ¥300.00
     商品名称:   百威啤酒
     商品简介:商品是为了出售而生产的劳动成果，是人类社会生产力发展到一定历史阶段的产物，是用于交换的劳动产品。
    */
    
    //

}
