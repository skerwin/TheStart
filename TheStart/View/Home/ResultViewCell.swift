//
//  ResultViewCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/16.
//

import UIKit
import HXPHPicker


@objc protocol ResultViewCellDelegate: AnyObject {
    @objc optional func cell(didDeleteButton cell: ResultViewCell)
}


class ResultViewCell: PhotoPickerViewCell {
    weak var resultDelegate: ResultViewCellDelegate?
    lazy var deleteButton: UIButton = {
        let deleteButton = UIButton.init(type: .custom)
        deleteButton.setImage(UIImage.init(named: "hx_compose_delete"), for: .normal)
        deleteButton.hx.size = deleteButton.currentImage?.size ?? .zero
        deleteButton.addTarget(self, action: #selector(didDeleteButtonClick), for: .touchUpInside)
        return deleteButton
    }()
    override var photoAsset: PhotoAsset! {
        didSet {
            if photoAsset.mediaType == .photo {
                if let photoEdit = photoAsset.photoEdit {
                    // 隐藏被编辑过的标示
                    assetEditMarkIcon.isHidden = true
                    assetTypeMaskView.isHidden = photoEdit.imageType != .gif
                }
            }
        }
    }
    override func requestThumbnailImage() {
        // 因为这里的cell不会很多，重新设置 targetWidth，使图片更加清晰
        super.requestThumbnailImage(targetWidth: hx.width * UIScreen.main.scale)
    }
    @objc func didDeleteButtonClick() {
        resultDelegate?.cell?(didDeleteButton: self)
    }
    func hideDelete() {
        deleteButton.isHidden = true
    }
    override func initView() {
        super.initView()
        contentView.addSubview(deleteButton)
    }
    
    override func layoutView() {
        super.layoutView()
        deleteButton.hx.x = hx.width - deleteButton.hx.width
    }
}
