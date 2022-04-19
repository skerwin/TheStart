//
//  UITextField+Extension.swift
 //
//  Created by YuliangTao on 16/3/1.
//  Copyright © 2016年 Berchina.Mobile. All rights reserved.
//  UITextField的扩展

import UIKit

class CustomTextField: UITextField {


    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let inset = CGRect.init(x: bounds.origin.x + 30, y: bounds.origin.y, width: bounds.size.width - 10, height: bounds.size.height)
       // let inset = CGRectMake(bounds.origin.x + 30, bounds.origin.y, bounds.size.width - 10, bounds.size.height)
        return inset
    }
}
 
