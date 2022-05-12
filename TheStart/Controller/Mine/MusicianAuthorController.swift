//
//  MusicianAuthorController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/09.
//

 
import UIKit
import IQKeyboardManager
import HXPHPicker
import SwiftyJSON
import ObjectMapper

class MusicianAuthorController: BaseViewController,Requestable,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    
    
    var headView:MusicAuthorHeader!
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
        self.title = "音乐人认证"
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
        headView = Bundle.main.loadNibNamed("MusicAuthorHeader", owner: nil, options: nil)!.first as? MusicAuthorHeader
        headView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 161)
        
        headerBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 161))
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
        DialogueUtils.showError(withStatus: "发布失败，请重试")
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        DialogueUtils.dismiss()
        DialogueUtils.showSuccess(withStatus: "发布成功")
        delay(second: 1) { [self] in
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
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        
        tableView.registerNibWithTableViewCellName(name: PubMediaCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: PubMediaCellVod.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: SelfIntroCell.nameOfClass)
        
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
    
    
    func imagePickerController(_ picker:UIImagePickerController,didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey:Any]){
//        let publicImageType = "public.image"
//        if let typeInfo = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.mediaType.rawValue)] as? String {
//            if typeInfo == publicImageType {
//                if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.editedImage.rawValue)] as? UIImage {
//                    var data: NSData?
//                    if image.pngData() == nil {
//                        data = image.jpegData(compressionQuality: 0.8) as NSData?
//                    } else {
//                        data = image.pngData() as NSData?
//                    }
//                    if data != nil {//上传头像到服务器
//                        let home = NSHomeDirectory() as NSString
//                        let docPath = home.appendingPathComponent("Documents") as NSString;
//                        let imageName = DateUtils.getStampString() + ".png"
//                        imagePath = docPath.appendingPathComponent(imageName);
//                        data?.write(toFile: imagePath, atomically: true)
//                        headImage.image = image
//                        //uploadPhoto(filePath: imagePath)
//                    }
//                }
//            }
//        }
//        pickerController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker .dismiss(animated: true, completion: nil)
    }
 
}
 
extension MusicianAuthorController:ChatBtnViewDelegate {
    func sumbitAction() {

//        audioModel?.name = headView.nameTV.text!
//        if audioModel!.name.isEmptyStr(){
//            showOnlyTextHUD(text: "请输入名称")
//            return
//        }
//        audioModel?.price = headView.MoneyTF.text!
//        if audioModel!.price.isEmptyStr(){
//            showOnlyTextHUD(text: "请输入价格")
//            return
//        }
//
//        audioModel?.link = headView.wanpanTV.text!
//        if audioModel!.link.isEmptyStr(){
//            showOnlyTextHUD(text: "请输入网盘链接")
//            return
//        }
//
//        audioModel?.code = headView.wangpanCode.text!
//        if audioModel!.code.isEmptyStr(){
//            showOnlyTextHUD(text: "请输入提取码")
//            return
//        }
//
//
//
//        introCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WokerPubIntroCell
//        audioModel?.info = introCell.contentTV.text
//        if audioModel!.info.isEmptyStr(){
//            showOnlyTextHUD(text: "请简要介绍音乐")
//            return
//        }
//
//        var imgstr = ""
//        if uploadImgArr.count != 0{
//            for imgM in self.uploadImgArr {
//                imgstr = imgstr + imgM.url + ","
//            }
//            imgstr.remove(at: imgstr.index(before: imgstr.endIndex))
//
//            audioModel?.image = self.uploadImgArr.first!.url
//
//        }
//        audioModel?.imagesUrl = imgstr
//
//
//        var vodstr = ""
//        if uploadVodArr.count != 0{
//            for vodM in self.uploadVodArr {
//                vodstr = vodstr + vodM.url + ","
//            }
//            vodstr.remove(at: vodstr.index(before: vodstr.endIndex))
//        }
//
//        audioModel?.audio_path = vodstr
// //
//        let pathAndParams = HomeAPI.audioPubPathAndParams(model: audioModel!)
//        postRequest(pathAndParams: pathAndParams,showHUD: false)
//

        
    }
    
    
}
extension MusicianAuthorController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: notifyModelList.count ,isdisplay: true)

        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = Bundle.main.loadNibNamed("MusicAuthorVideoHeader", owner: nil, options: nil)!.first as! MusicAuthorVideoHeader
        sectionView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 44)
        
        if section == 0{
            sectionView.titleLabel.text = "自我介绍(工作经历，职业经历等)"
        } else if  section == 1{
            sectionView.titleLabel.text = "才艺展示(清唱，才艺，舞蹈等视频)"
        }
        
        
        else{
            sectionView.titleLabel.text = "更多补充资料(限5张图片)"
        }
        return sectionView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1{
            return 50
        }else{
            return 0
        }
       
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        
        if section == 1{
            let sectionView = Bundle.main.loadNibNamed("MusicAuthorVideoFooter", owner: nil, options: nil)!.first as! MusicAuthorVideoFooter
            sectionView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 50)
            return sectionView
        }else{
            return UIView()
        }
       
         
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelfIntroCell", for: indexPath) as! SelfIntroCell
            cell.selectionStyle = .none
            cell.tableview = tableView;
            return cell;
        }else if indexPath.section == 1{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PubMediaCellVod", for: indexPath) as! PubMediaCellVod
            cell.row = 2
            cell.delegate = self
            cell.configSelfIntro()
            cell.selectionStyle = .none
            cell.selectedAssets = self.selectedAssetsVod
            cell.canSetAddCell = self.canSetAddCellVod
            cell.maximumSelectedCount = configVod.maximumSelectedCount
            cell.tableview = tableView;
            self.collectionViewVod = cell.collectionView
            return cell;
            
        
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PubMediaCell", for: indexPath) as! PubMediaCell
            cell.row = 1
            cell.initUI(type: 1)
            cell.configSelfIntro()
            cell.delegate = self
            cell.selectionStyle = .none
            cell.selectedAssets = self.selectedAssetsImg
            cell.canSetAddCell = self.canSetAddCellImg
            cell.maximumSelectedCount = configImg.maximumSelectedCount
            cell.tableview = tableView;
            self.collectionViewImg = cell.collectionView
            return cell;
        }
      }
    
    

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
     }
    
    
}

extension MusicianAuthorController: PubMediaCellDelegate {
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
extension MusicianAuthorController: PubMediaCellVodDelegate {
    func deleteItemVod(index: Int) {
        selectedAssetsVod.remove(at: index)
        mediaVodCell = tableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! PubMediaCellVod
        mediaVodCell.selectedAssets = self.selectedAssetsVod
        mediaVodCell.canSetAddCell = self.canSetAddCellVod
        mediaVodCell.updateCollectionViewHeight()
    }
    
    func didSelectedVod(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath,row:Int) {
        isImgFile = false
        configVod.maximumSelectedCount = 1
        configVod.selectOptions = PickerAssetOptions.video
        presentPickerController()
    }
}
// MARK: PhotoPickerControllerDelegate
extension MusicianAuthorController: PhotoPickerControllerDelegate {
    
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
        result.getURLs { [self] urls in
            if self.isImgFile {
                print(self.isImgFile)
                self.imageURLArr = urls
                uploadPhoto(filePath: self.imageURLArr)
            }else{
                print(self.isImgFile)
                self.vodURLArr = urls
                uploadPhoto(filePath: self.vodURLArr)
            }
            
            print(urls)
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
