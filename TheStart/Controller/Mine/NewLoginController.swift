//
//  NewLoginController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/10/19.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import IQKeyboardManager
import SwiftyJSON
import ObjectMapper

class NewLoginController: BaseViewController,Requestable {
    
    @IBOutlet weak var forgetBtn: UIButton!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var accountTextF: UITextField!
    
    @IBOutlet weak var passwordTextF: UITextField!
    
    @IBOutlet weak var verCodeBtn: UIButton!
    
    @IBOutlet weak var changeloginStyleBtn: UIButton!
    
    @IBOutlet weak var logoImg: UIImageView!
    
    var userAgreementHtml = ""
    var privasyHtml = ""
    
    var isAgreement = false
 
    @IBAction func agreementAction(_ sender: Any) {
         isAgreement = !isAgreement
         if isAgreement {
            agremmnetBtn.setImage(UIImage.init(named: "choose"), for: .normal)
         }else{
            agremmnetBtn.setImage(UIImage.init(named: "Not to choose"), for: .normal)
        
        }
     }
 
    @IBOutlet weak var agremmnetBtn: UIButton!
    //之后要删除的方法
    @IBOutlet weak var backBtn: UIButton!
    
    var isCodeLogin = false
    
    var imgUrl = "http://122.114.14.227/uploads/store/comment/20220215/18d9141f060849f8eba076ca29a68278.png"
 
    @IBAction func changeloginStyleBtnAction(_ sender: Any) {
        
        if isCodeLogin == true{
            isCodeLogin = false
            verCodeBtn.isHidden = true
            accountTextF.text = ""
            passwordTextF.text = ""
            changeloginStyleBtn.setTitle("使用验证码登录", for: .normal)
            changeloginStyleBtn.titleLabel?.text = "使用验证码登录"
            passwordTextF.placeholder = "请输入密码"
            passwordTextF.isSecureTextEntry = true
 
        }else{
            accountTextF.text = ""
            passwordTextF.text = ""
            isCodeLogin = true
            verCodeBtn.isHidden = false
            verCodeBtn.titleLabel?.text = "获取验证码"
            verCodeBtn.setTitle("获取验证码", for: .normal)
            verCodeBtn.setTitleColor(ZYJColor.backBlue, for: .normal)
            
            passwordTextF.isSecureTextEntry = false
            changeloginStyleBtn.setTitle("账号密码登录", for: .normal)
            changeloginStyleBtn.titleLabel?.text = "账号密码登录"

            passwordTextF.placeholder = "请输入验证码"
        }
    }
 
    var reloadLogin:(() -> Void)?
    
    var dismMissBlock:(() -> Void)?
    
    var verCode = ""
    var account = ""
    var password = ""
    
    var usermodel = UserModel()
    @IBAction func registerAccount(_ sender: Any) {
 
        let controller = UIStoryboard.getGetBackPasswordController()
        controller.codeType = "register"
        controller.reloadLogin = {[weak self] (account) -> Void in
            self!.accountTextF.text = account
        }
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
        
    }
    
    func getVerifyKey(){
        let requestParams = HomeAPI.verifyCodeKeyPathAndParams()
        getRequest(pathAndParams: requestParams,showHUD: false)
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
         //logoImg.displayImageWithURL(url: imgUrl)
         let attributedName = NSAttributedString.init(string: "请输入账号", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
         accountTextF.attributedPlaceholder = attributedName
         
        let attributedPwd = NSAttributedString.init(string: "请输入密码", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        passwordTextF.attributedPlaceholder = attributedPwd
         
        getVerifyKey()
        self.accountTextF.text = getAcctount()
        loadPrivateAndAbouutUs()
        loginBtn.layer.cornerRadius = 20
        loginBtn.layer.masksToBounds = true
         isCodeLogin = false
         
        verCodeBtn.isHidden = true
        changeloginStyleBtn.setTitle("使用验证码登录", for: .normal)
        passwordTextF.isSecureTextEntry = true
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.titleLabel?.text = "登录"
         
        isAgreement = false
        agremmnetBtn.setImage(UIImage.init(named: "Not to choose"), for: .normal)
 
     
    }
    @IBAction func verCodeBtnAction(_ sender: Any) {
        getVertifycodeBtnAction()
    }
 
    
    func loadPrivateAndAbouutUs() {
        
        let requestParamsP0 = HomeAPI.privacyUserAgreementPathAndParam(id:2)
        getRequest(pathAndParams: requestParamsP0,showHUD: false)

        let requestParamsP1 = HomeAPI.privacyUserAgreementPathAndParam(id:3)
        getRequest(pathAndParams: requestParamsP1,showHUD: false)
        
        let requestParamsP2 = HomeAPI.privacyUserAgreementPathAndParam(id:4)
        getRequest(pathAndParams: requestParamsP2,showHUD: false)
       
    }
    
    
    
    @IBAction func backAction(_ sender: Any) {
        
    }
    
    @IBAction func forgetPwdAction(_ sender: Any) {
        let controller = UIStoryboard.getGetBackPasswordController()
        controller.codeType = "login"
        controller.reloadLogin = {[weak self] (account) -> Void in
            self!.accountTextF.text = account
        }
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    @IBAction func privateAgreement(_ sender: Any) {
        let conroller = PrivateStatusViewController()
        conroller.htmlString = privasyHtml
        self.present(conroller, animated: true, completion: nil)
    }
     
    @IBAction func userAgreementAction(_ sender: Any) {
        let conroller = PrivateStatusViewController()
        conroller.htmlString = userAgreementHtml
        //conroller.userAgreemrnt = true
        self.present(conroller, animated: true, completion: nil)
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
 
        if !isAgreement{
             showOnlyTextHUD(text: "请先勾选页面下方的\"同意《用户协议及隐私条款》\"")
            return
        }
        
        account = accountTextF.text!
        
        if account.isLengthEmpty(){
            DialogueUtils.showError(withStatus: "账号不能为空")
            return
        }
        
        if !(CheckoutUtils.isMobile(mobile: account)){
            DialogueUtils.showWarning(withStatus: "请输入正确的手机号")
            return
        }
        if isCodeLogin {
            
            if verCode != passwordTextF.text!{
                DialogueUtils.showError(withStatus: "验证码不正确")
                return
            }else{
                verCode = passwordTextF.text!
            }
            
            if verCode.isLengthEmpty() {
                DialogueUtils.showError(withStatus: "验证码不能为空")
                return
            }
            
            let pathAndParams = HomeAPI.verifyCodeLoginPathAndParams(phone: account, captcha: verCode)
            postRequest(pathAndParams: pathAndParams,showHUD: false)
 
        }else{
            password = passwordTextF.text!
            if password.isLengthEmpty(){
                DialogueUtils.showError(withStatus: "密码不能为空")
                return
            }
            
            if !(CheckoutUtils.isPasswordNOSpecial(pwd:password)){
                showOnlyTextHUD(text: "密码应在6—16个字符之间 且不能包含特殊字符")
                return
            }
            
            let pathAndParams = HomeAPI.acountCodeLoginPathAndParams(account: account, password: password)
            postRequest(pathAndParams: pathAndParams,showHUD: false)
 
        }
    }
    
    
    func getVertifycodeBtnAction(){
        account = accountTextF.text!
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
            let pathAndParams = HomeAPI.getVerifyCodePathAndParams(phone: account, type: "login", key:key )
            postRequest(pathAndParams: pathAndParams,showHUD: false)
            DialogueUtils.showWithStatus("正在获取验证码")
            verCodeBtn.isEnabled = false
            verCodeBtn.setTitleColor(UIColor.gray, for: .normal)
        }else{
            DialogueUtils.showWarning(withStatus: "无法获验证码，请重新打开应用")
            return
        }
    }
    
    func loadUserInfoData(){
        let requestParams = HomeAPI.userinfoPathAndParam()
        getRequest(pathAndParams: requestParams,showHUD:false)
     }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        //ischeck 是否审核  0 未审核  1  审核中  2 通过审核 3 审核为通过
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        
        if requestPath.containsStr(find: HomeAPI.verifyCodeKeyPath){
            let verCodeKey = responseResult["key"].stringValue
            setStringValueForKey(value: verCodeKey, key: Constants.verCodeKey)
        }else if requestPath == HomeAPI.acountCodeLoginPath || requestPath == HomeAPI.verifyCodeLoginPath{
            
            
            let token = responseResult["token"].stringValue
            setStringValueForKey(value: token, key: Constants.token)
            setStringValueForKey(value: account, key: Constants.account)
            
            loadUserInfoData()
           
        } else if requestPath == HomeAPI.getVerifyCodePath{
            DialogueUtils.dismiss()
            verCodeBtn.titleLabel?.text = "验证码已发送"
            verCodeBtn.setTitle("验证码已发送", for: .normal)
            verCodeBtn.setTitleColor(UIColor.gray, for: .normal)
            verCodeBtn.isEnabled = false
            passwordTextF.placeholder = "请在5分钟内输入"
            verCode = responseResult["code"].stringValue
        }else if requestPath.containsStr(find: "/api/danye/4"){
            privasyHtml = responseResult["content"].stringValue
        }
        else if requestPath.containsStr(find: "/api/danye/3"){
            userAgreementHtml = responseResult["content"].stringValue
        }else if requestPath.containsStr(find: HomeAPI.userinfoPath) {
            DialogueUtils.showSuccess(withStatus: "登陆成功")
            let usermodel = Mapper<UserModel>().map(JSONObject: responseResult.rawValue)
            setIntValueForKey(value: usermodel?.uid, key: Constants.userid)
            print("12345678")
            delay(second: 0.5) { [self] in
            UIApplication.shared.keyWindow?.rootViewController = MainTabBarController()
            }
        }
 
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
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
    
    
    
    //    func sendCode() {
    //        getVertifycodeBtnAction()
    //    }
    
    
}
 
