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
    
    @IBOutlet weak var personBtn: UIButton!
    @IBOutlet weak var allbtn: UIButton!
    
    @IBOutlet weak var storebtn: UIButton!
    @IBOutlet weak var recordebtn: UIButton!
    
    
    @IBAction func allBtnAction(_ sender: Any) {
        delegate.allBtnAction()
    }
    
    @IBAction func personBtnAction(_ sender: Any) {
        delegate.personBtnAction()
    }
    
    @IBAction func storebtnAction(_ sender: Any) {
        delegate.storebtnAction()
    }
    
    @IBAction func recordebtnAction(_ sender: Any) {
        delegate.recordebtnAction()
    }
    
    override func awakeFromNib(){
         
 
      
    }
    
  
}
