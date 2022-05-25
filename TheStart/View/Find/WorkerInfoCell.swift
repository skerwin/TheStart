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
    
    func configGoodsCell(model:GoodsModel,num:Int){
        introLabel.font = UIFont.systemFont(ofSize: 15)
        if num == 0{
            introLabel.font = UIFont.systemFont(ofSize: 16)
            introLabel.text = "商品详情"
            contentLabel.text = model.content.html2String
        
        }else if num == 1{
            introLabel.text = "上架时间"
            contentLabel.text = model.add_time
        }else{
            introLabel.text = "配送地址"
            contentLabel.text = "甘肃省兰州市城关区天水路曹家巷国贸大厦二期2606"
        }
       
        
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
