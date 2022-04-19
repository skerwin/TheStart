//
//  TipOffpootContentCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/16.
//

import UIKit

class TipOffpootContentCell: UITableViewCell,UITextViewDelegate {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var contentTV: UITextView!
    @IBOutlet weak var textViewHeightConstant: NSLayoutConstraint!
    
    var tableview:UITableView!
    
    let maxFontNum = 1000
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = ZYJColor.main
        self.contentView.backgroundColor = ZYJColor.main
        countLabel.text = "0" + "/" + "\(maxFontNum)"
        self.contentTV.placeHolder = "写标题并使用合适的话题，让更多人看到～～";
        contentTV.delegate = self
    }
    func textViewDidChange(_ textView: UITextView) {
        let toBeString:String = textView.text!
        // 获取键盘输入模式
        let lang = UIApplication.shared.textInputMode?.primaryLanguage
        
        if lang == "zh-Hans" { // zh-Hans代表简体中文输入，包括简体拼音，健体五笔，简体手写
            if textView.markedTextRange != nil{
                let selectedRange = textView.markedTextRange!
                let position = textView.position(from: selectedRange.start, offset: 0)
                // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
                if (position == nil) {
                    if toBeString.count > maxFontNum {
                        let text = toBeString.prefix(maxFontNum)
                        textView.text = String(text)
                        countLabel.text = "\(maxFontNum)" + "/" + "\(maxFontNum)"
                    }else{
                        countLabel.text = "\(toBeString.count)" + "/" + "\(maxFontNum)"
                    }
                }
            }else{
                if toBeString.count > maxFontNum {
                    let text = toBeString.prefix(maxFontNum)
                    textView.text = String(text)
                    countLabel.text = "\(maxFontNum)" + "/" + "\(maxFontNum)"
                }else{
                    countLabel.text = "\(toBeString.count)" + "/" + "\(maxFontNum)"
                }
            }
            
            let height:CGFloat = toBeString.getStringSize(width: self.contentTV.frame.size.width, fontSize: 17).height
            if height >= 70{
                self.textViewHeightConstant.constant = height + 20;
            }else{
                self.textViewHeightConstant.constant = 80;
            }
            self.tableview.beginUpdates()
            self.tableview.endUpdates()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
