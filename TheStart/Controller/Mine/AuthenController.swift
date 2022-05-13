//
//  AuthenController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/08/04.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SwiftyJSON
import ObjectMapper
import IQKeyboardManager
 


class AuthenController: BaseTableController,Requestable,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var mobileText: UITextField!
    @IBOutlet weak var shenfenIDText: UITextField!
    //@IBOutlet weak var ageText: UITextField!
    
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var workTypeLabel: UILabel!
    @IBOutlet weak var addresslabel: UILabel!
    @IBOutlet weak var companyName: UITextField!
    
    @IBOutlet weak var summbitBtn: UIButton!
    
    
    var genderPicker:ActionSheetStringPicker? = nil //性别选择器
    let genderList = ["男","女"]
    
    var cityChoosePicker:ActionSheetCustomPicker? = nil //城市选择器
    var addressList = [AddressModel]()
    var nexCityList = [AddressModel]()
    var isNextCitytment = false
    var isNextCitytment1 = false
    var province = ""
    var city = ""
    
    
    var isWorkType = false
    var workTypeChoosePicker:ActionSheetCustomPicker? = nil //工种选择器
    var workTypeList = [DictModel]()
    var nextworkTypeList = [DictModel]()
    var isNextWorkType = false
    var isNextWorkType1 = false
    var workType = ""
    var workTypeSub = ""
    
   
    var usermodel = UserModel()
    
    let datePicker = DatePickerDialog()

 
    func initView(){
        
        summbitBtn.layer.cornerRadius = 10
        summbitBtn.layer.masksToBounds = true
        
        
        let attributedName = NSAttributedString.init(string: "请输入真实姓名", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        nameText.attributedPlaceholder = attributedName
        
       let attributedPwd = NSAttributedString.init(string: "请输入手机号", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        mobileText.attributedPlaceholder = attributedPwd
        
        let attributedcard = NSAttributedString.init(string: "请输入身份证号", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        shenfenIDText.attributedPlaceholder = attributedcard
        
        
        let attributedcoompanyy = NSAttributedString.init(string: "请输入您的公司", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
         companyName.attributedPlaceholder = attributedcoompanyy
        
     }
    
 
    
    @IBAction func summbitAction(_ sender: Any) {
        
        
        usermodel?.real_name = nameText.text!

        if usermodel!.real_name.isLengthEmpty() {
            showOnlyTextHUD(text: "请完善您的姓名")
            return
        }

        
        if usermodel!.gender == "" {
            showOnlyTextHUD(text: "请选择您的性别")
            return
        }

        usermodel!.phone = mobileText.text ?? ""
        
        if usermodel!.phone.isLengthEmpty(){
            showOnlyTextHUD(text: "请输入您的手机号")
            return
        }


        usermodel!.address = province + city

        if usermodel!.address == "" {
            showOnlyTextHUD(text: "请选择您的地址")
            return
        }

        if usermodel!.shiming_work == 0 {
            showOnlyTextHUD(text: "请选择您的职业")
            return
        }
        
        usermodel?.card_id = shenfenIDText.text ?? ""
        usermodel?.shiming_company = companyName.text ?? ""
        

       

     let authenPersonalParams = HomeAPI.shimingSumbitPathAndParams(model: usermodel!)
      postRequest(pathAndParams: authenPersonalParams,showHUD: false)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "实名认证"
        prepareData()
        initView()
    
        tableView.separatorColor = UIColor.darkGray
        
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
    
    
    func prepareData(){
 
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
        
        let workcateResult = XHNetworkCache.check(withURL: HomeAPI.workCategoryPath)
        if workcateResult {
            let dict = XHNetworkCache.cacheJson(withURL: HomeAPI.workCategoryPath)
            let responseJson = JSON(dict)
            workTypeList = getArrayFromJson(content: responseJson["data"]["cate"])
        }
        
      
    }
    
    
    
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType){
//        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
//
//        if requestPath == HomeAPI.professionalPath {
//            professionalModelList = getArrayFromJsonByArrayName(arrayName: "pro_list", content:  responseResult)
//            departmentsModelList = getArrayFromJsonByArrayName(arrayName: "depart_list", content:  responseResult)
//            nextDepartmentsList = departmentsModelList.first!.child
//        }
//
//        else if requestPath == HomeAPI.addressPath {
//            addressList = getArrayFromJson(content:responseResult)
//            cityList = addressList.first!.children
//            districtList = addressList.first!.children.first!.children
//        }
//
//        else if requestPath == HomeAPI.authDoctorPath {
//            //保存一下真实姓名
//            setValueForKey(value:  userModel?.sex as AnyObject, key: Constants.gender)
//            setValueForKey(value:  userModel?.user_realname as AnyObject, key: Constants.truename)
//            let vc = UIStoryboard.getAuthenSubmitedController()
//            vc.isFormMine = self.isFormMine
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    // MARK: - Table view data source
 
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        return 4
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = Bundle.main.loadNibNamed("MusicAuthorVideoHeader", owner: nil, options: nil)!.first as! MusicAuthorVideoHeader
        sectionView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 40)
        
        if section == 0{
            sectionView.titleLabel.text = "基本信息"
        }
        else{
            sectionView.titleLabel.text = "详细信息"
        }
        return sectionView
    }
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
  
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 44
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
          if section == 0{
            if row == 0{
            
                
            }else if  row == 1{
                self.genderPicker = ActionSheetStringPicker(title: "性别选择", rows: genderList, initialSelection: 0, doneBlock: { [self] (picker, index, value) in
                    self.genderLabel.text = self.genderList[index]
                    self.usermodel?.gender = self.genderList[index]
                }, cancel: { (picker) in
                    
                }, origin: self.view)
                self.genderPicker!.tapDismissAction = .success
                self.genderPicker!.show()
            }
        }else{
            if row == 1{
                isWorkType = true
                isNextWorkType = false
                isNextWorkType1 = false
                nextworkTypeList = workTypeList.first!.child
                self.workTypeChoosePicker = ActionSheetCustomPicker.init(title: "选择职业", delegate: self, showCancelButton: true, origin: self.view, initialSelections: [0,0])
                self.workTypeChoosePicker?.delegate = self
                workTypeChoosePicker?.tapDismissAction  = .success;
                workTypeChoosePicker?.show()
            }else if row == 2{
                isWorkType = false
                isNextCitytment = false
                isNextCitytment1 = false
                nexCityList  = addressList.first!.children
                self.cityChoosePicker = ActionSheetCustomPicker.init(title: "选择城市", delegate: self, showCancelButton: true, origin: self.view, initialSelections: [0,0])
                self.cityChoosePicker?.delegate = self
                cityChoosePicker?.tapDismissAction  = .success;
                cityChoosePicker?.show()
            }else if row == 0{
                
                let currentDate = Date()
                var minCom = DateComponents()
                minCom.month = -1200
                let minDate = Calendar.current.date(byAdding: minCom, to: currentDate)
                
                var maxCom = DateComponents()
                maxCom.month = 0
                let maxDate = Calendar.current.date(byAdding: maxCom, to: currentDate)
                
                datePicker.show("请选择日期",
                                doneButtonTitle: "确定",
                                cancelButtonTitle: "取消",
                                minimumDate: minDate,
                                maximumDate: maxDate,
                                datePickerMode: .date) { [self] (date) in
                    if let dt = date {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        usermodel?.birthday = formatter.string(from: dt)
                        ageLabel.text =  formatter.string(from: dt)
                    }
                }
            }
        }
 
    }
 
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        nameText.resignFirstResponder()
        mobileText.resignFirstResponder()
     }
  
    
    
}

extension AuthenController:ActionSheetCustomPickerDelegate,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if isWorkType == true{
            if component == 0{
                return workTypeList.count
            }else{
                return nextworkTypeList.count
            }
        }else{
            if component == 0{
                return addressList.count
            }else{
                return nexCityList.count
            }
        }
        
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if isWorkType == true{
            if component == 0{
                return workTypeList[row].title
            }else{
                return nextworkTypeList[row].title
            }
        }else{
            if component == 0{
                return addressList[row].label
            }else{
                return nexCityList[row].label
            }
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if isWorkType == true{
            if component == 0{
                isNextWorkType = true
                workType = workTypeList[row].title
                nextworkTypeList = workTypeList[row].child
                
                pickerView.selectRow(0, inComponent: 1, animated: true)
                pickerView.reloadComponent(1)
            }else{
                isNextWorkType1 = true
                workTypeSub = nextworkTypeList[row].title
                usermodel?.shiming_work = nextworkTypeList[row].id
            }
        }else{
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
        
        
    }
    func actionSheetPickerDidSucceed(_ actionSheetPicker: AbstractActionSheetPicker!, origin: Any!) {
        
        if isWorkType == true{
            if isNextWorkType {
                if isNextWorkType1{
                }else{
                    workTypeSub = nextworkTypeList[0].title
                    usermodel?.shiming_work = nextworkTypeList[0].id
                }
            }else{
                if isNextWorkType1 {
                    workType = workTypeList[0].title
                }else{
                    workType = workTypeList[0].title
                    nextworkTypeList = workTypeList[0].child
                    workTypeSub = nextworkTypeList[0].title
                    usermodel?.shiming_work = nextworkTypeList[0].id
                }
            }
            
            workTypeLabel.text = workTypeSub
        }else{
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
            addresslabel.text = province + city
        }
   
        
    }
    
    
    func actionSheetPickerDidCancel(_ actionSheetPicker: AbstractActionSheetPicker!, origin: Any!) {
        print("123")
//        if isWorkType == true{
//            headView.jobTypeText.text = workTypeSub
//        }else{
//            headView.addressTypeText.text = province + city
//        }
       
        
    }
    
    //重置label
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var lable:UILabel? = view as? UILabel
        if lable == nil{
            lable = UILabel.init()
        }
        
        
        if component == 0{
            if isWorkType == true{
                lable?.text = workTypeList[row].title
            }else{
                lable?.text = addressList[row].label
            }
           
            
            lable?.font = UIFont.systemFont(ofSize: 17)
        }else{
            if isWorkType == true{
                lable?.text = nextworkTypeList[row].title
            }else{
                lable?.text = nexCityList[row].label
            }
 
            lable?.font = UIFont.systemFont(ofSize: 16)
        }
        lable?.textAlignment = .center
        return lable!
    }
}
