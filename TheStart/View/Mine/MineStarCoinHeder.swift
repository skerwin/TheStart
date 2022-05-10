//
//  RegRecoSecHeder.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/10/30.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit

protocol MineStarCoinHederDelegate {
    func cashOut()
    func cashDone()
}

class MineStarCoinHeder: UICollectionReusableView {

    
    var delegate: MineStarCoinHederDelegate!
    @IBOutlet weak var cashOutBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cashDoneBtn: UIButton!
    
    @IBAction func cashDoneAction(_ sender: Any) {
        delegate.cashDone()
    }
    @IBAction func cashBtnAction(_ sender: Any) {
        delegate.cashOut()
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
