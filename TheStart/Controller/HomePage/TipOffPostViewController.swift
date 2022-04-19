//
//  TipOffPostViewController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/16.
//

import UIKit
import IQKeyboardManager
import HXPHPicker

class TipOffPostViewController: BaseViewController {
    
    var contentTV:UITextView!

    var tableView:UITableView!
    
    weak var collectionView: UICollectionView!
    /// 当前已选资源
    var selectedAssets: [PhotoAsset] = []
    /// 是否选中的原图
    var isOriginal: Bool = false

    
    var localAssetArray: [PhotoAsset] = []
    
    var imageCell:TipOffPostIImgCell = TipOffPostIImgCell.init()
    
    /// 相机拍摄的本地资源
    var localCameraAssetArray: [PhotoAsset] = []
    /// 相关配置
    var config: PickerConfiguration = PhotoTools.getWXPickerConfig(isMoment: true)
    
    
    var canSetAddCell: Bool {
        if selectedAssets.count == config.maximumSelectedCount &&
            config.maximumSelectedCount > 0 {
            return false
        }
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "报黑信息"
        initTableView()
        // Do any additional setup after loading the view.
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
        tableView.registerNibWithTableViewCellName(name: TipOffpootContentCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: TipOffPostIImgCell.nameOfClass)
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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
            return cell;
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TipOffPostIImgCell", for: indexPath) as! TipOffPostIImgCell
            cell.selectionStyle = .none
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
        selectedAssets = result.photoAssets
        isOriginal = result.isOriginal
        imageCell = tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! TipOffPostIImgCell
        imageCell.selectedAssets = self.selectedAssets
        imageCell.canSetAddCell = self.canSetAddCell
        imageCell.updateCollectionViewHeight()
        collectionView.reloadData()
        
        
        pickerController.dismiss(animated: true, completion: nil)
        result.getURLs { urls in
            print(urls)
        }
        
        result.getImage { (image, photoAsset, index) in
            if let image = image {
                print("success", image)
            }else {
                print("failed")
            }
        } completionHandler: { (images) in
            print(images)
        }
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


