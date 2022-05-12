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
    
    @IBOutlet weak var addressLabel: UILabel!
    
    var cityChoosePicker:ActionSheetCustomPicker? = nil //城市选择器
    var addressList = [AddressModel]()
    var nexCityList = [AddressModel]()
    var isNextCitytment = false
    var isNextCitytment1 = false
    var province = ""
    var city = ""
    
    var userModel = UserModel()
    
    
    @IBAction func saveAction(_ sender: Any) {
        
                userModel?.nickname = nickNameText.text!
        
                if userModel!.nickname.count > 10 {
                    showOnlyTextHUD(text: "昵称不能超过10个字符")
                    return
                }
        
                if userModel!.nickname.isLengthEmpty() {
                    showOnlyTextHUD(text: "昵称不能为空")
                    return
                }
        
                if userModel!.nickname.isContainsEmoji() {
                    showOnlyTextHUD(text: "不支持输入表情")
                    return
                }
        
        let editPersonalParams = HomeAPI.userEditPathAndParams(model: userModel!)
                postRequest(pathAndParams: editPersonalParams,showHUD: false)
        
    }
    
    
    
  
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人信息"
        loadCityJson()
        
        let attributedName = NSAttributedString.init(string: "请输入昵称", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        nickNameText.attributedPlaceholder = attributedName
        
        let attributedPwd = NSAttributedString.init(string: "请输入手机号", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        mobileText.attributedPlaceholder = attributedPwd
        
        self.tableView.separatorStyle = .none
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
        
        headImage.displayHeadImageWithURL(url: userModel?.avatar_check)
        mobileText.text = userModel?.phone
        nickNameText.text = userModel?.nickname
        addressLabel.text = userModel?.addres
        
        
        headImage.layer.cornerRadius = 30;
        headImage.layer.masksToBounds = true
        
        //self.tableView.tableFooterView = UIView()
        
    }
    
    func loadCityJson(){
        do {
            if let file = Bundle.main.url(forResource: "cityjson", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if json is [String: Any] {
                } else if let object = json as? [Any] {
                    let responseJson = JSON(object)
                    addressList = getArrayFromJson(content:responseJson)
                    
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
        
        
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
        
        showOnlyTextHUD(text: "保存成功")
        self.navigationController?.popViewController(animated: true)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3{
            isNextCitytment = false
            isNextCitytment1 = false
            nexCityList  = addressList.first!.children
            self.cityChoosePicker = ActionSheetCustomPicker.init(title: "选择城市", delegate: self, showCancelButton: true, origin: self.view, initialSelections: [0,0])
            self.cityChoosePicker?.delegate = self
            cityChoosePicker?.tapDismissAction  = .success;
            cityChoosePicker?.show()
        }
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
    
    func uploadPhoto(filePath: [URL]) {
        
        DialogueUtils.showWithStatus("正在上传")
        HttpRequest.uploadImage(url: HomeAPI.imageUpLoadUrl, filePath: filePath,success: { (content) -> Void in
            DialogueUtils.dismiss()
            
            DialogueUtils.showSuccess(withStatus: "上传成功")
            
            let imgArr:[ImageModel] = getArrayFromJson(content: content)
            
            if imgArr.count > 0{
                self.userModel?.avatar =  imgArr.first!.url
            }
            
            
            
        }) { (errorInfo) -> Void in
            DialogueUtils.dismiss()
            DialogueUtils.showError(withStatus: errorInfo)
            self.headImage.image = UIImage.init(named: "headNotify")
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
                        let fileUrl = URL.init(fileURLWithPath: imagePath)
                        
                        uploadPhoto(filePath: [fileUrl])
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
extension PersonsInfoController:ActionSheetCustomPickerDelegate,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0{
            return addressList.count
        }else{
            return nexCityList.count
        }
        
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        if component == 0{
            return addressList[row].label
        }else{
            return nexCityList[row].label
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0{
            isNextCitytment = true
            province = addressList[row].label
            nexCityList = addressList[row].children
            
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.reloadComponent(1)
        }else{
            isNextCitytment1 = true
            city = nexCityList[row].label
        }
        
        
    }
    func actionSheetPickerDidSucceed(_ actionSheetPicker: AbstractActionSheetPicker!, origin: Any!) {
        
        
        if isNextCitytment {
            if isNextCitytment1{
            }else{
                city = nexCityList[0].label
            }
        }else{
            if isNextCitytment1 {
                province = addressList[0].label
            }else{
                province = addressList[0].label
                nexCityList = addressList[0].children
                city = nexCityList[0].label
            }
            
        }
        addressLabel.text = province + city
        
        
    }
    
    
    func actionSheetPickerDidCancel(_ actionSheetPicker: AbstractActionSheetPicker!, origin: Any!) {
        
        
    }
    
    //重置label
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var lable:UILabel? = view as? UILabel
        if lable == nil{
            lable = UILabel.init()
        }
        
        
        if component == 0{
            
            lable?.text = addressList[row].label
            
            
            lable?.font = UIFont.systemFont(ofSize: 17)
        }else{
            
            lable?.text = nexCityList[row].label
            
            lable?.font = UIFont.systemFont(ofSize: 16)
        }
        lable?.textAlignment = .center
        return lable!
    }
}
