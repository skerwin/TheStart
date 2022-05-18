//
//  MusicAuthorHeader.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/10.
//

import UIKit


protocol MusicAuthorHeaderDelegate {
    func openCameradelegate()
 }

class MusicAuthorHeader: UIView {

    @IBOutlet weak var headImage: UIImageView!
    
    var delegate: MusicAuthorHeaderDelegate!
     
    
    override func awakeFromNib(){
 
        addGestureRecognizerToView(view: headImage, target: self, actionName: "openCamera")
    }
    
    @objc func openCamera(){
        
        delegate.openCameradelegate()
       
    }

}
