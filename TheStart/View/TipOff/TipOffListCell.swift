//
//  TipOffListCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/17.
//

import UIKit

class TipOffListCell: UITableViewCell {

    
    
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var imageV1: UIImageView!
    @IBOutlet weak var imageV2: UIImageView!
    @IBOutlet weak var imageV3: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        addGestureRecognizerIgnoreTableView(view: imageV1, target: self, actionName: "imageV1Action")
        addGestureRecognizerIgnoreTableView(view: imageV2, target: self, actionName: "imageV2Action")
        addGestureRecognizerIgnoreTableView(view: imageV3, target: self, actionName: "imageV3Action")
    }
    
    @objc private func imageV1Action() {
           EWImageAmplification.shared.scanBigImageWithImageView(currentImageView: imageV1, alpha: 1)
     }
    @objc private func imageV2Action() {
          EWImageAmplification.shared.scanBigImageWithImageView(currentImageView: imageV2, alpha: 1)
    }
    @objc private func imageV3Action() {
          EWImageAmplification.shared.scanBigImageWithImageView(currentImageView: imageV3, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
