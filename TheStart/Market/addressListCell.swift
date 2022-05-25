//
//  addressListCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/25.
//

import UIKit

class addressListCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var defaultBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var model:AddressModel? {
        didSet {
            defaultBtn.isHidden = true
            if model?.is_default == 1{
                defaultBtn.isHidden = false
            }
            nameLabel.text = model!.real_name
            phoneLabel.text = model!.phone
            detailLabel.text = model!.province + model!.city + model!.district + model!.detail
 
        }
    }
    
}
