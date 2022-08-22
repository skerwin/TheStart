//
//  reCommentCell.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/08/14.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import EasyAtrribute

protocol ReCommentCellDelegate: AnyObject {
    func reComplainActiion(cmodel:CommentModel,onView:UIButton,index:IndexPath)
    func redelActiion(cmodel:CommentModel,onView:UIButton,index:IndexPath)
}

class reCommentCell: UITableViewCell {
    
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var contentlabel: UILabel!
    @IBOutlet weak var publishlabel: UILabel!
    
    @IBOutlet weak var delBtn: UIButton!
    @IBOutlet weak var complainBtn: UIButton!
    
    @IBOutlet weak var nameLableTV: EZTextView!
    
    var delegeta:ReCommentCellDelegate?
    var indexpath = IndexPath()
 
    @IBAction func complainActiion(_ sender: Any) {
        delegeta?.reComplainActiion(cmodel: model!,onView:complainBtn,index:indexpath)
    }
    @IBAction func delbtnActioon(_ sender: Any) {
        delegeta?.redelActiion(cmodel: model!,onView:complainBtn,index:indexpath)
        
    }
    
    var model:CommentModel? {
        didSet {
            headImage.displayHeadImageWithURL(url: model?.avatar)
            contentlabel.text = model?.comment
            publishlabel.text = model?.add_time
            
            nameLableTV.isEditable = false
            nameLableTV.isScrollEnabled = false
            
            if (model?.uid == getUserId()){
                delBtn.setTitle("删除", for: .normal)
            }else{
                delBtn.setTitle("举报", for: .normal)
            }
            nameLableTV
                .removeAllAttribute()
                .appendAttributedText(model!.nickname
                    .attribute()
                    .color(UIColor.init(hexString: "5776A7"))
                    .ez_font(UIFont.boldSystemFont(ofSize: 13))
                    .toEz())
             
                .appendAttributedText(" @ "
                    .attribute()
                    .color(UIColor.init(hexString: "5776A7"))
                    .ez_font(UIFont.boldSystemFont(ofSize: 13))
                    .toEz())
               .appendAttributedText(model!.r_nickname
                    .attribute()
                    .color(UIColor.init(hexString: "5776A7"))
                    .ez_font(UIFont.boldSystemFont(ofSize: 13))
                    .toEz()
                    .addAction{ [self] in
                        //self.showOnlyTextHUD(text: "点击隐私协议")
                    })
            
         }
    }
    
    func configModel(){
//        headImage.displayHeadImageWithURL(url: model?.users?.avatar_url)
//
//        if (model?.users?.user_nickname.isLengthEmpty())! {
//            nameLable.text = model?.users?.mobile
//        }else{
//            nameLable.text = model?.users?.user_nickname
//        }
//
//        var parentName = ""
//
//        if (model?.to_users?.user_nickname.isLengthEmpty())! {
//            parentName = model?.to_users?.mobile ?? ""
//        }else{
//            parentName = model?.to_users?.user_nickname ?? ""
//        }
//
//        let ranStr = "@" + parentName + "  "
//        let cintent = model?.content
//        let strg = ranStr + cintent!
//        let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:strg)
//        //颜色处理的范围
//        let str = NSString(string: strg)
//        let theRange = str.range(of: ranStr)
//        //颜色处理
//        attrstring.addAttribute(NSAttributedString.Key.foregroundColor, value:ZYJColor.main, range: theRange)
//        //行间距
//        let paragraphStye = NSMutableParagraphStyle()
//
//        paragraphStye.lineSpacing = 5
//        //行间距的范围
//        let distanceRange = NSMakeRange(0, CFStringGetLength(strg as CFString?))
//
//        attrstring .addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStye, range: distanceRange)
//        contentlabel.attributedText = attrstring//赋值方法
//
//        publishlabel.text = model?.format_create_time
            //DateUtils.timeStampToStringDetail("\(String(describing: model!.created_at))")
    }
         
    override func awakeFromNib() {
        super.awakeFromNib()
        headImage.layer.cornerRadius = 13;
        headImage.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
