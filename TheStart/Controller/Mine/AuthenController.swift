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
    @IBOutlet weak var ageText: UITextField!
    
   
    @IBOutlet weak var workTypeLabel: UILabel!
    @IBOutlet weak var addresslabel: UILabel!
   
    @IBOutlet weak var companyName: UITextField!
    
    @IBOutlet weak var summbitBtn: UIButton!
    
    
    var professionalModelList = [DepartmentModel]()
    var departmentsModelList = [DepartmentModel]()
    var nextDepartmentsList = [DepartmentModel]()
    
    
    var addressList = [AddressModel]()
    var cityList = [AddressModel]()
    var districtList = [AddressModel]()
    
    
    var officesChoosePicker:ActionSheetCustomPicker? = nil //科室选择器
    var titlePicker:ActionSheetStringPicker? = nil //职称选择器
    
    var addressPicker:ActionSheetCustomPicker? = nil //地址选择器
    
    var uploadTag = 0
    
    var userModel = UserModel()
    
    
    var isFormMine = false
    var isAddressPicker = true
    
    
    lazy var profileActionController: UIAlertController = UIAlertController.init(title: "选择照片", message: "", preferredStyle: .actionSheet)
    
    lazy var pickerController: UIImagePickerController = {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        return pickerController
    }()
    
    
    
    func createRightNavItem(title:String = "返回",imageStr:String = "") {
        if imageStr == ""{
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: title, style: .plain, target: self, action:  #selector(rightNavBtnClick))
        }else{
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: imageStr), style: .plain, target: self, action: #selector(rightNavBtnClick))
        }
        
        
    }
    
    
    @objc func rightNavBtnClick(){
        
        self.dismiss(animated: true, completion: nil)
        //跳转前的操作写这里
        
    }
    func initView(){
        
 
        
//        summbitBtn.backgroundColor = ZYJColor.main
//        summbitBtn.setTitle("提交", for:.normal)
//        summbitBtn.setTitleColor(UIColor.white, for: .normal)
//        summbitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        summbitBtn.layer.cornerRadius = 10
        summbitBtn.layer.masksToBounds = true
        
 
        
//
//        mobileText.isEnabled = false
//        mobileText.text = stringForKey(key: Constants.account)!
//       // userModel?.mobile = mobileText.text!
//        userModel?.password = stringForKey(key: Constants.password) ?? ""
//
//
//        if let gender = objectForKey(key: Constants.gender)  {
//
//            if gender is NSNull {
//                wommen.setImage(UIImage.init(named: "quanNO"), for: .normal)
//                menBtn.setImage(UIImage.init(named: "quanNO"), for: .normal)
//                //userModel!.sex = 0
//            }else{
//                if (gender as! Int) == 0 {
//                    wommen.setImage(UIImage.init(named: "quanNO"), for: .normal)
//                    menBtn.setImage(UIImage.init(named: "quanNO"), for: .normal)
//                }else if (gender as! Int) == 2 {
//                   // userModel?.sex = 2
//                    wommen.setImage(UIImage.init(named: "quanYES"), for: .normal)
//                    menBtn.setImage(UIImage.init(named: "quanNO"), for: .normal)
//                }else{
//                    //userModel?.sex = 1
//                    menBtn.setImage(UIImage.init(named: "quanYES"), for: .normal)
//                    wommen.setImage(UIImage.init(named: "quanNO"), for: .normal)
//                }
//            }
//        }else{
//            wommen.setImage(UIImage.init(named: "quanNO"), for: .normal)
//            menBtn.setImage(UIImage.init(named: "quanNO"), for: .normal)
//           // userModel!.sex = 0
//        }
//
//        let truename = stringForKey(key: Constants.truename)
//        if truename != nil && !(truename?.isLengthEmpty())!{
//            nameText.text = truename
//            //nameText.isEnabled = false
//        }
    }
    
 
    
    @IBAction func summbitAction(_ sender: Any) {
        
        
//        userModel?.user_realname = nameText.text!
//
//        if userModel!.user_realname.isLengthEmpty() {
//            showOnlyTextHUD(text: "请完善您的姓名")
//            return
//        }
//
//        
//        if userModel!.sex == 0 {
//            showOnlyTextHUD(text: "请选择您的性别")
//            return
//        }
//
//        if userModel!.mobile.isLengthEmpty(){
//            showOnlyTextHUD(text: "请输入您的手机号")
//            return
//        }
//
//
//
//
//        if userModel!.province_id == 0  {
//            showOnlyTextHUD(text: "请填写您的地址")
//            return
//        }
//
//        if userModel!.hospital.isLengthEmpty() {
//            showOnlyTextHUD(text: "请填写您的医院")
//            return
//        }
//
//        //TODO ZHAO
//        if userModel!.user_realname.isContainsEmoji() || (userModel!.hospital).isContainsEmoji() {
//            showOnlyTextHUD(text: "不支持输入表情")
//            return
//        }
//
//        let authenPersonalParams = HomeAPI.authDoctorPathAndParams(usermodel: userModel!)
//        postRequest(pathAndParams: authenPersonalParams,showHUD: false)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "实名认证"
       // prepareData()
        initView()
        if isFormMine == false{
            createRightNavItem(title: "返回", imageStr: "backarrow")
        }
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
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
//        let jobtitleParams = HomeAPI.professionalPathAndParams()
//        postRequest(pathAndParams: jobtitleParams,showHUD: false)
//
//        let result = XHNetworkCache.check(withURL: HomeAPI.addressPath)
//
//        if result {
//            DispatchQueue.main.async(execute: {
//                DialogueUtils.showWithStatus()
//                let dict = XHNetworkCache.cacheJson(withURL: HomeAPI.addressPath)
//                let responseJson = JSON(dict)
//                //print("缓存读取")
//                self.addressList = getArrayFromJson(content: responseJson["data"])
//
//                self.cityList = self.addressList.first!.children
//                self.districtList = self.addressList.first!.children.first!.children
//                DialogueUtils.dismiss()
//           })
//
//        }else{
//            let addressParams = HomeAPI.addressPathAndParams()
//            getRequest(pathAndParams: addressParams,showHUD:false)
//        }
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
    @objc func badgeImageAction(){
        self.present(profileActionController, animated: true, completion: nil)
        profileActionController.message = "请选择您的胸牌照片"
        uploadTag = 0
        
    }
    @objc func certificateImage1Action(){
        self.present(profileActionController, animated: true, completion: nil)
        profileActionController.message = "请选择您的医师资格证照片"
        uploadTag = 1
        
    }
    
    
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
        
//        if indexPath.section == 0{
//
//        }
//        else if indexPath.section == 1{
//            if indexPath.row == 0{
//                isAddressPicker = false
//                isNextDepartment = false
//                isNextDepartment1 = false
//                nextDepartmentsList = departmentsModelList.first!.child
//                self.officesChoosePicker = ActionSheetCustomPicker.init(title: "科室选择", delegate: self, showCancelButton: true, origin: self.view, initialSelections: [0,0])
//                self.officesChoosePicker?.delegate = self
//                officesChoosePicker?.tapDismissAction  = .success;
//                officesChoosePicker?.show()
//
//
//            }else if indexPath.row == 1 {
//                var nextstrArr = [String]()
//                if professionalModelList.count == 0{
//                    return
//                }
//                for model in professionalModelList {
//                    nextstrArr.append(model.name)
//                }
//                self.titlePicker = ActionSheetStringPicker(title: "职称选择", rows: nextstrArr, initialSelection: 0, doneBlock: { (picker, index, value) in
//                    let model = self.professionalModelList[index]
//                    self.titleLabel.text = model.name
//                    self.userModel?.professional_text = model.name
//                    self.userModel?.professional_id = model.id
//                }, cancel: { (picker) in
//
//                }, origin: self.view)
//                self.titlePicker!.tapDismissAction = .cancel
//                self.titlePicker!.show()
//            }else if indexPath.row == 2{
//
//                    cityList = addressList.first!.children
//                    districtList = addressList.first!.children.first!.children
//                    isAddressScroll = false
//                    isCityScroll = false
//                    isDistrictScroll = false
//
//                    isAddressPicker = true
//                    self.addressPicker = ActionSheetCustomPicker.init(title: "地址选择", delegate: self, showCancelButton: true, origin: self.view, initialSelections: [0,0,0])
//                    self.addressPicker?.delegate = self
//                    addressPicker?.tapDismissAction  = .success;
//                    addressPicker?.show()
//
//
//            }else if indexPath.row == 3{
//                let controller = HospitalViewController()
//
//                if provincetext == "" || citytext == ""{
//                    showOnlyTextHUD(text: "请先选择您的地址")
//                    return
//                }
//                controller.provinceName = provincetext
//                controller.cityName = citytext
//                controller.searchCallBack = {[weak self] (nickName) -> Void in
//                    self?.hospiitalName.text = nickName
//                    self?.userModel!.hospital = nickName
//                 }
//                self.navigationController?.pushViewController(controller, animated: true)
//                //
//            }
//        }
    }
    
 
    
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        nameText.resignFirstResponder()
        mobileText.resignFirstResponder()
       // hospitalText.resignFirstResponder()
    }
    //13336088188
 
    
    var isNextDepartment = false
    var isNextDepartment1 = false
    
    
    var isAddressScroll = false
    var isCityScroll = false
    var isDistrictScroll = false
    
    var provincetext = ""
    var citytext = ""
    var districttext = ""
    var addressAll = ""
    
    
}

extension AuthenController:ActionSheetCustomPickerDelegate,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if isAddressPicker == false {
            return 2
        }else{
            return 3
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if isAddressPicker == false {
            
            if component == 0{
                return departmentsModelList.count
            }else{
                return nextDepartmentsList.count
            }
            
        }else{
            if component == 0{
                return addressList.count
            }else if component == 1{
                
                if cityList.count == 0{
                    return 0
                }
                return (cityList.count)
                
            }else{
                
                if districtList.count == 0{
                    return 0
                }
                return (districtList.count)
            }
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        if isAddressPicker == false {
            if component == 0{
                return departmentsModelList[row].name
            }else{
                return nextDepartmentsList[row].name
            }
        }else{
            if component == 0{
                return addressList[row].name
            }else if component == 1{
                return cityList[row].name
            }else{
                return districtList[row].name
            }
        }
 
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
//        if isAddressPicker == false {
//
//            if component == 0{
//                isNextDepartment = true
//                nextDepartmentsList = departmentsModelList[row].child
//
//                pickerView.selectRow(0, inComponent: 1, animated: true)
//                pickerView.reloadComponent(1)
//            }else{
//                isNextDepartment1 = true
//                self.userModel?.department_text = nextDepartmentsList[row].name
//                self.userModel?.department_id = nextDepartmentsList[row].id
//                officesLabel.text = nextDepartmentsList[row].name
//            }
//        }else{
//            if component == 0{
//                isAddressScroll = true
//                cityList = addressList[row].children
//                pickerView.reloadComponent(1)
//                pickerView.selectRow(0, inComponent: 1, animated: true)
//
//                districtList = cityList.first!.children
//
//                pickerView.reloadComponent(2)
//                pickerView.selectRow(0, inComponent: 2, animated: true)
//
//
//                self.userModel?.province_id = addressList[row].id
//                provincetext = addressList[row].name
//
//            }else if component == 1{
//                isCityScroll = true
//                districtList = cityList[row].children
//                pickerView.reloadComponent(2)
//                pickerView.selectRow(0, inComponent: 2, animated: true)
//
//                self.userModel?.city_id = cityList[row].id
//                citytext = cityList[row].name
//            }else{
//                 isDistrictScroll = true
//                 self.userModel?.district_id = districtList[row].id
//                 districttext = districtList[row].name
//                // addresslabel.text = provincetext + citytext + districttext
//            }
//        }
    }
    func actionSheetPickerDidSucceed(_ actionSheetPicker: AbstractActionSheetPicker!, origin: Any!) {
//        if isAddressPicker == false {
//            if isNextDepartment {
//                if isNextDepartment1{
//
//                }else{
//                    self.userModel?.department_text = nextDepartmentsList[0].name
//                    self.userModel?.department_id = nextDepartmentsList[0].id
//                    officesLabel.text = nextDepartmentsList[0].name
//                }
//
//            }else{
//                if isNextDepartment1 {
//
//                }else{
//                    nextDepartmentsList = departmentsModelList[0].child
//                    self.userModel?.department_text = nextDepartmentsList[0].name
//                    self.userModel?.department_id = nextDepartmentsList[0].id
//                    officesLabel.text = nextDepartmentsList[0].name
//                }
//
//        }
//        }else{
//            if isAddressScroll {
//                if isCityScroll{
//                    if isDistrictScroll{
//                        addresslabel.text = provincetext + citytext + districttext
//                    }else{
//
//                        if districtList.count == 0{
//                            self.userModel?.district_id = 0
//                        }else{
//                            self.userModel?.district_id = districtList[0].id
//                        }
//
//                        if districtList.count == 0{
//                            districttext = ""
//                        }else{
//                            districttext = districtList[0].name
//                        }
//
//
//                        addresslabel.text = provincetext + citytext + districttext
//                    }
//                }else{
//                    if isDistrictScroll{
//                        self.userModel?.city_id = cityList[0].id
//                        citytext = cityList[0].name
//
//                        addresslabel.text = provincetext + citytext + districttext
//
//                    }else{
//
//                        self.userModel?.city_id = cityList[0].id
//                        citytext = cityList[0].name
//
//                        if districtList.count == 0{
//                            self.userModel?.district_id = 0
//                        }else{
//                            self.userModel?.district_id = districtList[0].id
//                        }
//                        if districtList.count == 0{
//                            districttext = ""
//                        }else{
//                            districttext = districtList[0].name
//                        }
//                        addresslabel.text = provincetext + citytext + districttext
//                    }
//                }
//            }else{
//                if isCityScroll{
//                    if isDistrictScroll{
//
//                        self.userModel?.province_id = addressList[0].id
//                        provincetext = addressList[0].name
//
//                        addresslabel.text = provincetext + citytext + districttext
//                    }else{
//
//                        self.userModel?.province_id = addressList[0].id
//                        provincetext = addressList[0].name
//
//                        if districtList.count == 0{
//                            self.userModel?.district_id = 0
//                        }else{
//                            self.userModel?.district_id = districtList[0].id
//                        }
//                        if districtList.count == 0{
//                            districttext = ""
//                        }else{
//                            districttext = districtList[0].name
//                        }
//
//                        addresslabel.text = provincetext + citytext + districttext
//                    }
//                }else{
//                    if isDistrictScroll{
//
//
//                        self.userModel?.province_id = addressList[0].id
//                        provincetext = addressList[0].name
//
//                        self.userModel?.city_id = cityList[0].id
//                        citytext = cityList[0].name
//
//                        addresslabel.text = provincetext + citytext + districttext
//
//                    }else{
//
////                        self.userModel?.province_id = addressList[0].id
////                        provincetext = addressList[0].name
////
////                        self.userModel?.city_id = cityList[0].id
////                        citytext = cityList[0].name
////
////                        self.userModel?.district_id = districtList[0].id
////                        districttext = districtList[0].name
////                        addresslabel.text = provincetext + citytext + districttext
//                    }
//                }
//             }
//         }
        
    }
    
    
    func actionSheetPickerDidCancel(_ actionSheetPicker: AbstractActionSheetPicker!, origin: Any!) {
        
    }
    
    //重置label
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var lable:UILabel? = view as? UILabel
        if lable == nil{
            lable = UILabel.init()
        }
        
        
        if isAddressPicker == false {
            if component == 0{
                
                lable?.text = departmentsModelList[row].name
                lable?.font = UIFont.systemFont(ofSize: 17)
            }else{
                lable?.text = nextDepartmentsList[row].name
                lable?.font = UIFont.systemFont(ofSize: 16)
            }
        }else{
            if component == 0{
                
                lable?.text = addressList[row].name
                lable?.font = UIFont.systemFont(ofSize: 17)
            }
            else if component == 1{
                lable?.text = cityList[row].name
                lable?.font = UIFont.systemFont(ofSize: 16)
            }
            else{
                lable?.text = districtList[row].name
                lable?.font = UIFont.systemFont(ofSize: 16)
            }
        }
     
        
        
        lable?.textAlignment = .center
        return lable!
    }
}
