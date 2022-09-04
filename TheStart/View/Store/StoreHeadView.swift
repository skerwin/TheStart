//
//  StoreHeadView.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/08/21.
//

import UIKit
import SDCycleScrollView
import SwiftyJSON
import WMZDialog

protocol StoreHeadViewDelegate {
    
    func zhuliAction()
    func guanzhuAction()
 }
 

class StoreHeadView: UIView {

    @IBOutlet weak var bannView: SDCycleScrollView!
    @IBOutlet weak var zhuliBtn: UIButton!
    @IBOutlet weak var guanzhubtn: UIButton!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var browseNum: UILabel!
    
    @IBOutlet weak var moreImgView: UIView!
    
    @IBOutlet weak var phoneStrore: UIView!
    
    @IBOutlet weak var detailView: UIView!
    
   // @IBOutlet weak var commetNumlabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    var delegate:StoreHeadViewDelegate!
    
    var parentNavigationController: UINavigationController?
    
    
    var model = StoreModel()
    
    @IBAction func zhuliBtnAction(_ sender: Any) {
        delegate.zhuliAction()
    }
    @IBAction func guanzhubtnAction(_ sender: Any) {
        delegate.guanzhuAction()
    }
    
    func configModel(model:StoreModel){
        
        self.model = model
        let imageArrTemp = model.images
        bannView.pageControlAliment = SDCycleScrollViewPageContolAliment(rawValue: 1)
        bannView.pageControlStyle = SDCycleScrollViewPageContolStyle(rawValue: 1)
        bannView.backgroundColor = ZYJColor.main
        bannView.imageURLStringsGroup = imageArrTemp
        
        scoreLabel.text = intToString(number: model.prestige)
        browseNum.text = intToString(number: model.click)
        
        addressLabel.text = model.address
       // commetNumlabel.text = "用户评价(" + intToString(number: model.reply_count) + ")"
        
        if model.if_perstige == 0{
            zhuliBtn.setTitle("助力一下", for: .normal)
        }else{
            zhuliBtn.setTitle("已助力", for: .normal)
        }
        
        if model.if_follow == 0{
            guanzhubtn.setTitle("关注", for: .normal)
        }else{
            guanzhubtn.setTitle("已关注", for: .normal)
        }
    }
    
    override func awakeFromNib(){
        
        zhuliBtn.addcornerRadius(radius: 15)
        guanzhubtn.addcornerRadius(radius: 15)
        addGestureRecognizerToView(view: moreImgView, target: self, actionName: "moreImgViewAction")
        addGestureRecognizerToView(view: phoneStrore, target: self, actionName: "phoneStrorection")
        addGestureRecognizerToView(view: detailView, target: self, actionName: "detailViewAction")
        
     }
    
    @objc private func moreImgViewAction() {
        let controller = PhotoBrowserViewController()
        controller.images = self.model!.images
        self.parentNavigationController?.pushViewController(controller, animated: true)
    }
 
    @objc private func phoneStrorection() {
             let dialog = Dialog()
            dialog
                .wShowAnimationSet()(AninatonZoomIn)
                .wHideAnimationSet()(AninatonZoomOut)
                .wEventCancelFinishSet()(
                    {(anyID:Any?,otherData:Any?) in
                        UIPasteboard.general.string = self.model!.we_chat
                        DialogueUtils.showSuccess(withStatus: "复制成功")
                    }
                )
                .wEventOKFinishSet()(
                    { [self](anyID:Any?,otherData:Any?) in
                        UIPasteboard.general.string = self.model!.tel
                        DialogueUtils.showSuccess(withStatus: "复制成功")
                    }
                )
                .wTitleSet()("获取成功")
                .wMessageSet()("联系电话:" + self.model!.tel + "\n" + "联系微信:" + self.model!.we_chat)
                .wOKTitleSet()("复制电话号")
                .wCancelTitleSet()("复制微信号")
                .wMessageColorSet()(UIColor.black)
                .wTitleColorSet()(UIColor.black)
                .wOKColorSet()(UIColor.systemBlue)
                .wCancelColorSet()(UIColor.systemBlue)
                .wTitleFontSet()(17)
                .wMessageFontSet()(16)
                .wTypeSet()(DialogTypeNornal)
            _ = dialog.wStart()
     }
    
    @objc private func detailViewAction() {
            let controller = NotifyWebDetailController()
            controller.urlString = model?.h5_url
            self.parentNavigationController?.pushViewController(controller, animated: true)
     }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
