//
//  WokerPubIntroCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/18.
//

import UIKit

class WokerPubIntroCell: UITableViewCell,UITextViewDelegate {
    
    
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var contentTV: UITextView!
    @IBOutlet weak var textViewHeightConstant: NSLayoutConstraint!
    
    var tableview:UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentTV.layer.masksToBounds = true
        contentTV.layer.cornerRadius = 15
        self.backgroundColor = ZYJColor.main
        self.contentView.backgroundColor = ZYJColor.main
        self.contentTV.placeHolder = "请介绍一下您或填写您的工作经历～～";
        contentTV.delegate = self
    }
    func textViewDidChange(_ textView: UITextView) {
        let toBeString:String = textView.text!
        let height:CGFloat = toBeString.getStringSize(width: self.contentTV.frame.size.width, fontSize: 15).height
        if height >= 85{
            self.textViewHeightConstant.constant = height + 8;
        }else{
            self.textViewHeightConstant.constant = 95;
        }
        self.tableview.beginUpdates()
        self.tableview.endUpdates()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
