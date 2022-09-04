//
//  MusicViewCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/19.
//

import UIKit

class MusicViewCell: UICollectionViewCell {

    @IBOutlet weak var imageV: UIImageView!
    
    
    @IBOutlet weak var moneyLabel: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    var model:AudioModel? {
        didSet {
            if checkMarketVer(){
                moneyLabel.titleLabel?.font = UIFont.systemFont(ofSize: 13)
                moneyLabel.setTitle("浏览量:" + intToString(number: model!.browse), for: .normal)
                moneyLabel.titleLabel?.text = "浏览量:" + intToString(number: model!.browse)
                moneyLabel.setTitleColor(UIColor.lightGray, for: .normal)
                moneyLabel.setImage(UIImage.init(named: "yuedu"), for: .normal)
            }else{
                moneyLabel.titleLabel?.text = model?.price
                moneyLabel.setTitle(model?.price, for: .normal)
                moneyLabel.setImage(UIImage.init(named: "jifen"), for: .normal)
                
            }
            nameLabel.text = model!.name
            imageV.displayImageWithURL(url: model?.image)
            
        }
    }
    
    func configModel(model:GoodsModel){
        moneyLabel.titleLabel?.text = model.price
        moneyLabel.setTitle( "¥" + model.price, for: .normal)
        moneyLabel.setTitleColor(ZYJColor.coinColor, for: .normal)
        nameLabel.text = model.goods_name
        imageV.displayImageWithURL(url: model.image)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageV.layer.masksToBounds = true
        imageV.layer.cornerRadius = 5
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        // Initialization code
    }

}
