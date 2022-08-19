//
//  WorkerPubViewController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/18.
//

import UIKit
import IQKeyboardManager
import HXPHPicker
import SwiftUI
import CoreMIDI
import SwiftyJSON
import ObjectMapper
import ActionSheetPicker_3_0

class WorkerPubViewController: BaseViewController,Requestable {
 
    var tableView:UITableView!
    
    weak var collectionViewImg: UICollectionView!
    weak var collectionViewVod: UICollectionView!
    
    var mediaCell:PubMediaCell = PubMediaCell.init()
    var mediaVodCell:PubMediaCellVod = PubMediaCellVod.init()
    var introCell:WokerPubIntroCell = WokerPubIntroCell.init()
    
    
    var configImg: PickerConfiguration = PhotoTools.getWXPickerConfig(isMoment: true)
    var configVod: PickerConfiguration = PhotoTools.getWXPickerConfig(isMoment: true)
    
    /// 当前已选资源
    var selectedAssetsImg: [PhotoAsset] = []
    /// 是否选中的原图
    var isOriginalImg: Bool = false
    /// 相机拍摄的本地资源
    var localCameraAssetArrayImg: [PhotoAsset] = []
    var canSetAddCellImg: Bool {
        if selectedAssetsImg.count == configImg.maximumSelectedCount && configImg.maximumSelectedCount > 0 {
            return false
        }
        return true
    }
    
    
    
    /// 当前已选资源
    var selectedAssetsVod: [PhotoAsset] = []
    /// 是否选中的原图
    var isOriginalVod: Bool = false
    /// 相机拍摄的本地资源
    var localCameraAssetArrayVod: [PhotoAsset] = []
    var canSetAddCellVod: Bool {
        if selectedAssetsVod.count == configVod.maximumSelectedCount && configVod.maximumSelectedCount > 0 {
            return false
        }
        return true
    }
    
    var imageURLArr = [URL]()
    var vodURLArr = [URL]()
    var uploadImgArr =  [ImageModel]()
    var uploadVodArr =  [ImageModel]()
    
    var headView:WokerPubHeaderView!
    var headerBgView:UIView!
    var footerView:ChatBtnView!
    var footerBgView:UIView!
 
    
    
    
    var pubType = 1   //1发布职位 2发布求职
      /// 相关配置
    
   
    
    var salaryPicker:ActionSheetStringPicker? = nil //薪资选择器
    var salaryList = [DictModel]()
    
    var genderPicker:ActionSheetStringPicker? = nil //性别选择器
    let genderList = ["不限","男","女"]
    
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
    
    
    var isImgFile = true
    var jobModel = JobModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCityJson()
        initHeadView()
        initFooterView()
        initTableView()
        if pubType == 1{
            self.title = "发布找人"
        }else{
            self.title = "发布找场"
        }
        
        // Do any additional setup after loading the view.
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
                    //print("JSON is invalid")
                }
            } else {
                //print("no file")
            }
        } catch {
            //print(error.localizedDescription)
        }
        
        let workcateResult = XHNetworkCache.check(withURL: HomeAPI.workCategoryPath)
        if workcateResult {
            let dict = XHNetworkCache.cacheJson(withURL: HomeAPI.workCategoryPath)
            let responseJson = JSON(dict)
            workTypeList = getArrayFromJson(content: responseJson["data"]["cate"])
        }
        
        let salaryResult = XHNetworkCache.check(withURL: HomeAPI.salaryPath)
        if salaryResult {
            let dict = XHNetworkCache.cacheJson(withURL: HomeAPI.salaryPath)
            let responseJson = JSON(dict)
            salaryList = getArrayFromJson(content: responseJson["data"])
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
    
    func presentPickerController() {
        if isImgFile{
            configImg.modalPresentationStyle = .fullScreen
            if #available(iOS 13.0, *) {
                configImg.modalPresentationStyle = .automatic
            }
            let pickerController = PhotoPickerController.init(picker: configImg)
            pickerController.pickerDelegate = self
            pickerController.selectedAssetArray = selectedAssetsImg
            pickerController.localCameraAssetArray = localCameraAssetArrayImg
            pickerController.isOriginal = isOriginalImg
            pickerController.autoDismiss = false
            present(pickerController, animated: true, completion: nil)
        }else{
            configVod.modalPresentationStyle = .fullScreen
            if #available(iOS 13.0, *) {
                configVod.modalPresentationStyle = .automatic
            }
            let pickerController = PhotoPickerController.init(picker: configVod)
            pickerController.pickerDelegate = self
            pickerController.selectedAssetArray = selectedAssetsVod
            pickerController.localCameraAssetArray = localCameraAssetArrayVod
            pickerController.isOriginal = isOriginalVod
            pickerController.autoDismiss = false
            present(pickerController, animated: true, completion: nil)
        }
      
    }
    
    func initHeadView(){
        headView = Bundle.main.loadNibNamed("WokerPubHeaderView", owner: nil, options: nil)!.first as? WokerPubHeaderView
        headView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height:340)
        headView.initUI(type: pubType)
        headView.delegate = self
        
        headerBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 340))
        headerBgView.backgroundColor = UIColor.clear
        headerBgView.addSubview(headView)
        
    }
    
    
    func initFooterView(){
        footerView = Bundle.main.loadNibNamed("ChatBtnView", owner: nil, options: nil)!.first as? ChatBtnView
        footerView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 85)
        footerView.delegate = self
        footerView.chatBtn.setTitle("发布", for: .normal)
        footerBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 85))
        footerBgView.backgroundColor = UIColor.clear
        footerBgView.addSubview(footerView)
        
    }
    
    func initTableView(){
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = ZYJColor.main
        
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 240;
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.registerNibWithTableViewCellName(name: PubMediaCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: PubMediaCellVod.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: WokerPubIntroCell.nameOfClass)
        self.tableView.tableHeaderView = headerBgView
        tableView.tableFooterView = footerBgView
        
        view.addSubview(tableView)
        
    }
    
 
    
    func uploadPhoto(filePath: [URL]) {
        
        DialogueUtils.showWithStatus("正在上传")
        HttpRequest.uploadImage(url: HomeAPI.imageUpLoadUrl, filePath: filePath,success: { [self] (content) -> Void in
            DialogueUtils.dismiss()
            if self.isImgFile{
                self.uploadImgArr = getArrayFromJson(content: content)
            }else{
                self.uploadVodArr = getArrayFromJson(content: content)
            }
           
            //postAtricle()
           
         }) { (errorInfo) -> Void in
            DialogueUtils.dismiss()
             if self.isImgFile{
                 DialogueUtils.showError(withStatus: "图片上传失败，请重试")
              
             }else{
                 DialogueUtils.showError(withStatus: "视频上传失败，请重试")
              
             }
        }
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        DialogueUtils.dismiss()
        //DialogueUtils.showError(withStatus: description)
        
        if checkVip(){
            let noticeView = UIAlertController.init(title: "", message: "每天仅可发布3条找人找场哦，请看看其他的吧", preferredStyle: .alert)
            noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: {(action) in
            }))
            self.present(noticeView, animated: true, completion: nil)
        }else{
            let noticeView = UIAlertController.init(title: "", message: "非会员每天仅可以发布1条找人找场，请¥98元充值会员", preferredStyle: .alert)
            noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { [self] (action) in
                let controller = UIStoryboard.getCashierDeskController()
                controller.paytype = .chargeVip
                controller.priceStr = "98.00"
                self.present(controller, animated: true)
            }))
            noticeView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
                
            }))
            self.present(noticeView, animated: true, completion: nil)
        }
        return

    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        DialogueUtils.dismiss()
        DialogueUtils.showSuccess(withStatus: "发布成功")
        delay(second: 0.1) { [self] in
//            if (self.reloadBlock != nil) {
//                self.reloadBlock!()
//            }
            DialogueUtils.dismiss()
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
}
 
extension WorkerPubViewController:ChatBtnViewDelegate {
    func sumbitAction() {
        
        jobModel?.mobile = headView.phoneTextF.text!
        if !(CheckoutUtils.isMobile(mobile: jobModel!.mobile)){
            showOnlyTextHUD(text: "请输入正确的电话号码")
            return
        }
        jobModel?.type = pubType
        jobModel?.title = headView.titleTextF.text!
        if jobModel!.title.isEmptyStr(){
            showOnlyTextHUD(text: "请输入标题")
            return
        }
        jobModel?.city = self.city
        if jobModel!.city.isEmptyStr(){
            showOnlyTextHUD(text: "请选择城市")
            return
        }
       
        if jobModel!.mobile.isEmptyStr(){
            showOnlyTextHUD(text: "请输入联系方式")
            return
        }
        jobModel?.wechat = headView.phoneTextF.text!
        introCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WokerPubIntroCell
        jobModel?.detail = introCell.contentTV.text
        if jobModel!.detail.isEmptyStr(){
            showOnlyTextHUD(text: "请简要介绍项目")
            return
        }
        if jobModel!.cate_id == 0{
            showOnlyTextHUD(text: "请选择工种")
            return
        }
        if jobModel!.salary == 0{
            showOnlyTextHUD(text: "请选择薪资")
            return
        }
        
        if jobModel!.gender.isEmptyStr(){
            showOnlyTextHUD(text: "请选择性别")
            return
        }
        var imgstr = ""
        if uploadImgArr.count != 0{
            for imgM in self.uploadImgArr {
                imgstr = imgstr + imgM.url + ","
            }
            imgstr.remove(at: imgstr.index(before: imgstr.endIndex))
        }
        jobModel?.imagesURL = imgstr
        
        
        var vodstr = ""
        if uploadVodArr.count != 0{
            for vodM in self.uploadVodArr {
                vodstr = vodstr + vodM.url + ","
            }
            vodstr.remove(at: vodstr.index(before: vodstr.endIndex))
        }
 
        jobModel?.videoURL = vodstr
        jobModel?.name = ""
 
        var message = ""
        if pubType == 1{
            message = "您即将发布找人信息，确定发布吗？"
        }else{
            message = "您即将发布找场信息，确定发布吗？"
        }
        let noticeView = UIAlertController.init(title: "温馨提示", message: message, preferredStyle: .alert)
         
        noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { [self] (action) in
              let pathAndParams = HomeAPI.workAddPathAndParams(model: jobModel!)
              self.postRequest(pathAndParams: pathAndParams,showHUD: false)
         }))
         noticeView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
             
         }))
         self.present(noticeView, animated: true, completion: nil)
 
    }
    
    
}
extension WorkerPubViewController:WokerPubHeaderViewDelegate {
    func jobTypeTextAction() {
        isWorkType = true
        isNextWorkType = false
        isNextWorkType1 = false
        nextworkTypeList = workTypeList.first!.child
        self.workTypeChoosePicker = ActionSheetCustomPicker.init(title: "选择工种", delegate: self, showCancelButton: true, origin: self.view, initialSelections: [0,0])
        self.workTypeChoosePicker?.delegate = self
        workTypeChoosePicker?.tapDismissAction  = .success;
        workTypeChoosePicker?.show()
    }
    
    func salaryTypeTextAction() {
        var nextstrArr = [String]()
        if salaryList.count == 0{
            return
        }
        for model in salaryList {
            nextstrArr.append(model.salary)
        }
        self.salaryPicker = ActionSheetStringPicker(title: "薪资选择", rows: nextstrArr, initialSelection: 0, doneBlock: { [self] (picker, index, value) in
            let model = self.salaryList[index]
            jobModel?.salary = model.id
            self.headView.salaryTypeText.text = model.salary
 
        }, cancel: { (picker) in
            
        }, origin: self.view)
        self.salaryPicker!.tapDismissAction = .success
        self.salaryPicker!.show()
    }
    
    func addressTypeTextAction() {
        isWorkType = false
        isNextCitytment = false
        isNextCitytment1 = false
        nexCityList  = addressList.first!.children
        self.cityChoosePicker = ActionSheetCustomPicker.init(title: "选择城市", delegate: self, showCancelButton: true, origin: self.view, initialSelections: [0,0])
        self.cityChoosePicker?.delegate = self
        cityChoosePicker?.tapDismissAction  = .success;
        cityChoosePicker?.show()
    }
    
    func sexTypeTextAction() {
       
        self.genderPicker = ActionSheetStringPicker(title: "性别选择", rows: genderList, initialSelection: 0, doneBlock: { [self] (picker, index, value) in
            self.headView.sexTypeText.text = self.genderList[index]
            jobModel?.gender = self.genderList[index]
        }, cancel: { (picker) in
            
        }, origin: self.view)
        self.genderPicker!.tapDismissAction = .success
        self.genderPicker!.show()
    }
    
    
}
extension WorkerPubViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: notifyModelList.count ,isdisplay: true)
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "WokerPubIntroCell", for: indexPath) as! WokerPubIntroCell
            cell.initUI(type: pubType)
            cell.selectionStyle = .none
            cell.tableview = tableView;
            return cell;
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PubMediaCell", for: indexPath) as! PubMediaCell
            cell.row = 1
            cell.initUI(type: pubType)
            cell.delegate = self
            cell.selectionStyle = .none
            cell.selectedAssets = self.selectedAssetsImg
            cell.canSetAddCell = self.canSetAddCellImg
            cell.maximumSelectedCount = configImg.maximumSelectedCount
            cell.tableview = tableView;
            self.collectionViewImg = cell.collectionView
            return cell;
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PubMediaCellVod", for: indexPath) as! PubMediaCellVod
            cell.row = 2
            cell.delegate = self
            cell.selectionStyle = .none
            cell.selectedAssets = self.selectedAssetsVod
            cell.canSetAddCell = self.canSetAddCellVod
            cell.maximumSelectedCount = configVod.maximumSelectedCount
            cell.tableview = tableView;
            self.collectionViewVod = cell.collectionView
            return cell;
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      }
}

extension WorkerPubViewController: PubMediaCellDelegate {
    func deleteItem(index: Int) {
        selectedAssetsImg.remove(at: index)
        mediaCell = tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! PubMediaCell
        mediaCell.selectedAssets = self.selectedAssetsImg
        mediaCell.canSetAddCell = self.canSetAddCellImg
        mediaCell.updateCollectionViewHeight()
    }
    
    func didSelected(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath,row:Int) {
        
     
        if indexPath.item == configImg.maximumSelectedCount{

            if !checkVip(){
                let noticeView = UIAlertController.init(title: "", message: "您不是会员，请¥98元充值会员", preferredStyle: .alert)
                noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { [self] (action) in
                    let controller = UIStoryboard.getCashierDeskController()
                    controller.paytype = .chargeVip
                    controller.priceStr = "98.00"
                    self.present(controller, animated: true)
                }))
                noticeView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
                    
                }))
                self.present(noticeView, animated: true, completion: nil)
            }
            return
        }
        
        isImgFile = true
        if checkVip(){
            configImg.maximumSelectedCount = 9
        }else{
            configImg.maximumSelectedCount = 3
        }
        configImg.selectOptions = PickerAssetOptions.photo
        presentPickerController()
    }
}
extension WorkerPubViewController: PubMediaCellVodDelegate {
    func deleteItemVod(index: Int) {
        selectedAssetsVod.remove(at: index)
        mediaVodCell = tableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! PubMediaCellVod
        mediaVodCell.selectedAssets = self.selectedAssetsVod
        mediaVodCell.canSetAddCell = self.canSetAddCellVod
        mediaVodCell.updateCollectionViewHeight()
    }
    
    func didSelectedVod(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath,row:Int) {
        
        if indexPath.item == configVod.maximumSelectedCount{

            if !checkVip(){
                let noticeView = UIAlertController.init(title: "", message: "您不是会员，请¥98元充值会员", preferredStyle: .alert)
                noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { [self] (action) in
                    let controller = UIStoryboard.getCashierDeskController()
                    controller.paytype = .chargeVip
                    controller.priceStr = "98.00"
                    self.present(controller, animated: true)
                }))
                noticeView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
                    
                }))
                self.present(noticeView, animated: true, completion: nil)
            }
            return
        }
        
        isImgFile = false
        if checkVip(){
            configVod.maximumSelectedCount = 3
        }else{
            configVod.maximumSelectedCount = 1
        }
       
        configVod.maximumSelectedVideoDuration = 30
        configVod.maximumVideoEditDuration = 30
        
        configVod.selectOptions = PickerAssetOptions.video
        presentPickerController()
    }
}
// MARK: PhotoPickerControllerDelegate
extension WorkerPubViewController: PhotoPickerControllerDelegate {
    
    /// 选择完成之后调用
    func pickerController(_ pickerController: PhotoPickerController, didFinishSelection result: PickerResult) {
      
        
        if isImgFile{
            selectedAssetsImg = result.photoAssets
            isOriginalImg = result.isOriginal
            mediaCell = tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! PubMediaCell
            mediaCell.selectedAssets = self.selectedAssetsImg
            mediaCell.canSetAddCell = self.canSetAddCellImg
            mediaCell.updateCollectionViewHeight()
            collectionViewImg.reloadData()
        }else{
            selectedAssetsVod = result.photoAssets
            isOriginalVod = result.isOriginal
            mediaVodCell = tableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! PubMediaCellVod
            mediaVodCell.selectedAssets = self.selectedAssetsVod
            mediaVodCell.canSetAddCell = self.canSetAddCellVod
            mediaVodCell.updateCollectionViewHeight()
            collectionViewVod.reloadData()
        }
 
        
        pickerController.dismiss(animated: true, completion: nil)
        result.getURLs { [self] urls in
            if self.isImgFile {
                //print(self.isImgFile)
                self.imageURLArr = urls
                uploadPhoto(filePath: self.imageURLArr)
            }else{
                //print(self.isImgFile)
                print(urls);
                self.vodURLArr = urls
                uploadPhoto(filePath: self.vodURLArr)
            }
            
            //print(urls)
        }
        
       
    }
    /// Asset 编辑完后调用
    func pickerController(
        _ pickerController: PhotoPickerController,
        didEditAsset photoAsset: PhotoAsset, atIndex: Int) {
            if pickerController.isPreviewAsset {
                
                if isImgFile{
                    selectedAssetsImg[atIndex] = photoAsset
                    collectionViewImg.reloadItems(at: [IndexPath.init(item: atIndex, section: 0)])
                }else{
                    selectedAssetsVod[atIndex] = photoAsset
                    collectionViewVod.reloadItems(at: [IndexPath.init(item: atIndex, section: 0)])
                }
                
            }
        }
    /// 点击取消时调用
    func pickerController(didCancel pickerController: PhotoPickerController) {
        pickerController.dismiss(animated: true, completion: nil)
    }
    /// dismiss后调用
    func pickerController(
        _ pickerController: PhotoPickerController,
        didDismissComplete localCameraAssetArray: [PhotoAsset]) {
            setNeedsStatusBarAppearanceUpdate()
            if isImgFile{
                self.localCameraAssetArrayImg = localCameraAssetArray
            }else{
                self.localCameraAssetArrayVod = localCameraAssetArray
            }
            
        }
    /// 视图控制器即将显示
    
    func pickerController(
        _ pickerController: PhotoPickerController,
        viewControllersWillAppear viewController: UIViewController) {
            if pickerController.isPreviewAsset {
                let navHeight = viewController.navigationController?.navigationBar.hx.height ?? 0
                viewController.navigationController?.navigationBar.setBackgroundImage(
                    UIImage.gradualShadowImage(
                        CGSize(
                            width: view.hx.width,
                            height: UIDevice.isAllIPhoneX ? navHeight + 54 : navHeight + 30
                        )
                    ),
                    for: .default
                )
            }
        }
    /// 预览界面已经删除了 Asset
    func pickerController(
        _ pickerController: PhotoPickerController,
        previewDidDeleteAsset photoAsset: PhotoAsset, atIndex: Int) {
            previewDidDeleteAsset(index: atIndex)
        }
    
    func previewDidDeleteAsset(index: Int) {
        if isImgFile{
            let isFull = selectedAssetsImg.count == configImg.maximumSelectedCount
            selectedAssetsImg.remove(at: index)
            mediaCell = tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! PubMediaCell
            mediaCell.selectedAssets = self.selectedAssetsImg
            mediaCell.canSetAddCell = self.canSetAddCellImg
            
            if isFull {
                if isImgFile{
                    collectionViewImg.reloadData()
                }else{
                    collectionViewVod.reloadData()
                }
                
            }else {
                collectionViewImg.deleteItems(at: [IndexPath.init(item: index, section: 0)])
                mediaCell.updateCollectionViewHeight()
                collectionViewImg.reloadData()
                
             }
        }else{
            
            let isFull = selectedAssetsVod.count == configVod.maximumSelectedCount
            selectedAssetsVod.remove(at: index)
            mediaVodCell = tableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! PubMediaCellVod
            mediaVodCell.selectedAssets = self.selectedAssetsVod
            mediaVodCell.canSetAddCell = self.canSetAddCellVod
            
            if isFull {
                if isImgFile{
                    collectionViewImg.reloadData()
                }else{
                    collectionViewVod.reloadData()
                }
 
            }else {
                collectionViewVod.deleteItems(at: [IndexPath.init(item: index, section: 0)])
                mediaVodCell.updateCollectionViewHeight()
                collectionViewVod.reloadData()
              }
        }
     }
    
    /// present 预览时起始的视图，用于获取位置大小。与 presentPreviewFrameForIndexAt 一样
    func pickerController(
        _ pickerController: PhotoPickerController,
        presentPreviewViewForIndexAt index: Int) -> UIView? {
            if isImgFile{
                let cell = tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! PubMediaCell
                return cell
            }else{
                let cell = tableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! PubMediaCellVod
                return cell
            }
            //return UIView()
        }
    /// present预览时展示的image
    func pickerController(
        _ pickerController: PhotoPickerController,
        presentPreviewImageForIndexAt index: Int) -> UIImage? {
            if isImgFile{
                let cell = collectionViewImg.cellForItem(at: IndexPath(item: index, section: 0)) as? ResultViewCell
                return cell?.photoView.image
            }else{
                let cell = collectionViewVod.cellForItem(at: IndexPath(item: index, section: 0)) as? ResultViewCell
                return cell?.photoView.image
            }
            
        }
    /// dismiss 结束时对应的视图，用于获取位置大小。与 dismissPreviewFrameForIndexAt 一样
    func pickerController(
        _ pickerController: PhotoPickerController,
        dismissPreviewViewForIndexAt index: Int) -> UIView? {
            
            if isImgFile{
                let cell = tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! PubMediaCell
                return cell
            }else{
                let cell = tableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! PubMediaCellVod
                return cell
            }
           
        }
    
}


extension WorkerPubViewController:ActionSheetCustomPickerDelegate,UIPickerViewDelegate{
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
                jobModel?.cate_id = nextworkTypeList[row].id
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
                    jobModel?.cate_id = nextworkTypeList[0].id
                }
            }else{
                if isNextWorkType1 {
                    workType = workTypeList[0].title
                }else{
                    workType = workTypeList[0].title
                    nextworkTypeList = workTypeList[0].child
                    workTypeSub = nextworkTypeList[0].title
                    jobModel?.cate_id = nextworkTypeList[0].id
                }
                
            }
            
            headView.jobTypeText.text = workTypeSub
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
            headView.addressTypeText.text = province + city
        }
   
        
    }
    
    
    func actionSheetPickerDidCancel(_ actionSheetPicker: AbstractActionSheetPicker!, origin: Any!) {
        //print("123")
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
