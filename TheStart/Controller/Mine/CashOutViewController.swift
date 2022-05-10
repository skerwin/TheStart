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
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var headview: UIView!
    @IBOutlet weak var mobileText: UITextField!
    @IBOutlet weak var nickNameText: UITextField!
    
    @IBOutlet weak var saveBtn: UIButton!
 
    
    @IBAction func saveAction(_ sender: Any) {
 
        
    }
 
    
    
    var userModel = UserModel()
    
     override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "绑卡提现"
        
        
        let attributedName = NSAttributedString.init(string: "请输入收款人姓名", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        nickNameText.attributedPlaceholder = attributedName
        
        let attributedPwd = NSAttributedString.init(string: "请输入收款人卡号", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        mobileText.attributedPlaceholder = attributedPwd
        
        self.tableView.separatorStyle = .none
        self.tableView.showsVerticalScrollIndicator = false
        
    }
    
    
 
 
 
    
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
       
          showOnlyTextHUD(text: description)
        //super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType){
        
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        
        let imcode = stringForKey(key: Constants.IMUserSig)
    
        
        showOnlyTextHUD(text: "保存成功")
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightNavBtnClick(){
   
 
 
//        let authenPersonalParams = HomeAPI.editProfilePathAndParams(usermodel: userModel!)
//        postRequest(pathAndParams: authenPersonalParams,showHUD: false)
        
    }
    func createRightNavItem(title:String = "保存",imageStr:String = "") {
        if imageStr == ""{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: title, style: .plain, target: self, action:  #selector(rightNavBtnClick))
        }else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: imageStr), style: .plain, target: self, action: #selector(rightNavBtnClick))
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
