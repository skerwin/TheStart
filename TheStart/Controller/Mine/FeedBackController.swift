//
//  FeedBackController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/12/31.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper
import IQKeyboardManager
import HXPHPicker

class FeedBackController: BaseViewController ,Requestable,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var uitextView: UITextView!
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var summitBtn: UIButton!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    
    var imageNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.title = "联系客服"
        view1.layer.cornerRadius = 10
        view1.layer.masksToBounds = true
        
        view2.layer.cornerRadius = 10
        view2.layer.masksToBounds = true
        
        
        view3.layer.cornerRadius = 10
        view3.layer.masksToBounds = true
        
        
        uitextView.layer.borderWidth = 1
        uitextView.layer.borderColor = UIColor.gray.cgColor
        uitextView.layer.cornerRadius = 5
        uitextView.layer.masksToBounds = true
        
        
        addGestureRecognizerToView(view: image1, target: self, actionName: "headImageAction1")
        addGestureRecognizerToView(view: image2, target: self, actionName: "headImageAction2")
        addGestureRecognizerToView(view: image3, target: self, actionName: "headImageAction3")
        addGestureRecognizerToView(view: image4, target: self, actionName: "headImageAction4")
        
        profileActionController.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
            
        }))
        profileActionController.addAction(UIAlertAction.init(title: "从相机选择", style: .default, handler: { (action) in
            self.openPhotoLibrary()
        }))
        profileActionController.addAction(UIAlertAction.init(title: "拍照", style: .default, handler: { (action) in
            self.openCamera()
        }))
        self.view.backgroundColor = ZYJColor.main
        
    }
    
    
    @IBAction func summitBtnAction(_ sender: Any) {
        
        let content = uitextView.text!
        var phone = phoneText.text!
        
        var imagestr = ""
        
        if content.isLengthEmpty() {
            showOnlyTextHUD(text: "请填写您的意见")
            return
        }
        if phone.isLengthEmpty()  {
            phone = stringForKey(key: Constants.account)!
        }
        
        if imgModel1?.id != 0{
            imagestr = imagestr + String.init(self.imgModel1!.id) + ","
        }
        if imgModel2?.id != 0{
            imagestr = imagestr + String.init(self.imgModel2!.id) + ","
        }
        if imgModel3?.id != 0{
            imagestr = imagestr + String.init(self.imgModel3!.id) + ","
        }
        if imgModel4?.id != 0{
            imagestr = imagestr + String.init(self.imgModel4!.id)
        }
        
        DialogueUtils.showSuccess(withStatus: "提交成功")
        delay(second: 1) { [self] in
             DialogueUtils.dismiss()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
       
          showOnlyTextHUD(text: description)
        //super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType){
        
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        let tipView = UIAlertController.init(title: "", message: "提交成功", preferredStyle: .alert)
        tipView.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: { (action) in

            self.navigationController?.popViewController(animated: true)
        }))
        self.present(tipView, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        phoneText.resignFirstResponder()
        uitextView.resignFirstResponder()
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }
    
    
  
    
    @objc func headImageAction1(){
        self.present(profileActionController, animated: true, completion: nil)
        imageNum = 1
       // profileActionController.message = "请选择您的照片"
        
    }
    @objc func headImageAction2(){
        self.present(profileActionController, animated: true, completion: nil)
        imageNum = 2
       // profileActionController.message = "请选择您的照片"
        
    }
    @objc func headImageAction3(){
        self.present(profileActionController, animated: true, completion: nil)
        imageNum = 3
       // profileActionController.message = "请选择您的照片"
        
    }
    @objc func headImageAction4(){
        self.present(profileActionController, animated: true, completion: nil)
        imageNum = 4
       // profileActionController.message = "请选择您的照片"
        
    }
    
    
    
    
    
    lazy var profileActionController: UIAlertController = UIAlertController.init(title: "选择照片", message: "", preferredStyle: .actionSheet)
    
    lazy var pickerController: UIImagePickerController = {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        return pickerController
    }()
    
    
    var imagePath = ""
    var imgModel1 = ImageModel()
    var imgModel2 = ImageModel()
    var imgModel3 = ImageModel()
    var imgModel4 = ImageModel()
    func uploadPhoto(filePath: [URL]) {
        DialogueUtils.showWithStatus("正在上传")
       
        HttpRequest.uploadImage(url: HomeAPI.imageUpLoadUrl, filePath: filePath,success: { (content) -> Void in
            DialogueUtils.dismiss()
            DialogueUtils.showSuccess(withStatus: "上传成功")
            if self.imageNum == 1{
                self.imgModel1 = Mapper<ImageModel>().map(JSONObject: content.rawValue)
                if self.imgModel1!.id == 0{
                    let imageId = content["id"].stringValue
                    if imageId != ""{
                        self.imgModel1?.id = Int.init(imageId)!
                    }
                }
                
             }else if self.imageNum == 2{
                self.imgModel2 = Mapper<ImageModel>().map(JSONObject: content.rawValue)
                if self.imgModel2!.id == 0{
                    let imageId = content["id"].stringValue
                    if imageId != ""{
                        self.imgModel2?.id = Int.init(imageId)!
                    }
                }
             }else if self.imageNum == 3{
                self.imgModel3 = Mapper<ImageModel>().map(JSONObject: content.rawValue)
                if self.imgModel3!.id == 0{
                    let imageId = content["id"].stringValue
                    if imageId != ""{
                        self.imgModel3?.id = Int.init(imageId)!
                    }
                }
             }else if self.imageNum == 4{
                self.imgModel4 = Mapper<ImageModel>().map(JSONObject: content.rawValue)
                if self.imgModel4!.id == 0{
                    let imageId = content["id"].stringValue
                    if imageId != ""{
                        self.imgModel4?.id = Int.init(imageId)!
                    }
                }
             }
         
         }) { (errorInfo) -> Void in
            DialogueUtils.dismiss()
            DialogueUtils.showError(withStatus: errorInfo)
            if self.imageNum == 1{
                self.image1.image = UIImage.init(named: "HeaderCamera")
            }else if self.imageNum == 2{
                self.image1.image = UIImage.init(named: "HeaderCamera")
            }else if self.imageNum == 3{
                self.image1.image = UIImage.init(named: "HeaderCamera")
            }else if self.imageNum == 4{
                self.image1.image = UIImage.init(named: "HeaderCamera")
            }
         
        }
    }
    
    // 打开照相功能
    func openCamera() {
//        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
//        if authStatus == .notDetermined || authStatus == .restricted{
//            let noticeView = UIAlertController.init(title: "提示", message: "请前往设置中开启摄像头权限", preferredStyle: .alert)
//            noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
//
//            }))
//            self.present(noticeView, animated: true, completion: nil)
//            return
//        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickerController.sourceType = .camera
            pickerController.allowsEditing = true
            present(pickerController, animated: true, completion: nil)
        } else {
            //print("模拟器没有摄像头，请使用真机调试")
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
                        if imageNum == 1{
                            image1.image = image
                        }else if imageNum == 2{
                            image2.image = image
                        }else if imageNum == 3{
                            image3.image = image
                        }else if imageNum == 4{
                            image4.image = image
                        }
                        //uploadPhoto(filePath: imagePath)
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
