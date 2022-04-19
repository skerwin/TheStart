//
//  CommentBarController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/07/30.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit


let kKeyboardChangeFrameTime: TimeInterval = 0.25
let kNoTextKeyboardHeight: CGFloat = 216.0

protocol CommentBarControllerDelegate : NSObjectProtocol {
    /* ============================= barView =============================== */
    func commentBarUpdateHeight(height: CGFloat)
    func commentBarVC(commentBarVC: CommentBarController, didChageChatBoxBottomDistance distance: CGFloat)
    func forLoginVC()
    func commentBarGood()
    func sendMessage(messge: String)
}

class CommentBarController: BaseViewController {
 
    // MARK:- 记录属性
       var keyboardFrame: CGRect?
       var keyboardType: ChatKeyboardType?
       
       // MARK:- 代理
    weak var delegate: CommentBarControllerDelegate?
 
    lazy var barView : ChatBarView = { [unowned self] in
          let barView = ChatBarView()
          barView.delegate = self
          return barView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        view.addSubview(barView)
        barView.snp.makeConstraints { (make) in
                  make.left.right.bottom.equalTo(self.view)
                  make.height.equalTo(50)
        }
               // 监听键盘
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
              // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
    }
    

    
    //对外调用
       func resetKeyboard() {
           barView.resetBtnsUI()
           barView.keyboardType = .noting
       }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
// MARK:- 键盘监听事件
extension CommentBarController {
    @objc fileprivate func keyboardWillHide(_ note: NSNotification) {
        keyboardFrame = CGRect.zero
        if barView.keyboardType == .emotion || barView.keyboardType == .more {
            return
        }
        delegate?.commentBarVC(commentBarVC: self, didChageChatBoxBottomDistance: 0)
    }
     @objc fileprivate func keyboardFrameWillChange(_ note: NSNotification) {
        keyboardFrame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect?
 
        if barView.keyboardType == .emotion || barView.keyboardType == .more || barView.keyboardType == .common{
            return
        }
        delegate?.commentBarVC(commentBarVC: self, didChageChatBoxBottomDistance: keyboardFrame?.height ?? 0)
    }
}
extension CommentBarController: ChatBarViewDelegate{
    func chatBargood() {
        delegate?.commentBarGood()
    }
    
    func chatBarShowTextKeyboard() {
        
        keyboardType = .text
        delegate?.forLoginVC()
        delegate?.commentBarVC(commentBarVC: self, didChageChatBoxBottomDistance: keyboardFrame?.height ?? 0)
    }
 
    
    func chatBarUpdateHeight(height: CGFloat) {
        barView.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
        delegate?.commentBarUpdateHeight(height: height)
    }
    
    func chatBarSendMessage() {
         //sendMessage()
        
        let message = barView.inputTextView.text
            
         delegate?.sendMessage(messge: message!)
         barView.inputTextView.text = ""
    }
    
}
