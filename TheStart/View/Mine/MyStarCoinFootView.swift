//
//  MyStarCoinFootView.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/19.
//

import UIKit
protocol MyStarCoinFootViewDelegate {
    func buyAction()
 }



class MyStarCoinFootView: UICollectionReusableView {

    @IBOutlet weak var buyBtn: UIButton!
    
    var delegate: MyStarCoinFootViewDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        buyBtn.layer.masksToBounds = true
        buyBtn.layer.cornerRadius = 20
        
        // Initialization code
    }
    
    @IBAction func buyAction(_ sender: Any) {
        
        delegate.buyAction()
    }
}
