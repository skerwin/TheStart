//
//  WokerPubHeaderView.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/18.
//

import UIKit

protocol  WokerPubHeaderViewDelegate {
    func jobTypeTextAction()
    func salaryTypeTextAction()
    func addressTypeTextAction()
    func sexTypeTextAction()
 }
 
class WokerPubHeaderView: UIView {

    
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var jobTypeLabel: UILabel!
    @IBOutlet weak var jobTypeText: UILabel!
    
    @IBOutlet weak var salaryTypeLabel: UILabel!
    @IBOutlet weak var salaryTypeText: UILabel!
    
    @IBOutlet weak var addressTypeLabel: UILabel!
    @IBOutlet weak var addressTypeText: UILabel!
    
    @IBOutlet weak var sexTypeLabel: UILabel!
    @IBOutlet weak var sexTypeText: UILabel!
    
 
    @IBOutlet weak var titleTypeLabel: UILabel!
    @IBOutlet weak var titleTextF: UITextField!
    
    @IBOutlet weak var phoneTypeText: UILabel!
    @IBOutlet weak var phoneTextF: UITextField!
    
    var delegate:WokerPubHeaderViewDelegate!

    
    override func awakeFromNib(){
 
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 15
        
        let attributedName = NSAttributedString.init(string: "请输入标题", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        titleTextF.attributedPlaceholder = attributedName
        
       let attributedPwd = NSAttributedString.init(string: "请输入电话号码", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        phoneTextF.attributedPlaceholder = attributedPwd
        
        addGestureRecognizerToView(view: jobTypeText, target: self, actionName: "jobTypeTextAction")
        addGestureRecognizerToView(view: salaryTypeText, target: self, actionName: "salaryTypeTextAction")
        addGestureRecognizerToView(view: addressTypeText, target: self, actionName: "addressTypeTextAction")
        addGestureRecognizerToView(view: sexTypeText, target: self, actionName: "sexTypeTextAction")
    }
     
    @objc func jobTypeTextAction(){
        delegate.jobTypeTextAction()
    }
    @objc func salaryTypeTextAction(){
        delegate.salaryTypeTextAction()
    }
    @objc func addressTypeTextAction(){
        delegate.addressTypeTextAction()
    }
    @objc func sexTypeTextAction(){
        delegate.sexTypeTextAction()
    }
    
    func initUI(type:Int){
        if type == 1{
            jobTypeLabel.text = "所需工种"
            salaryTypeLabel.text = "薪资范围"
            addressTypeLabel.text = "工作地点"
            titleTypeLabel.text = "找人标题"
        }else{
            jobTypeLabel.text = "所属工种"
            salaryTypeLabel.text = "期望薪资"
            addressTypeLabel.text = "期望工作地"
            titleTypeLabel.text = "找场标题"
        }
        
    }
  
}
