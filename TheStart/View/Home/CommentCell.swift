//
//  CommentCell.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/08/12.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

protocol CommentCellDelegate: class {
    func complainActiion(cmodel:CommentModel,onView:UIButton)
 
    func commentACtion(cmodel:CommentModel,section:Int)
   
}

class CommentCell: UITableViewCell {

    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var contentlabel: UILabel!
    @IBOutlet weak var publishlabel: UILabel!
    
    @IBOutlet weak var complainBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    var delegeta:CommentCellDelegate?
    @IBOutlet weak var lineView: UIView!
    
    var model:CommentModel?
    
    var sectoin = 0
    
    @IBAction func complainActiion(_ sender: Any) {
        delegeta?.complainActiion(cmodel: model!,onView:complainBtn)
    }
    @IBAction func commentACtion(_ sender: Any) {
        delegeta?.commentACtion(cmodel: model!,section: sectoin)
    }

    func configModel(){
 
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headImage.layer.cornerRadius = 18;
        headImage.layer.masksToBounds = true
        
     }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
