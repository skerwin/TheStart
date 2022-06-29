//
//  UICollectionView+Extension.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/06/28.
//

import Foundation
import UIKit
 //// MARK: - UITableView的扩展
//

extension UICollectionView {
 
    
    func tableViewDisplayWithMsg(message: String , rowCount: Int, isdisplay: Bool = false) {
        if isdisplay {
            if rowCount == 0 {
                
                let emptyDataView = Bundle.main.loadNibNamed("EmptyDataView", owner: nil, options: nil)?.first as? EmptyDataView
                let emptyDataViewHeight: CGFloat = 245
                emptyDataView!.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: emptyDataViewHeight)
                emptyDataView!.tipsLabel.text = message
                self.backgroundView = emptyDataView
                
            } else {
                self.backgroundView = nil
            }
        }else{
            self.backgroundView = nil
        }
    }
    
}
 
