//
//  OrderCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/23.
//

import UIKit

class OrderCell: UITableViewCell {

    
    
    @IBOutlet weak var leftImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tiemLabel: UILabel!
    
    @IBOutlet weak var orderLabel: UILabel!
    
 
    @IBOutlet weak var zhifuLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model:OrderModel? {
        didSet {
            leftImage.displayImageWithURL(url: model?.image)
            nameLabel.text = model?.name
            tiemLabel.text = model?.add_time
            orderLabel.text = "订单号:" + model!.order_id
            if model?.vip_free == 1{
                zhifuLabel.text = "会员免费"
                
            }else{
                zhifuLabel.text = "星币:" + model!.price
            }
           
            
          
        }
    }

    func config(model:OrderModel){
        leftImage.displayImageWithURL(url: model.image)
        nameLabel.text = model.goods_name
        tiemLabel.isHidden = true
        tiemLabel.text = model.add_time
        orderLabel.text = "订单时间:" + model.add_time
         
        zhifuLabel.text = "星币:" + model.price
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
