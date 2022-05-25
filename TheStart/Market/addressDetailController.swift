//
//  addressDetailController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/25.
//

import UIKit
import IQKeyboardManager
import HXPHPicker
import SwiftUI
import SwiftyJSON
import ObjectMapper
import ActionSheetPicker_3_0
class addressDetailController: BaseViewController,Requestable {

    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var postCodeTF: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var detailTV: UITextView!

    
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    
    var addressmodel = AddressModel()
    var isadd = true
    
    var officesChoosePicker:ActionSheetCustomPicker? = nil //城市选择器
    var nextDepartmentsList = [AddressModel]()
    var addressList = [AddressModel]()
    
    var isNextDepartment = false
    var isNextDepartment1 = false
    
    
    var province = ""
    var city = ""
    
    
    var isDefault = 0
    
    var dateID = 0

    @IBOutlet weak var addbtn: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isadd{
            self.title = "添加地址"
            addbtn.setTitle("添加", for: .normal)
        }else{
            self.title = "编辑地址"
            addbtn.setTitle("修改", for: .normal)
            loadData()
            
        }
        loadCityJson()
        let attributedtext = NSAttributedString.init(string: "请输入", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        nameTF.attributedPlaceholder = attributedtext
        phoneTF.attributedPlaceholder = attributedtext
        postCodeTF.attributedPlaceholder = attributedtext
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 10
        detailTV.layer.masksToBounds = true
        detailTV.layer.cornerRadius = 8
        addbtn.layer.masksToBounds = true
        addbtn.layer.cornerRadius = 5
        addGestureRecognizerToView(view: cityLabel, target: self, actionName: "cityTFAction")
        
    }
    
    func loadData(){
        let requestParams = HomeAPI.addressInfoPathAndParams(id: dateID)
        postRequest(pathAndParams: requestParams,showHUD:false)
    }
    
    
    @IBAction func addBtnAction(_ sender: Any) {
 
        addressmodel!.real_name = nameTF.text!
        if addressmodel!.real_name.isEmptyStr(){
            showOnlyTextHUD(text: "请输入姓名")
            return
        }
        addressmodel!.phone = phoneTF.text!
        if !(CheckoutUtils.isMobile(mobile: addressmodel!.phone)){
            showOnlyTextHUD(text: "请输入正确的电话号码")
            return
        }
        addressmodel!.post_code = stringToInt(test: postCodeTF.text!)
        
        if addressmodel!.province.isEmptyStr(){
            showOnlyTextHUD(text: "请选择省市")
            return
        }
        addressmodel!.detail = detailTV.text!
        if addressmodel!.detail.isEmptyStr(){
            showOnlyTextHUD(text: "请填写详细地址")
            return
        }
        addressmodel!.district = "  "
        
        if isadd{
            let pathAndParams = HomeAPI.addressAddPathAndParams(model: addressmodel!)
            postRequest(pathAndParams: pathAndParams,showHUD: false)
        }else{
            let pathAndParams = HomeAPI.addressEditPathAndParams(model: addressmodel!)
            postRequest(pathAndParams: pathAndParams,showHUD: false)
        }
      
    }
    
    func loadCityJson(){
        do {
              if let file = Bundle.main.url(forResource: "cityjson", withExtension: "json") {
                  let data = try Data(contentsOf: file)
                  let json = try JSONSerialization.jsonObject(with: data, options: [])
                  if json is [String: Any] {
                      // json is a dictionary
                  } else if let object = json as? [Any] {
                      // json is an array
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
    
    
    @objc func cityTFAction(){
       print("1345")
        isNextDepartment = false
        isNextDepartment1 = false
        nextDepartmentsList = addressList.first!.children
        self.officesChoosePicker = ActionSheetCustomPicker.init(title: "选择城市", delegate: self, showCancelButton: true, origin: self.view, initialSelections: [0,0])
        self.officesChoosePicker?.delegate = self
        officesChoosePicker?.tapDismissAction  = .success;
        officesChoosePicker?.show()
        
    }
    
    @IBAction func yesAction(_ sender: Any) {
        isDefault = 1
        addressmodel?.is_default = 1
        yesBtn.setImage(UIImage.init(named: "quanYES"), for: .normal)
        noBtn.setImage(UIImage.init(named: "quanNO"), for: .normal)
    }
    
    @IBAction func noAction(_ sender: Any) {
        
        isDefault = 0
        addressmodel?.is_default = 0
        noBtn.setImage(UIImage.init(named: "quanYES"), for: .normal)
        yesBtn.setImage(UIImage.init(named: "quanNO"), for: .normal)
    }
    
   
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
             
    }

    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        if requestPath == HomeAPI.addressAddPath{
            DialogueUtils.dismiss()
            DialogueUtils.showSuccess(withStatus: "添加成功")
            delay(second: 0.1) { [self] in
                DialogueUtils.dismiss()
                self.navigationController?.popViewController(animated: true)
            }

        }else if requestPath == HomeAPI.addressInfoPath{
            addressmodel = Mapper<AddressModel>().map(JSONObject: responseResult.rawValue)
 
            nameTF.text = addressmodel?.real_name
            phoneTF.text = addressmodel?.phone
            postCodeTF.text = intToString(number: addressmodel!.post_code)
            cityLabel.text = addressmodel!.province + addressmodel!.city + addressmodel!.district
            detailTV.text = addressmodel?.detail
            
            if addressmodel?.is_default == 1{
                isDefault = 1
                yesBtn.setImage(UIImage.init(named: "quanYES"), for: .normal)
                noBtn.setImage(UIImage.init(named: "quanNO"), for: .normal)
            }else{
                addressmodel?.is_default = 0
                noBtn.setImage(UIImage.init(named: "quanYES"), for: .normal)
                yesBtn.setImage(UIImage.init(named: "quanNO"), for: .normal)
            }


        }else if requestPath == HomeAPI.addressEditPath{
            DialogueUtils.dismiss()
            DialogueUtils.showSuccess(withStatus: "编辑成功")
            delay(second: 0.1) { [self] in
                DialogueUtils.dismiss()
                self.navigationController?.popViewController(animated: true)
            }
        }
 
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
}
extension addressDetailController:ActionSheetCustomPickerDelegate,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            
            if component == 0{
                return addressList.count
            }else{
                return nextDepartmentsList.count
            }

    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
            if component == 0{
                return addressList[row].label
            }else{
                return nextDepartmentsList[row].label
            }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
 
            if component == 0{
                isNextDepartment = true
                province = addressList[row].label
                nextDepartmentsList = addressList[row].children
                
                pickerView.selectRow(0, inComponent: 1, animated: true)
                pickerView.reloadComponent(1)
            }else{
                isNextDepartment1 = true
                city = nextDepartmentsList[row].label
                
               
            }
       
    }
    func actionSheetPickerDidSucceed(_ actionSheetPicker: AbstractActionSheetPicker!, origin: Any!) {
 
            if isNextDepartment {
                if isNextDepartment1{
                }else{
                    city = nextDepartmentsList[0].label
                 }

            }else{
                if isNextDepartment1 {
                     province = addressList[0].label
                    
                }else{
                    province = addressList[0].label
                    
                    nextDepartmentsList = addressList[0].children
                    city = nextDepartmentsList[0].label
                    
                }

         }
        addressmodel?.province = province + "省"
        addressmodel?.city = city + "市"
        cityLabel.text = province + city
     
    }
    
    
    func actionSheetPickerDidCancel(_ actionSheetPicker: AbstractActionSheetPicker!, origin: Any!) {
        cityLabel.text = province + city
        addressmodel?.province = province + "省"
        addressmodel?.city = city + "市"
        
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
                lable?.text = nextDepartmentsList[row].label
                lable?.font = UIFont.systemFont(ofSize: 16)
            }
        lable?.textAlignment = .center
        return lable!
    }
}
