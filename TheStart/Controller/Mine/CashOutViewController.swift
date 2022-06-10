//
//  CashOutViewController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/10.
//
 
import UIKit
//import IQKeyboardManagerSwift
import ActionSheetPicker_3_0
import SwiftyJSON
import ObjectMapper
import IQKeyboardManager
 

class CashOutViewController: BaseTableController,Requestable,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var headview: UIView!

    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var mobileText: UITextField!
    @IBOutlet weak var bankname: UITextField!

    @IBOutlet weak var nickNameText: UITextField!
    
    @IBOutlet weak var saveBtn: UIButton!
 
    
    @IBOutlet weak var numText: UITextField!
    
    var userModel = UserModel()
    
    var outNum:Float = 0
    
    var rightBarButton:UIButton!

    func createRightNavItem() {
        
        rightBarButton = UIButton.init()
        let bgview = UIView.init()
 
            
        rightBarButton.frame = CGRect.init(x: 0, y: 6, width: 63, height: 28)
        rightBarButton.setTitle("提现记录", for: .normal)
        bgview.frame = CGRect.init(x: 0, y: 0, width: 65, height: 44)
        
        rightBarButton.addTarget(self, action: #selector(rightNavBtnClic(_:)), for: .touchUpInside)
      
        rightBarButton.setTitleColor(.white, for: .normal)
        rightBarButton.backgroundColor = colorWithHexString(hex: "#228CFC")
        rightBarButton.layer.masksToBounds = true
        rightBarButton.layer.cornerRadius = 5;
        rightBarButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
     
        bgview.addSubview(rightBarButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: bgview)
        
    }

    @objc func rightNavBtnClic(_ btn: UIButton){
        let controller = CashOutStutateController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @IBAction func saveAction(_ sender: Any) {
                
         if userModel?.uid != 0 && userModel?.bank_code != ""{
            
             
            let numstr = numText.text!
            outNum = stringToFloat(test: numstr)
             
            let myconis = stringToFloat(test: userModel!.coins)
            
            if outNum > myconis{
                showOnlyTextHUD(text: "提现金额不能大于金币数量")
                return
            }
            
            cashOut()
        }else{
            
            
            userModel?.bank_realname = nickNameText.text!

            if userModel!.bank_realname.isEmptyStr() {
                showOnlyTextHUD(text: "请输入收款人姓名")
                return
            }
            userModel?.bank_code = mobileText.text!
            if userModel!.bank_code.isEmptyStr() {
                showOnlyTextHUD(text: "请输入银行卡号")
                return
            }
            if checkBankCardNumber(userModel?.bank_code){
               
            }else{
                showOnlyTextHUD(text: "请输入正确的银行卡号")
                return
            }
             
            userModel?.bank_name = bankname.text!

            if userModel!.bank_name.isEmptyStr() {
                showOnlyTextHUD(text: "请输入收款行")
                return
            }
     
            let numstr = numText.text!
            
            
            if userModel!.bank_name.isEmptyStr() {
                showOnlyTextHUD(text: "请输入提现金额")
                return
            }
            
            outNum = stringToFloat(test: numstr)
            
            let myconis = stringToFloat(test: userModel!.coins)
            
            if outNum > myconis{
                showOnlyTextHUD(text: "提现金额不能大于金币数量")
                return
            }
             let editPersonalParams = HomeAPI.bankInfoPathAndParams(model: userModel!)
            postRequest(pathAndParams: editPersonalParams,showHUD: false)
        }
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "提现"
         createRightNavItem()
         if userModel?.uid != 0 && userModel?.bank_code != ""{
             
             nickNameText.text = userModel?.bank_realname
             mobileText.text = userModel?.bank_code
             bankname.text = userModel?.bank_name
 
             nickNameText.isEnabled = false
             mobileText.isEnabled = false
             bankname.isEnabled = false
             
             let attributedNum = NSAttributedString.init(string: "请输入提现金额(整数)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
             numText.attributedPlaceholder = attributedNum
             
             tipsLabel.text = "请确认您的银行卡信息是否准确，若有误请联系客服修改"
 
         }else{
             
             let attributedName = NSAttributedString.init(string: "请输入收款人姓名", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
             nickNameText.attributedPlaceholder = attributedName
             
             let attributedPwd = NSAttributedString.init(string: "请输入收款人卡号", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
             mobileText.attributedPlaceholder = attributedPwd
              
              let attributedbankname = NSAttributedString.init(string: "请输入收款银行", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
              bankname.attributedPlaceholder = attributedbankname
              
              let attributedNum = NSAttributedString.init(string: "请输入提现金额(整数)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
              numText.attributedPlaceholder = attributedNum
         }
        
 
        
        self.tableView.separatorStyle = .none
        self.tableView.showsVerticalScrollIndicator = false
        
    }
    
 
    func cashOut(){
        
        let requestParams = HomeAPI.bankOutCashPathAndParams(extract_price: outNum)
        postRequest(pathAndParams: requestParams,showHUD: false)
        
    }
 
 
    
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
       
          showOnlyTextHUD(text: description)
        //super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType){
        
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        
        if requestPath == HomeAPI.bankInfoPath{
            cashOut()
        }else if requestPath == HomeAPI.bankOutCashPath{
            DialogueUtils.showSuccess(withStatus: "提现操作成功，请等待放款")
            delay(second: 1) { [self] in
 
                DialogueUtils.dismiss()
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
      
    }
    
  
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
     }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        nickNameText.resignFirstResponder()
        mobileText.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }
    
    
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        nickNameText.resignFirstResponder()
        mobileText.resignFirstResponder()
        
    }
    
}
