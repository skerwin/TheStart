//
//  GuideCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/28.
//

import UIKit

protocol GuideCellDelegate {
    func findWorkerViewAction()
    func findJobViewAction()
    func tipOffVIewAction()
    func superManViewAction()
}


class GuideCell: UITableViewCell {

    @IBOutlet weak var findWorkerView: UIView!
    
    @IBOutlet weak var findJobView: UIView!
    @IBOutlet weak var tipOffVIew: UIView!
    @IBOutlet weak var superManView: UIView!
    
    var delegate: GuideCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGestureRecognizerToView(view: findWorkerView, target: self, actionName: "findWorkerViewAction")
        addGestureRecognizerToView(view: findJobView, target: self, actionName: "findJobViewAction")
        addGestureRecognizerToView(view: tipOffVIew, target: self, actionName: "tipOffVIewAction")
        addGestureRecognizerToView(view: superManView, target: self, actionName: "superManViewAction")
        
        // Initialization code
    }
    
    @objc func findWorkerViewAction(){
        delegate.findWorkerViewAction()
    }
    @objc func findJobViewAction(){
        delegate.findJobViewAction()
    }
    @objc func tipOffVIewAction(){
        delegate.tipOffVIewAction()
    }
    @objc func superManViewAction(){
        delegate.superManViewAction()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
