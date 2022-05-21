//
//  AudioLinkInfoView.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/21.
//

import UIKit


protocol AudioLinkInfoViewDelegate {
    func buyBtnAction()
    func vipBtnAction()
}
 

class AudioLinkInfoView: UIView {

    var delegate:AudioLinkInfoViewDelegate!
    
    @IBOutlet weak var linkTv: UITextView!
    @IBOutlet weak var codeTv: UITextView!

    @IBAction func linkTvCopyAction(_ sender: Any) {
        UIPasteboard.general.string = self.linkTv.text
    }

    @IBAction func codeTvCopyAction(_ sender: Any) {
        UIPasteboard.general.string = self.codeTv.text
    }
    
    override func awakeFromNib(){
 
        linkTv.isEditable = false
        codeTv.isEditable = false
 
    }
}
