//
//  CashOutCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/10.
//

import UIKit

class CashOutCell: UITableViewCell {

    @IBOutlet weak var bankNamelabel: UILabel!
    @IBOutlet weak var addTimelabel: UILabel!
    @IBOutlet weak var priceLbael: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    
    var model:CashOutModel? {
        didSet {
    
            bankNamelabel.text = model!.bank_name + "  " + model!.bank_realname
            addTimelabel.text = model?.add_time
            priceLbael.text = "提现" +  model!.extract_price
            if model?.status == -1{
                statusLabel.text = "未通过"
            }else if model?.status == 0{
                statusLabel.text = "提现中"
            }else if model?.status == 1{
                statusLabel.text = "已提现"
            }
            else{
                statusLabel.text = "联系客服"
            }
                
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
