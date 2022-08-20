//
//  GetBackPasswordController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/08/06.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import IQKeyboardManager
import SwiftyJSON
import ObjectMapper

class GetBackPasswordController: BaseViewController,Requestable,UITextFieldDelegate {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var accountBgview: UIView!
    @IBOutlet weak var vertifyCodeBgview: UIView!
    @IBOutlet weak var psaawordBgview: UIView!
    @IBOutlet weak var morepsaawordBgview: UIView!
    @IBOutlet weak var nickNameBgView: UIView!
    
    @IBOutlet weak var accountText: UITextField!
    @IBOutlet weak var vertifyCodeText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var morepasswordText: UITextField!
    @IBOutlet weak var nickNameText: UITextField!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var vertifycodeBtn: UIButton!
    
    @IBOutlet weak var sureBtn: UIButton!
    
    var reloadLogin:((_ account:String) -> Void)?
    
    var codeType = "login"
    
    var account = ""
    var password = ""
    var code = ""
    var repassword = ""
    var nickName = ""
    
    
    @IBAction func vertifycodeBtnAction(_ sender: Any) {
        
        account = accountText.text!
        
        if account.isLengthEmpty(){
            DialogueUtils.showError(withStatus: "账号不能为空")
            return
        }
        if !(CheckoutUtils.isMobile(mobile: account)){
            DialogueUtils.showWarning(withStatus: "请输入正确的手机号")
            return
        }
        
        if (stringForKey(key: Constants.verCodeKey) != nil && stringForKey(key: Constants.verCodeKey) != ""){
            let key = stringForKey(key: Constants.verCodeKey)!
            let pathAndParams = HomeAPI.getVerifyCodePathAndParams(phone: account, type: codeType, key:key )
            postRequest(pathAndParams: pathAndParams,showHUD: true)
            
            vertifycodeBtn.isEnabled = false
            vertifycodeBtn.setTitleColor(ZYJColor.blueTextColor, for: .normal)
            vertifycodeBtn.backgroundColor = ZYJColor.Line.grey
        }else{
            DialogueUtils.showWarning(withStatus: "无法获验证码，请重新打开应用")
            return
        }
        
        

       
    }
    
  
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        
        if requestPath == HomeAPI.getVerifyCodePath{
            vertifycodeBtn.setTitle("验证码已发送", for:.normal)
            vertifycodeBtn.isEnabled = false
            vertifycodeBtn.setTitleColor(UIColor.black, for: .normal)
            vertifycodeBtn.backgroundColor = ZYJColor.Line.grey
            DialogueUtils.showSuccess(withStatus: "发送成功")
            code = responseResult["code"].stringValue
        }
        else if requestPath == HomeAPI.registerAccoountPath{
            
            setStringValueForKey(value: account, key: Constants.account)
            let tipView = UIAlertController.init(title: "", message: "注册成功，马上登陆", preferredStyle: .alert)
            tipView.addAction(UIAlertAction.init(title: "确定", style: .cancel, handler: { [self] (action) in
                if reloadLogin != nil{
                    self.reloadLogin!(account)
                }
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(tipView, animated: true, completion: nil)
        }
        else if requestPath == HomeAPI.resetPwdPath{
            
            setStringValueForKey(value: account, key: Constants.account)
            let tipView = UIAlertController.init(title: "", message: "重置成功，马上登陆", preferredStyle: .alert)
            tipView.addAction(UIAlertAction.init(title: "确定", style: .cancel, handler: { [self] (action) in
                if reloadLogin != nil{
                    self.reloadLogin!(account)
                }
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(tipView, animated: true, completion: nil)
        }
        else {
 
        }
        
        
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
        
    }
    
    @IBAction func sureBtnAction(_ sender: Any) {
        
        account = accountText.text!
        password = passwordText.text!
        repassword = morepasswordText.text!
        
        nickName = nickNameText.text!
        
        if account.isLengthEmpty(){
            DialogueUtils.showError(withStatus: "账号不能为空")
            return
        }
        if !(CheckoutUtils.isMobile(mobile: account)){
            DialogueUtils.showWarning(withStatus: "请输入正确的手机号")
            return
        }
        
    
        if password != repassword{
            DialogueUtils.showError(withStatus: "两次输入密码不相同")
            return
        }

        if code != vertifyCodeText.text! {
            DialogueUtils.showError(withStatus: "验证码错误")
            return
        }else{
            code = vertifyCodeText.text!
        }
        
        if code.isLengthEmpty() {
            DialogueUtils.showError(withStatus: "验证码不能为空")
            return
        }
        if nickName.isLengthEmpty() {
            nickName = ""
        }
        
        
        if password.isLengthEmpty() || repassword.isLengthEmpty(){
            DialogueUtils.showError(withStatus: "密码不能为空")
            return
        }
        
        if !(CheckoutUtils.isPasswordNOSpecial(pwd:password)){
            showOnlyTextHUD(text: "密码应在6—16个字符之间 且不能包含特殊字符")
            return
        }
        
        if codeType == "register"{
            let pathAndParams = HomeAPI.registerAccoountPathAndParams(phone: account, captcha: code, password: password, confirm_pwd: repassword, nickname: nickName)
            postRequest(pathAndParams: pathAndParams,showHUD: false)
        }else{
            let pathAndParams = HomeAPI.resetPwdPathAndParams(phone: account, captcha: code, password: password)
            postRequest(pathAndParams: pathAndParams,showHUD: false)
        }
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let attributedName = NSAttributedString.init(string: "输入手机号", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        accountText.attributedPlaceholder = attributedName
        
        let attributedcode = NSAttributedString.init(string: "输入验证码", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        vertifyCodeText.attributedPlaceholder = attributedcode
        
        let attributedPwd = NSAttributedString.init(string: "设置密码", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        passwordText.attributedPlaceholder = attributedPwd
        
        let attributedmorePwd = NSAttributedString.init(string: "确认密码", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        morepasswordText.attributedPlaceholder = attributedmorePwd
        
        let attributednickname = NSAttributedString.init(string: "昵称(非必填)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        nickNameText.attributedPlaceholder = attributednickname
 
        
        if codeType == "login"{
            nickNameBgView.isHidden = true
            titleLabel.text = "重置密码"
        }else{
            nickNameBgView.isHidden = false
            titleLabel.text = "注册"
        }
        
        sureBtn.setTitleColor(UIColor.white, for: .normal)
        sureBtn.layer.cornerRadius = 10;
        sureBtn.layer.masksToBounds = true;
        
        vertifycodeBtn.backgroundColor = ZYJColor.backBlue
        vertifycodeBtn.setTitle("获取验证码", for:.normal)
        vertifycodeBtn.setTitleColor(UIColor.white, for: .normal)
        vertifycodeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        vertifycodeBtn.layer.cornerRadius = 10
        vertifycodeBtn.layer.masksToBounds = true
        
       
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        
    }
    
   
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }
    
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        accountText.resignFirstResponder()
        vertifyCodeText.resignFirstResponder()
        passwordText.resignFirstResponder()
        morepasswordText.resignFirstResponder()
        
    }
 
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == accountText {
            if textField.text != account {
                vertifycodeBtn.backgroundColor = ZYJColor.main
                vertifycodeBtn.setTitle("获取验证码", for:.normal)
                vertifycodeBtn.isEnabled = true
                vertifyCodeText.placeholder = "请输入验证码"
            }
        }
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
