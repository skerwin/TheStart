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
       
        introLabel.font = UIFont.boldSystemFont(ofSize: 16)
        // Initialization code
    }
    
  
    
    func configAudioCell(model:AudioModel){
        introLabel.text = "音乐详情"
         contentLabel.text = model.info
        
    }
    func configCell(model:JobModel,isjob:Bool){
        if isjob {
            introLabel.text = "项目详情"
            contentLabel.text = model.detail
        }else{
            introLabel.text = "自我介绍"
            contentLabel.text = model.detail
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
