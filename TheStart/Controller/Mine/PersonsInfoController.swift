//
//  PersonsInfoController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/08/03.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
//import IQKeyboardManagerSwift
import ActionSheetPicker_3_0
import SwiftyJSON
import ObjectMapper
import IQKeyboardManager
 

class PersonsInfoController: BaseTableController,Requestable,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var headview: UIView!
    @IBOutlet weak var mobileText: UITextField!
    @IBOutlet weak var nickNameText: UITextField!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var menBtn: UIButton!
    @IBOutlet weak var wommen: UIButton!
    
    @IBAction func saveAction(_ sender: Any) {
        
        userModel?.user_nickname = nickNameText.text!

        if userModel!.user_nickname.count > 10 {
            showOnlyTextHUD(text: "昵称不能超过10个字符")
            return
        }

        if userModel!.user_nickname.isLengthEmpty() {
            showOnlyTextHUD(text: "昵称不能为空")
            return
        }

        if userModel!.user_nickname.isContainsEmoji() {
            showOnlyTextHUD(text: "不支持输入表情")
            return
        }
 
//        let authenPersonalParams = HomeAPI.editProfilePathAndParams(usermodel: userModel!)
//        postRequest(pathAndParams: authenPersonalParams,showHUD: false)
        
    }
    @IBAction func menActioin(_ sender: Any) {
        userModel?.sex = 1
        menBtn.setImage(UIImage.init(named: "quanYES"), for: .normal)
        wommen.setImage(UIImage.init(named: "quanNO"), for: .normal)
    }
    
    @IBAction func wonmen(_ sender: Any) {
        
        userModel?.sex = 2
        wommen.setImage(UIImage.init(named: "quanYES"), for: .normal)
        menBtn.setImage(UIImage.init(named: "quanNO"), for: .normal)
    }
    
    
    var userModel = UserModel()
    
    var imageToken = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人信息"
        self.tableView.showsVerticalScrollIndicator = false
        //createRightNavItem()
        addGestureRecognizerToView(view: headImage, target: self, actionName: "headImageAction")
        
        profileActionController.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
            
        }))
        profileActionController.addAction(UIAlertAction.init(title: "从相机选择", style: .default, handler: { (action) in
            self.openPhotoLibrary()
        }))
        profileActionController.addAction(UIAlertAction.init(title: "拍照", style: .default, handler: { (action) in
            self.openCamera()
        }))
        
        mobileText.text = userModel?.user_login
        mobileText.isEnabled = false

       
        if !(userModel?.user_nickname.isLengthEmpty())!{
            nickNameText.text = userModel?.user_nickname
        }
        
        
        if userModel?.sex == 0 {
            wommen.setImage(UIImage.init(named: "quanNO"), for: .normal)
            menBtn.setImage(UIImage.init(named: "quanNO"), for: .normal)
        }else if userModel?.sex == 2 {
            wommen.setImage(UIImage.init(named: "quanYES"), for: .normal)
            menBtn.setImage(UIImage.init(named: "quanNO"), for: .normal)
        }else{
            menBtn.setImage(UIImage.init(named: "quanYES"), for: .normal)
            wommen.setImage(UIImage.init(named: "quanNO"), for: .normal)
        }
        
        headImage.displayHeadImageWithURL(url: userModel?.avatar_url)
        
        headImage.layer.cornerRadius = 30;
        headImage.layer.masksToBounds = true
        
        //self.tableView.tableFooterView = UIView()
      
    }
    
    
    
    @IBAction func menBtnAction(_ sender: Any) {
        userModel?.sex = 1
        menBtn.setImage(UIImage.init(named: "quanYES"), for: .normal)
        wommen.setImage(UIImage.init(named: "quanNO"), for: .normal)
        
    }
    
    @IBAction func wommenBtnAction(_ sender: Any) {
        userModel?.sex = 2
        wommen.setImage(UIImage.init(named: "quanYES"), for: .normal)
        menBtn.setImage(UIImage.init(named: "quanNO"), for: .normal)
        
    }
 
    lazy var profileActionController: UIAlertController = UIAlertController.init(title: "选择照片", message: "", preferredStyle: .actionSheet)
    
    lazy var pickerController: UIImagePickerController = {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        return pickerController
    }()
    
    
    @objc func headImageAction(){
        self.present(profileActionController, animated: true, completion: nil)
       // profileActionController.message = "请选择您的照片"
        
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
   
        userModel?.user_nickname = nickNameText.text!

        if userModel!.user_nickname.count > 10 {
            showOnlyTextHUD(text: "昵称不能超过10个字符")
            return
        }

        if userModel!.user_nickname.isLengthEmpty() {
            showOnlyTextHUD(text: "昵称不能为空")
            return
        }

        if userModel!.user_nickname.isContainsEmoji() {
            showOnlyTextHUD(text: "不支持输入表情")
            return
        }
 
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
        return 4
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0.1
        }else{
            return 10
        }
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
    var imagePath = ""
    var headimgModel = ImageModel()
    func uploadPhoto(filePath: String) {
        DialogueUtils.showWithStatus("正在上传")
        
       // /common/api/up_img
       // /users/api/editAvatar
        HttpRequest.uploadImage(url: HomeAPI.imageUpLoadUrl, filePath: filePath,success: { (content) -> Void in
            DialogueUtils.dismiss()
            DialogueUtils.showSuccess(withStatus: "上传成功")
            
            
            self.headimgModel = Mapper<ImageModel>().map(JSONObject: content.rawValue)
            
            if self.headimgModel!.id == 0{
                let imageId = content["id"].stringValue
                if imageId != ""{
                    self.userModel?.avatar =  imageId
                }
            }else{
                self.userModel?.avatar =  String.init(self.headimgModel!.id)
            }
 
            
        }) { (errorInfo) -> Void in
            DialogueUtils.dismiss()
            DialogueUtils.showError(withStatus: errorInfo)
            self.headImage.image = UIImage.init(named: "HeaderCamera")
            self.headimgModel = ImageModel()
            self.userModel?.avatar = ""
        }
    }
    
    // 打开照相功能
    func openCamera() {
    
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickerController.sourceType = .camera
            pickerController.allowsEditing = true
            present(pickerController, animated: true, completion: nil)
        } else {
            print("模拟器没有摄像头，请使用真机调试")
        }
    }
    
    func openPhotoLibrary() {
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker:UIImagePickerController,didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey:Any]){
        let publicImageType = "public.image"
        if let typeInfo = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.mediaType.rawValue)] as? String {
            if typeInfo == publicImageType {
                if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.editedImage.rawValue)] as? UIImage {
                    var data: NSData?
                    if image.pngData() == nil {
                        data = image.jpegData(compressionQuality: 0.8) as NSData?
                    } else {
                        data = image.pngData() as NSData?
                    }
                    if data != nil {//上传头像到服务器
                        let home = NSHomeDirectory() as NSString
                        let docPath = home.appendingPathComponent("Documents") as NSString;
                        let imageName = DateUtils.getStampString() + ".png"
                        imagePath = docPath.appendingPathComponent(imageName);
                        data?.write(toFile: imagePath, atomically: true)
                        headImage.image = image
                        uploadPhoto(filePath: imagePath)
                    }
                }
            }
        }
        pickerController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker .dismiss(animated: true, completion: nil)
    }
    
}
