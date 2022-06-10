//
//  ChargeRecordCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/23.
//

import UIKit

class ChargeRecordCell: UITableViewCell {

    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tiemLabel: UILabel!
    
    @IBOutlet weak var orderLabel: UILabel!
    
    @IBOutlet weak var orderType: UILabel!
    
    
    @IBOutlet weak var zhifuLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var model:OrderModel? {
        didSet {
            nameLabel.text = model!.price + "星币"
            tiemLabel.text = model?.add_time
            orderLabel.text = "订单号:" + model!.order_id
            
            if model?.pay_type == 1 {
                orderType.text = "支付方式:微信支付"
               
            }else{
                orderType.text = "支付方式:支付宝"
            }
            zhifuLabel.text = "实付:" + model!.price
            
          
        }
    }
    
}
