//
//  VipCenterHeader1.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/11.
//

import UIKit

protocol VipCenterHeader1Delegate {
    func sureOpenAction()
 }


class VipCenterHeader1: UICollectionReusableView {
    
    var delegate: VipCenterHeader1Delegate!
    
    @IBOutlet weak var isVipLabel: UIImageView!
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var vipNumLabel: UILabel!
    @IBOutlet weak var isKaitongLabel: UIButton!
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var sureOpen: UIButton!
    
    
    
    @IBAction func sureOpenAction(_ sender: Any) {
        delegate.sureOpenAction()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
