//
//  WorkerInfoCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/18.
//

import UIKit

class WorkerInfoCell: UITableViewCell {

    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
        // Initialization code
    }
    func configCell(isjob:Bool){
        if isjob {
            introLabel.text = "项目详情"
            introLabel.font = UIFont.systemFont(ofSize: 16)
        }else{
            introLabel.font = UIFont.boldSystemFont(ofSize: 16)
            introLabel.text = "自我介绍"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
