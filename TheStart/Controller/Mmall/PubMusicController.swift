
//
//  WorkerPubViewController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/18.
//

import UIKit
import IQKeyboardManager
import HXPHPicker
import SwiftyJSON
import ObjectMapper
import ActionSheetPicker_3_0
class PubMusicController: BaseViewController,Requestable {

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
        if selectedAssetsVod.count == configVod.maximumSelectedVideoCount && configVod.maximumSelectedVideoCount > 0 {
            return false
        }
        return true
    }
    
    var imageURLArr = [URL]()
    var vodURLArr = [URL]()
    var uploadImgArr =  [ImageModel]()
    var uploadVodArr =  [ImageModel]()
    
    
    var headView:PubMusicHeader!
    var headerBgView:UIView!
    var footerView:ChatBtnView!
    var footerBgView:UIView!
    
    
    
    var audioModel = AudioModel()
    
    var isImgFile = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHeadView()
        self.view.backgroundColor = ZYJColor.main
        initFooterView()
        initTableView()
        self.title = "发布音乐"
        // Do any additional setup after loading the view.
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
        headView = Bundle.main.loadNibNamed("PubMusicHeader", owner: nil, options: nil)!.first as? PubMusicHeader
        headView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 328)
        headView.delegate = self
        headerBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 328))
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
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        DialogueUtils.dismiss()
        DialogueUtils.showError(withStatus: description)
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        DialogueUtils.dismiss()
        DialogueUtils.showSuccess(withStatus: "发布成功")
        delay(second: 0.5) { [self] in
//            if (self.reloadBlock != nil) {
//                self.reloadBlock!()
//            }
            DialogueUtils.dismiss()
            self.navigationController?.popViewController(animated: true)
        }
        
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
    var typePicker:ActionSheetStringPicker? = nil //性别选择器

    let typeList = ["开场","颗粒or爆点","set套曲","其他"]
 
}
extension PubMusicController:PubMusicHeaderDelegate {
    func chooseType(){
        self.typePicker = ActionSheetStringPicker(title: "类型选择", rows: typeList, initialSelection: 0, doneBlock: { [self] (picker, index, value) in
            self.headView.musicTypelabel.text = self.typeList[index]
            audioModel?.type = index + 1
        }, cancel: { (picker) in
            
        }, origin: self.view)
        self.typePicker!.tapDismissAction = .success
        self.typePicker!.show()
    }
}

extension PubMusicController:ChatBtnViewDelegate {
    func sumbitAction() {

        audioModel?.name = headView.nameTV.text!
        if audioModel!.name.isEmptyStr(){
            showOnlyTextHUD(text: "请输入名称")
            return
        }
        
        audioModel?.price = headView.MoneyTF.text!
        
        if checkMarketVer(){
            if audioModel!.price.isEmptyStr(){
                showOnlyTextHUD(text: "请输入类型")
                return
            }
        }else{
            if audioModel!.price.isEmptyStr(){
                showOnlyTextHUD(text: "请输入价格")
                return
            }
        }
       
        
//        if !(CheckoutUtils.isValidNumber(number: audioModel!.price)){
//            showOnlyTextHUD(text: "价格只能为数字")
//            return
//        }
        
 
        audioModel?.link = headView.wanpanTV.text!
        if audioModel!.link.isEmptyStr(){
            showOnlyTextHUD(text: "请输入网盘链接")
            return
        }
        
         if audioModel!.type == 0{
            showOnlyTextHUD(text: "请选择音乐类型")
            return
        }
        
        if !(CheckoutUtils.isValidURL(url: audioModel!.link)){
            showOnlyTextHUD(text: "请输入正确的链接")
            return
        }
        
 
        audioModel?.code = headView.wangpanCode.text!
        if audioModel!.code.isEmptyStr(){
            showOnlyTextHUD(text: "请输入提取码")
            return
        }
        if audioModel!.code.count > 8{
            showOnlyTextHUD(text: "提取码过长，请检查")
            return
        }
 
        audioModel?.vip_free = headView.isFree
        if audioModel?.vip_free == -1{
            showOnlyTextHUD(text: "请选择是否免费下载")
            return
        }

        introCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WokerPubIntroCell
        audioModel?.info = introCell.contentTV.text
        if audioModel!.info.isEmptyStr(){
            showOnlyTextHUD(text: "请简要介绍音乐")
            return
        }

        var imgstr = ""
        if uploadImgArr.count != 0{
            for imgM in self.uploadImgArr {
                imgstr = imgstr + imgM.url + ","
            }
            imgstr.remove(at: imgstr.index(before: imgstr.endIndex))
            
            audioModel?.image = self.uploadImgArr.first!.url

        }
        audioModel?.imagesUrl = imgstr
        
 
        var vodstr = ""
        if uploadVodArr.count != 0{
            for vodM in self.uploadVodArr {
                vodstr = vodstr + vodM.url + ","
            }
            vodstr.remove(at: vodstr.index(before: vodstr.endIndex))
        }

        audioModel?.audio_path = vodstr
 //
        let pathAndParams = HomeAPI.audioPubPathAndParams(model: audioModel!)
        postRequest(pathAndParams: pathAndParams,showHUD: true)
 
    }
    
    
}
extension PubMusicController:UITableViewDataSource,UITableViewDelegate {
    
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
            cell.initUI(type: 3)
            cell.selectionStyle = .none
            cell.tableview = tableView;
            return cell;
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PubMediaCell", for: indexPath) as! PubMediaCell
            cell.row = 1
            cell.initUI(type: 1)
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
            cell.maximumSelectedCount = configVod.maximumSelectedVideoCount
            cell.tableview = tableView;
            self.collectionViewVod = cell.collectionView
            return cell;
        }
      }

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
     }
    
    
}

extension PubMusicController: PubMediaCellDelegate {
    func deleteItem(index: Int) {
        selectedAssetsImg.remove(at: index)
        mediaCell = tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! PubMediaCell
        mediaCell.selectedAssets = self.selectedAssetsImg
        mediaCell.canSetAddCell = self.canSetAddCellImg
        mediaCell.updateCollectionViewHeight()
    }
    
    func didSelected(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath,row:Int) {
        isImgFile = true
        configImg.maximumSelectedCount = 3
        configImg.selectOptions = PickerAssetOptions.photo
        presentPickerController()
    }
}
extension PubMusicController: PubMediaCellVodDelegate {
    func deleteItemVod(index: Int) {
        selectedAssetsVod.remove(at: index)
        mediaVodCell = tableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! PubMediaCellVod
        mediaVodCell.selectedAssets = self.selectedAssetsVod
        mediaVodCell.canSetAddCell = self.canSetAddCellVod
        mediaVodCell.updateCollectionViewHeight()
    }
    
    func didSelectedVod(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath,row:Int) {
        isImgFile = false
        configVod.maximumSelectedVideoCount = 1
        configVod.selectOptions = PickerAssetOptions.video
        presentPickerController()
    }
}
// MARK: PhotoPickerControllerDelegate
extension PubMusicController: PhotoPickerControllerDelegate {
    
    /// 选择完成之后调用
    func pickerController(_ pickerController: PhotoPickerController, didFinishSelection result: PickerResult) {
        DialogueUtils.showWithStatus("正在上传")
       
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
        
        let commpres =  PhotoAsset.Compression.init(imageCompressionQuality: 0.5, videoExportPreset: nil, videoQuality: 5)
 
        result.getURLs(options: .any, compression: commpres) { [self] urls in
            if self.isImgFile {
                //print(self.isImgFile)
                self.imageURLArr = urls
                uploadPhoto(filePath: self.imageURLArr)
            }else{
                //print(self.isImgFile)
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
            
            let isFull = selectedAssetsVod.count == configVod.maximumSelectedVideoCount
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
