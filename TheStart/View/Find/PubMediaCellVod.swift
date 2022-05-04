//
//  PubMediaCellVod.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/04.
//
 

import UIKit
import HXPHPicker


@objc protocol PubMediaCellVodDelegate: AnyObject {
    @objc func didSelectedVod(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath,row:Int)
    @objc func deleteItemVod(index: Int)
    
}


class PubMediaCellVod: UITableViewCell,UICollectionViewDataSource,
                          UICollectionViewDelegate,
                          UICollectionViewDragDelegate,
                          UICollectionViewDropDelegate,ResultViewCellDelegate{
    
    var row_Count: Int = UIDevice.current.userInterfaceIdiom == .pad ? 5 : 3
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imgLabel: UILabel!
    
    weak var delegate: PubMediaCellVodDelegate?
    /// 当前已选资源
    var selectedAssets: [PhotoAsset] = []

    weak var tableview:UITableView!
        
    var maximumSelectedCount: Int = 1
 
    var canSetAddCell: Bool = false
    /// 是否选中的原图
    var isOriginal: Bool = false
    
    var row = 0
 
    override func awakeFromNib() {
        super.awakeFromNib()
        imgLabel.font = UIFont.boldSystemFont(ofSize: 16)
        imgLabel.text = "上传视频资料(选填)"
        let flowLayout: UICollectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let itemWidth = Int((screenWidth - 46 - CGFloat(row_Count - 1) * 5)) / row_Count
        
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.minimumLineSpacing = 5
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 23)
        if #available(iOS 11.0, *) {
            collectionView.dragDelegate = self
            collectionView.dropDelegate = self
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.dragInteractionEnabled = true
        }
        collectionView.register(ResultViewCell.self, forCellWithReuseIdentifier: "ResultViewCellID")
        collectionView.register(ResultAddViewCell.self, forCellWithReuseIdentifier: "ResultAddViewCellID")
    }
    func getCollectionViewrowCount() -> Int {
        let assetCount = canSetAddCell ? selectedAssets.count + 1 : selectedAssets.count
        var rowCount = assetCount / row_Count + 1
        if assetCount % 3 == 0 {
            rowCount -= 1
        }
        return rowCount
    }

    func configCollectionViewHeight() {
        let rowCount = getCollectionViewrowCount()
        let itemWidth = Int((screenWidth - 46 - CGFloat(row_Count - 1) * 5)) / row_Count
        let heightConstraint = CGFloat(rowCount * itemWidth + rowCount)
        if heightConstraint > 110 {
            collectionViewHeightConstraint.constant = heightConstraint
        }else{
            collectionViewHeightConstraint.constant = 112
        }
    }
    
    func updateCollectionViewHeight() {

        configCollectionViewHeight()

        self.tableview.beginUpdates()
        self.tableview.endUpdates()
  

    }
 
    var addCell: ResultAddViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ResultAddViewCellID",
            for: IndexPath(item: selectedAssets.count, section: 0)
        ) as! ResultAddViewCell
        return cell
    }
    
    
    // MARK: ResultViewCellDelegate
    func cell(didDeleteButton cell: ResultViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let isFull = selectedAssets.count == maximumSelectedCount
            selectedAssets.remove(at: indexPath.item)
            delegate?.deleteItemVod(index:indexPath.item)
            if isFull {
                collectionView.reloadData()
            }else {
                collectionView.deleteItems(at: [indexPath])
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {

        return canSetAddCell ? selectedAssets.count + 1 : selectedAssets.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if canSetAddCell && indexPath.item == selectedAssets.count {
            return addCell
        }
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ResultViewCellID",
            for: indexPath
        ) as! ResultViewCell
        cell.resultDelegate = self
        cell.photoAsset = selectedAssets[indexPath.item]
        return cell
    }
 
    
    func previewDidDeleteAsset(index: Int) {
        let isFull = selectedAssets.count == maximumSelectedCount
        selectedAssets.remove(at: index)
        delegate?.deleteItemVod(index: index)
        if isFull {
            collectionView.reloadData()
        }else {
            collectionView.deleteItems(at: [IndexPath.init(item: index, section: 0)])
            collectionView.reloadData()
        }
        
    }
    
    // MARK: UICollectionViewDelegate
    /// 跳转单独预览界面
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if canSetAddCell && indexPath.item == selectedAssets.count {
            delegate?.didSelectedVod(collectionView: collectionView, didSelectItemAt: indexPath,row:self.row)
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
            // 转场过渡时起始/结束时 对应的 UIView
            print(index)
            return self.collectionView.cellForItem(
                at: IndexPath(
                    item: index,
                    section: 0
                )
            ) as? ResultViewCell
            
            
        } deleteAssetHandler: { index, photoAsset, photoBrowser in
            // 点击了删除按钮
            PhotoTools.showAlert(
                viewController: photoBrowser,
                title: "是否删除当前资源",
                leftActionTitle: "确定",
                leftHandler: { (alertAction) in
                    photoBrowser.deleteCurrentPreviewPhotoAsset()
                    //self.delegate!.previewDidDeleteAsset(index: index)
                    self.previewDidDeleteAsset(index: index)
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
    
    
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        if canSetAddCell && indexPath.item == selectedAssets.count {
            return false
        }
        return true
    }
    
    
    func collectionView(
        _ collectionView: UICollectionView,
        moveItemAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath) {
        let sourceAsset = selectedAssets[sourceIndexPath.item]
        selectedAssets.remove(at: sourceIndexPath.item)
        selectedAssets.insert(sourceAsset, at: destinationIndexPath.item)
    }
    
    @available(iOS 11.0, *)
    func collectionView(
        _ collectionView: UICollectionView,
        itemsForBeginning session: UIDragSession,
        at indexPath: IndexPath) -> [UIDragItem] {
        let itemProvider = NSItemProvider.init()
        let dragItem = UIDragItem.init(itemProvider: itemProvider)
        dragItem.localObject = indexPath
        return [dragItem]
    }
    
    
    @available(iOS 11.0, *)
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        if let sourceIndexPath = session.items.first?.localObject as? IndexPath {
            if canSetAddCell && sourceIndexPath.item == selectedAssets.count {
                return false
            }
        }
        return true
    }
    @available(iOS 11.0, *)
    func collectionView(
        _ collectionView: UICollectionView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath
            destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if let sourceIndexPath = session.items.first?.localObject as? IndexPath {
            if canSetAddCell && sourceIndexPath.item == selectedAssets.count {
                return UICollectionViewDropProposal.init(operation: .forbidden, intent: .insertAtDestinationIndexPath)
            }
        }
        if destinationIndexPath != nil && canSetAddCell && destinationIndexPath!.item == selectedAssets.count {
            return UICollectionViewDropProposal.init(operation: .forbidden, intent: .insertAtDestinationIndexPath)
        }
        var dropProposal: UICollectionViewDropProposal
        if session.localDragSession != nil {
            dropProposal = UICollectionViewDropProposal.init(operation: .move, intent: .insertAtDestinationIndexPath)
        }else {
            dropProposal = UICollectionViewDropProposal.init(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
        return dropProposal
    }
    
    @available(iOS 11.0, *)
    func collectionView(
        _ collectionView: UICollectionView,
        performDropWith coordinator: UICollectionViewDropCoordinator) {
        if let destinationIndexPath = coordinator.destinationIndexPath,
           let sourceIndexPath = coordinator.items.first?.sourceIndexPath {
            collectionView.isUserInteractionEnabled = false
            collectionView.performBatchUpdates {
                let sourceAsset = selectedAssets[sourceIndexPath.item]
                selectedAssets.remove(at: sourceIndexPath.item)
                selectedAssets.insert(sourceAsset, at: destinationIndexPath.item)
                collectionView.moveItem(at: sourceIndexPath, to: destinationIndexPath)
            } completion: { (isFinish) in
                collectionView.isUserInteractionEnabled = true
            }
            if let dragItem = coordinator.items.first?.dragItem {
                coordinator.drop(dragItem, toItemAt: destinationIndexPath)
            }
        }
    }
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
