////
////  UIColor+Extension.swift
////  BossJob
////
////  Created by zhaoyuanjing on 2017/09/27.
////  Copyright © 2017年 zhaoyuanjing. All rights reserved.
////
//
import Foundation
import UIKit
 //// MARK: - UITableView的扩展
//
extension UITableView {
 
    func tableViewDisplayWithMsg(message: String , rowCount: Int, isdisplay: Bool = false) {
        if isdisplay {
            if rowCount == 0 {
                let emptyDataView = Bundle.main.loadNibNamed("EmptyDataView", owner: nil, options: nil)?.first as? EmptyDataView
                let emptyDataViewHeight: CGFloat = 245
                emptyDataView!.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: emptyDataViewHeight)
                emptyDataView!.tipsLabel.text = message
                self.backgroundView = emptyDataView
                self.separatorStyle = UITableViewCell.SeparatorStyle.none
            } else {
                self.backgroundView = nil
            }
        }else{
            self.backgroundView = nil
        }
    
    }

    /**
     注册Nib，但是注意的是TableViewCell的Identifier要和类名保持一致

     - parameter name: TableViewCell的名字
     */
    func registerNibWithTableViewCellName(name: String) {
        register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }
//
    /**
     获取没有高亮效果的复用Cell
     */
    func dequeueCancelHighlightReusableCellWithIdentifier(identifier: String) -> UITableViewCell? {
        let cell = dequeueReusableCell(withIdentifier: identifier)
        cell?.selectionStyle = .none
        return cell
    }
//
//    func getGridViewRows(totalCount: Int) -> Int {
//        let gridViewRows = isNumberOdd(totalCount) ? totalCount / 2 + 1 : totalCount / 2
//        return gridViewRows
//    }
}
 
