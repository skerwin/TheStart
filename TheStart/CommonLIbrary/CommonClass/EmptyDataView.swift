//
//  EmptyDataView.swift
 //
//  Created by YuliangTao on 16/8/12.
//  Copyright © 2016年 Berchina.Mobile. All rights reserved.
//

import UIKit

protocol EmptyDataViewDelegate {
    func retryAction()
}

class EmptyDataView: UIView {
    
    var delegate: EmptyDataViewDelegate!

    
    @IBOutlet weak var tipsImageView: UIImageView!
    @IBOutlet weak var tipsLabel: UILabel!
 
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 
    
}
