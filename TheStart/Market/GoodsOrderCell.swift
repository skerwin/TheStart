//
//  GoodsOrderCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/26.
//

import UIKit

class GoodsOrderCell: UITableViewCell {

    @IBOutlet weak var leftImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var orderLabel: UILabel!
    
    @IBOutlet weak var orderType: UILabel!
    
    @IBOutlet weak var orderType2: UILabel!
    
    @IBOutlet weak var zhifuLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        orderType.layer.masksToBounds = true
        orderType.layer.cornerRadius = 5
        
        orderType2.layer.masksToBounds = true
        orderType2.layer.cornerRadius = 5
    }
 

    func config(model:OrderModel){
        
        orderType.isHidden = true
        orderType2.isHidden = true
        
        if model.order_status == 1{
            orderType.isHidden = false
            orderType2.isHidden = false
        }
        
        leftImage.displayImageWithURL(url: model.image)
        nameLabel.text = model.goods_name
        orderLabel.text = "订单时间:" + model.add_time
    
        zhifuLabel.text = "实付:" + model.price
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
