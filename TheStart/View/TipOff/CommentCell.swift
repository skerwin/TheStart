//
//  CommentCell.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/08/12.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit

protocol  CommentCellDelegate {
    func complainActiion(cmodel:CommentModel,section:Int)
    func commentACtion(cmodel:CommentModel,section:Int)
   
}

class CommentCell: UITableViewCell {

    var parentNavigationController: UINavigationController?

    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var contentlabel: UILabel!
    @IBOutlet weak var publishlabel: UILabel!
    
    @IBOutlet weak var complainBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    var delegeta:CommentCellDelegate?
    @IBOutlet weak var lineView: UIView!
    
    
    

    var sectoin = 0
    
    @objc private func tapOnheadImage() {
        let controller = MyHomePageController()
        controller.authorId = model!.uid
        self.parentNavigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func complainActiion(_ sender: Any) {
        delegeta?.complainActiion(cmodel: model!,section: sectoin)
    }
    @IBAction func commentACtion(_ sender: Any) {
        delegeta?.commentACtion(cmodel: model!,section: sectoin)
    }

    var model:CommentModel? {
        didSet {
            headImage.displayHeadImageWithURL(url: model?.avatar)
            nameLable.text = model?.nickname
            contentlabel.text = model?.comment
            publishlabel.text = model?.add_time
            
            if (model?.uid == getUserId()){
                complainBtn.setTitle("删除", for: .normal)
            }else{
                complainBtn.setTitle("举报", for: .normal)
            }
         }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headImage.layer.cornerRadius = 18;
        headImage.layer.masksToBounds = true
        addGestureRecognizerToView(view: headImage, target: self, actionName: "tapOnheadImage")
     }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
