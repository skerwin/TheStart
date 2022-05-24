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
    
    @IBOutlet weak var orderType: UILabel!
    
    
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
            if model?.pay_type == "alipay" {
                orderType.text = "支付方式:支付宝"
            }else{
                orderType.text = "支付方式:微信支付"
            }
            zhifuLabel.text = "实付:" + model!.price
            
          
        }
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
