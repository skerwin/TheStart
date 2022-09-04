//
//  TipOffListHeadView.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/08/21.
//

import UIKit

protocol TipOffListHeadViewDelegate {
    func allBtnAction()
    func personBtnAction()
    func storebtnAction()
    func recordebtnAction()
 
}



class TipOffListHeadView: UIView {

    var delegate: TipOffListHeadViewDelegate!
    
    @IBOutlet weak var allbtn: UIButton!
    @IBOutlet weak var personBtn: UIButton!
    
    @IBOutlet weak var storebtn: UIButton!
    @IBOutlet weak var recordebtn: UIButton!
    
    
    @IBAction func allBtnAction(_ sender: Any) {
        
        allbtn.setTitleColor(colorWithHexString(hex: "4488F1"), for: .normal)
        personBtn.setTitleColor(UIColor.systemGray6, for: .normal)
        storebtn.setTitleColor(UIColor.systemGray6, for: .normal)
        recordebtn.setTitleColor(UIColor.systemGray6, for: .normal)
        
        
        delegate.allBtnAction()
    }
    
    @IBAction func personBtnAction(_ sender: Any) {
        allbtn.setTitleColor(UIColor.systemGray6, for: .normal)
        personBtn.setTitleColor(colorWithHexString(hex: "4488F1"), for: .normal)
        storebtn.setTitleColor(UIColor.systemGray6, for: .normal)
        recordebtn.setTitleColor(UIColor.systemGray6, for: .normal)
        delegate.personBtnAction()
    }
    
    @IBAction func storebtnAction(_ sender: Any) {
        allbtn.setTitleColor(UIColor.systemGray6, for: .normal)
        personBtn.setTitleColor(UIColor.systemGray6, for: .normal)
        storebtn.setTitleColor(colorWithHexString(hex: "4488F1"), for: .normal)
        recordebtn.setTitleColor(UIColor.systemGray6, for: .normal)
        delegate.storebtnAction()
    }
    
    @IBAction func recordebtnAction(_ sender: Any) {
        allbtn.setTitleColor(UIColor.systemGray6, for: .normal)
        personBtn.setTitleColor(UIColor.systemGray6, for: .normal)
        storebtn.setTitleColor(UIColor.systemGray6, for: .normal)
        recordebtn.setTitleColor(colorWithHexString(hex: "4488F1"), for: .normal)
        delegate.recordebtnAction()
    }
    
    override func awakeFromNib(){
         
        allbtn.setTitleColor(colorWithHexString(hex: "4488F1"), for: .normal)
        personBtn.setTitleColor(UIColor.systemGray6, for: .normal)
        storebtn.setTitleColor(UIColor.systemGray6, for: .normal)
        recordebtn.setTitleColor(UIColor.systemGray6, for: .normal)
    }
    
  
}
