//
//  ResultAddViewCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/16.
//

import UIKit
import HXPHPicker

class ResultAddViewCell: PhotoPickerBaseViewCell {
    override func initView() {
        super.initView()
        self.backgroundColor = ZYJColor.main
        isHidden = false
        photoView.placeholder = UIImage.image(for: "hx_picker_add_img")
    }
}
