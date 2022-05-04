//
//  TipOffContentView.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/15.
//

import UIKit


protocol TipOffContentViewDelegate {
    func clarifyBtnAction()
  
}
class TipOffContentView: UITableViewCell {

    @IBOutlet weak var clarifyBtn: UIButton!
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var vistiLabel: UILabel!
    
    @IBOutlet weak var contextLabel: UILabel!
    var delegate: TipOffContentViewDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    var model:TipOffModel? {
        didSet {
           
            if model?.title != ""{
                contextLabel.text = model!.title + "\n" + "\n" + model!.content
            }else{
                contextLabel.text = model?.content
            }
           
            vistiLabel.text = "浏览:" + "\(String(describing: model!.visit))"
            commentLabel.text = "赞:" + "\(String(describing: model!.dianzan))"
            
            if model?.type == 3{
                clarifyBtn.isHidden = true
            }else{
                if model?.clarify_count != 0{
                    clarifyBtn.setTitle("查看" + "\(String(describing: model!.clarify_count))" + "篇澄清声明" , for: .normal)
                }else{
                    clarifyBtn.isHidden = true
                }
            }
           
           
         }
    }
    
    @IBAction func clarifyBtnAction(_ sender: Any) {
        delegate.clarifyBtnAction()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
