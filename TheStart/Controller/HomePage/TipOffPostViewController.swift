//
//  TipOffPostViewController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/16.
//

import UIKit
import IQKeyboardManager
import HXPHPicker
import SwiftUI
import CoreMIDI
import SwiftyJSON
import ObjectMapper
import ActionSheetPicker_3_0

class TipOffPostViewController: BaseViewController,Requestable {
    
    var contentTV:UITextView!

    var tableView:UITableView!
    var footerView:ChatBtnView!
    var footerBgView:UIView!
    
    var tipOffID = 0
    var articleType = 1
    
    
    var reloadBlock:(() -> Void)?
    
    
    
    weak var collectionView: UICollectionView!
    /// 当前已选资源
    var selectedAssets: [PhotoAsset] = []
    /// 是否选中的原图
    var isOriginal: Bool = false
    
    var localAssetArray: [PhotoAsset] = []
    
    var imageCell:TipOffPostIImgCell = TipOffPostIImgCell.init()
    
    var addressView:TipOffAddressView!
    
    var imageDataArr = [Data]()
    var imageURLArr = [URL]()
    
    
    
    var uploadImgArr =  [ImageModel]()
    var articleModel = TipOffModel()
    var contentCell =  TipOffpootContentCell()
    
   
    /// 相机拍摄的本地资源
    var localCameraAssetArray: [PhotoAsset] = []
    /// 相关配置
    var config: PickerConfiguration = PhotoTools.getWXPickerConfig(isMoment: true)
    var rightBarButton:UIButton!
    
    var canSetAddCell: Bool {
        if selectedAssets.count == config.maximumSelectedCount &&
            config.maximumSelectedCount > 0 {
            return false
        }
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if articleType == 1{
            self.title = "报黑信息"
        }else{
            self.title = "澄清信息"
        }
        createRightNavItem()
        loadCityJson()
        initFooterView()
        initTableView()
        // Do any additional setup after loading the view.
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
    func createRightNavItem() {
        
        rightBarButton = UIButton.init()
        let bgview = UIView.init()
 
            
        rightBarButton.frame = CGRect.init(x: 0, y: 6, width: 63, height: 28)
        rightBarButton.setTitle("发布", for: .normal)
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
        
        if imageURLArr.count == 0{
            showOnlyTextHUD(text: "请添加图片")
            return
        }
        self.uploadPhoto(filePath:imageURLArr)
    }
    
    func presentPickerController() {
        config.modalPresentationStyle = .fullScreen
        
        if #available(iOS 13.0, *) {
            config.modalPresentationStyle = .automatic
        }
        let pickerController = PhotoPickerController.init(picker: config)
        pickerController.pickerDelegate = self
        pickerController.selectedAssetArray = selectedAssets
        pickerController.localCameraAssetArray = localCameraAssetArray
        pickerController.isOriginal = isOriginal
        pickerController.localAssetArray = localAssetArray
        pickerController.autoDismiss = false
        present(pickerController, animated: true, completion: nil)
    }
    
    func initFooterView(){
        addressView = Bundle.main.loadNibNamed("TipOffAddressView", owner: nil, options: nil)!.first as? TipOffAddressView
        addressView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 113)
        addressView.delegate = self
        footerBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 113))
        footerBgView.backgroundColor = ZYJColor.main
        footerBgView.addSubview(addressView)
    }
 
    func initTableView(){
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - bottomBlankHeight - navigationHeaderAndStatusbarHeight), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = ZYJColor.main
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.tableFooterView = footerBgView
        tableView.registerNibWithTableViewCellName(name: TipOffpootContentCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: TipOffPostIImgCell.nameOfClass)
        tableView.tableHeaderView = UIView()
        view.addSubview(tableView)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }
    
    
    
    func uploadPhoto(filePath: [URL]) {
       
    
        HttpRequest.uploadImage(url: HomeAPI.imageUpLoadUrl, filePath: filePath,success: { [self] (content) -> Void in
            
            self.uploadImgArr = getArrayFromJson(content: content)
            postAtricle()
           
         }) { (errorInfo) -> Void in
            DialogueUtils.dismiss()
            DialogueUtils.showError(withStatus: "图片上传失败，请重试")
         
        }
    }
    
    func postAtricle(){
        
        articleModel?.type = articleType
        articleModel?.clarify_id = tipOffID
        articleModel?.title = addressView.titleLabel.text ?? ""
        articleModel?.content = contentCell.contentTV.text
        var imgstr = ""
        if uploadImgArr.count != 0{
            for imgM in self.uploadImgArr {
                imgstr = imgstr + imgM.url + ","
            }
            imgstr.remove(at: imgstr.index(before: imgstr.endIndex))
        }
        articleModel?.upLoadImg = imgstr
        
        if articleModel?.content == ""{
            DialogueUtils.showError(withStatus: "内容不能为空")
            return
        }
        articleModel?.address = province + city
        let pathAndParams = HomeAPI.addTipOffPathAndParams(model: articleModel!)
        postRequest(pathAndParams: pathAndParams,showHUD: false)
        
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        DialogueUtils.dismiss()
        DialogueUtils.showError(withStatus: "发布失败，请重试")
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        DialogueUtils.dismiss()
        DialogueUtils.showSuccess(withStatus: "发布成功")
        delay(second: 1) { [self] in
            if (self.reloadBlock != nil) {
                self.reloadBlock!()
            }
            DialogueUtils.dismiss()
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    var officesChoosePicker:ActionSheetCustomPicker? = nil //城市选择器
    var nextDepartmentsList = [AddressModel]()
    var addressList = [AddressModel]()
    var isNextDepartment = false
    var isNextDepartment1 = false
    
    
    var province = ""
    var city = ""
    
}

extension TipOffPostViewController:TipOffAddressViewDelegate{
    func addrerssAction() {
        isNextDepartment = false
        isNextDepartment1 = false
        nextDepartmentsList = addressList.first!.children
        self.officesChoosePicker = ActionSheetCustomPicker.init(title: "选择城市", delegate: self, showCancelButton: true, origin: self.view, initialSelections: [0,0])
        self.officesChoosePicker?.delegate = self
        officesChoosePicker?.tapDismissAction  = .success;
        officesChoosePicker?.show()
    }
 
}
extension TipOffPostViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TipOffpootContentCell", for: indexPath) as! TipOffpootContentCell
            cell.selectionStyle = .none
            cell.tableview = tableView;
            self.contentTV = cell.contentTV
            contentCell = cell
            return cell;
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TipOffPostIImgCell", for: indexPath) as! TipOffPostIImgCell
            cell.selectionStyle = .none
            cell.backgroundColor = ZYJColor.main
            cell.contentView.backgroundColor = ZYJColor.main
            cell.delegate = self
            cell.selectedAssets = self.selectedAssets
            cell.canSetAddCell = self.canSetAddCell
            cell.maximumSelectedCount = config.maximumSelectedCount
            cell.tableview = tableView;
            self.collectionView = cell.collectionView
            return cell;
        }
 
    }
    
 
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.contentTV.resignFirstResponder()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // self.presentPickerController()
    }
 
}
extension TipOffPostViewController:ActionSheetCustomPickerDelegate,UIPickerViewDelegate{
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
           addressView.addrerssLabel.text = province + city
     
    }
    
    
    func actionSheetPickerDidCancel(_ actionSheetPicker: AbstractActionSheetPicker!, origin: Any!) {
        print("123")
        addressView.addrerssLabel.text = province + city
        
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

extension TipOffPostViewController: TipOffPostIImgCellDelegate {
    func deleteItem(indexPath: IndexPath) {
        selectedAssets.remove(at: indexPath.item)
        imageCell = tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! TipOffPostIImgCell
        imageCell.selectedAssets = self.selectedAssets
        imageCell.canSetAddCell = self.canSetAddCell
        imageCell.updateCollectionViewHeight()
    }
    
    func didSelected(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if canSetAddCell && indexPath.item == selectedAssets.count {
            presentPickerController()
            return
        }
        if selectedAssets.isEmpty {
            return
        }
        var style: UIModalPresentationStyle = .custom
        if #available(iOS 13.0, *) {
            style = .fullScreen
        }
        var config = PhotoBrowser.Configuration()
        config.showDelete = true
        config.modalPresentationStyle = style
        let cell = collectionView.cellForItem(at: indexPath) as? ResultViewCell
        PhotoBrowser.show(
            // 预览的资源数组
            selectedAssets,
            // 当前预览的位置
            pageIndex: indexPath.item,
            // 预览相关配置
            config: config,
            // 转场动画初始的 UIImage
            transitionalImage: cell?.photoView.image
        ) { index in
            print(index)
            // 转场过渡时起始/结束时 对应的 UIView
            //            self.collectionView.cellForItem(
            //                at: IndexPath(
            //                    item: index,
            //                    section: 0
            //                )
            //            ) as? ResultViewCell
            return self.tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! TipOffPostIImgCell
        } deleteAssetHandler: { index, photoAsset, photoBrowser in
            // 点击了删除按钮
            PhotoTools.showAlert(
                viewController: photoBrowser,
                title: "是否删除当前资源",
                leftActionTitle: "确定",
                leftHandler: { (alertAction) in
                    photoBrowser.deleteCurrentPreviewPhotoAsset()
                    self.previewDidDeleteAsset(
                        index: index
                    )
                }, rightActionTitle: "取消") { (alertAction) in }
        } longPressHandler: { index, photoAsset, photoBrowser in
            // 长按事件
            self.previewLongPressClick(
                photoAsset: photoAsset,
                photoBrowser: photoBrowser
            )
        }
    }
    
    func previewLongPressClick(photoAsset: PhotoAsset, photoBrowser: PhotoBrowser) {
        let alert = UIAlertController(title: "长按事件", message: nil, preferredStyle: .actionSheet)
        alert.addAction(
            .init(
                title: "保存",
                style: .default,
                handler: { alertAction in
                    photoBrowser.view.hx.show(animated: true)
                    if photoAsset.mediaSubType == .localLivePhoto {
                        photoAsset.requestLocalLivePhoto { imageURL, videoURL in
                            guard let imageURL = imageURL, let videoURL = videoURL else {
                                photoBrowser.view.hx.hide(animated: true)
                                photoBrowser.view.hx.showWarning(text: "保存失败", delayHide: 1.5, animated: true)
                                return
                            }
                            AssetManager.saveLivePhotoToAlbum(imageURL: imageURL, videoURL: videoURL) {
                                photoBrowser.view.hx.hide(animated: true)
                                if $0 != nil {
                                    photoBrowser.view.hx.showSuccess(text: "保存成功", delayHide: 1.5, animated: true)
                                }else {
                                    photoBrowser.view.hx.showWarning(text: "保存失败", delayHide: 1.5, animated: true)
                                }
                            }
                        }
                        return
                    }
                    func saveImage(_ image: Any) {
                        AssetManager.saveSystemAlbum(forImage: image) { phAsset in
                            if phAsset != nil {
                                photoBrowser.view.hx.showSuccess(text: "保存成功", delayHide: 1.5, animated: true)
                            }else {
                                photoBrowser.view.hx.showWarning(text: "保存失败", delayHide: 1.5, animated: true)
                            }
                        }
                    }
                    func saveVideo(_ videoURL: URL) {
                        AssetManager.saveSystemAlbum(forVideoURL: videoURL) { phAsset in
                            if phAsset != nil {
                                photoBrowser.view.hx.showSuccess(text: "保存成功", delayHide: 1.5, animated: true)
                            }else {
                                photoBrowser.view.hx.showWarning(text: "保存失败", delayHide: 1.5, animated: true)
                            }
                        }
                    }
                    photoAsset.getAssetURL { result in
                        switch result {
                        case .success(let response):
                            if response.mediaType == .photo {
                                if response.urlType == .network {
                                    PhotoTools.downloadNetworkImage(
                                        with: response.url,
                                        options: [],
                                        completionHandler: { image in
                                            photoBrowser.view.hx.hide(animated: true)
                                            if let image = image {
                                                saveImage(image)
                                            }else {
                                                photoBrowser.view.hx.showWarning(text: "保存失败", delayHide: 1.5, animated: true)
                                            }
                                        })
                                }else {
                                    saveImage(response.url)
                                    photoBrowser.view.hx.hide(animated: true)
                                }
                            }else {
                                if response.urlType == .network {
                                    PhotoManager.shared.downloadTask(
                                        with: response.url,
                                        progress: nil) { videoURL, error, _ in
                                            photoBrowser.view.hx.hide(animated: true)
                                            if let videoURL = videoURL {
                                                saveVideo(videoURL)
                                            }else {
                                                photoBrowser.view.hx.showWarning(text: "保存失败", delayHide: 1.5, animated: true)
                                            }
                                        }
                                }else {
                                    photoBrowser.view.hx.hide(animated: true)
                                    saveVideo(response.url)
                                }
                            }
                        case .failure(_):
                            photoBrowser.view.hx.hide(animated: true)
                            photoBrowser.view.hx.showWarning(text: "保存失败", delayHide: 1.5, animated: true)
                        }
                    }
                }))
        alert.addAction(
            .init(
                title: "删除",
                style: .destructive,
                handler: { [weak self] alertAction in
                    photoBrowser.deleteCurrentPreviewPhotoAsset()
                    if let index = photoBrowser.previewViewController?.currentPreviewIndex {
                        self?.previewDidDeleteAsset(index: index)
                    }
                }))
        alert.addAction(.init(title: "取消", style: .cancel, handler: nil))
        if UIDevice.isPad {
            let pop = alert.popoverPresentationController
            pop?.permittedArrowDirections = .any
            pop?.sourceView = photoBrowser.view
            pop?.sourceRect = CGRect(
                x: photoBrowser.view.hx.width * 0.5,
                y: photoBrowser.view.hx.height,
                width: 0,
                height: 0
            )
        }
        photoBrowser.present(alert, animated: true, completion: nil)
    }
    
}



// MARK: PhotoPickerControllerDelegate
extension TipOffPostViewController: PhotoPickerControllerDelegate {
    
    /// 选择完成之后调用
    func pickerController(_ pickerController: PhotoPickerController, didFinishSelection result: PickerResult) {
        
        DialogueUtils.showWithStatus("正在上传")
        selectedAssets = result.photoAssets
        isOriginal = result.isOriginal
        imageCell = tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! TipOffPostIImgCell
        imageCell.selectedAssets = self.selectedAssets
        imageCell.canSetAddCell = self.canSetAddCell
        imageCell.updateCollectionViewHeight()
        collectionView.reloadData()
        
        
        pickerController.dismiss(animated: true, completion: nil)
        
        result.getURLs { urls in
            self.imageURLArr = urls
        }
       
//        result.getImage { (image, photoAsset, index) in
//
//            print(photoAsset)
//            if let image = image {
//                self.imageDataArr.append(image.pngData()!)
//                print("success", image)
//            }else {
//                print("failed")
//            }
//        } completionHandler: { (images) in
//            print(images)
//        }
//        print(imageDataArr)
        
    }
    /// Asset 编辑完后调用
    func pickerController(
        _ pickerController: PhotoPickerController,
        didEditAsset photoAsset: PhotoAsset, atIndex: Int) {
            if pickerController.isPreviewAsset {
                selectedAssets[atIndex] = photoAsset
                collectionView.reloadItems(at: [IndexPath.init(item: atIndex, section: 0)])
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
            self.localCameraAssetArray = localCameraAssetArray
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
        let isFull = selectedAssets.count == config.maximumSelectedCount
        selectedAssets.remove(at: index)
        
        imageCell = tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! TipOffPostIImgCell
        imageCell.selectedAssets = self.selectedAssets
        imageCell.canSetAddCell = self.canSetAddCell
        
        if isFull {
            collectionView.reloadData()
        }else {
            collectionView.deleteItems(at: [IndexPath.init(item: index, section: 0)])
            imageCell.updateCollectionViewHeight()
            collectionView.reloadData()
        }
        
    }
    
    /// present 预览时起始的视图，用于获取位置大小。与 presentPreviewFrameForIndexAt 一样
    func pickerController(
        _ pickerController: PhotoPickerController,
        presentPreviewViewForIndexAt index: Int) -> UIView? {
            let cell = tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! TipOffPostIImgCell
            return cell
            //return UIView()
        }
    /// present预览时展示的image
    func pickerController(
        _ pickerController: PhotoPickerController,
        presentPreviewImageForIndexAt index: Int) -> UIImage? {
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? ResultViewCell
            return cell?.photoView.image
        }
    /// dismiss 结束时对应的视图，用于获取位置大小。与 dismissPreviewFrameForIndexAt 一样
    func pickerController(
        _ pickerController: PhotoPickerController,
        dismissPreviewViewForIndexAt index: Int) -> UIView? {
            let cell = tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! TipOffPostIImgCell
            return cell
        }
    
}


