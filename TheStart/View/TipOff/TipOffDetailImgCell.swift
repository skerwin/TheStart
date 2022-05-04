//
//  TipOffDetailImgCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/17.
//

import UIKit
import HXPHPicker


class TipOffDetailImgCell:UITableViewCell,UICollectionViewDataSource, UICollectionViewDelegate {

    var row_Count: Int = UIDevice.current.userInterfaceIdiom == .pad ? 5 : 3
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    /// 当前已选资源
    var previewAssets: [PhotoAsset] = []
    
    var imageUrl = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        let localImgAsset1 = PhotoAsset.init(localImageAsset: .init(image: UIImage.init(named: "testimg")!))
//        previewAssets.append(localImgAsset1)
 
        let flowLayout: UICollectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let itemWidth = Int((screenWidth - 40 - CGFloat(row_Count - 1) * 5)) / row_Count
        print(itemWidth)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.minimumLineSpacing = 5
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        if #available(iOS 11.0, *) {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.dragInteractionEnabled = true
        }
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.bounces = false
        self.collectionView?.showsHorizontalScrollIndicator = false
        collectionView.register(ResultViewCell.self, forCellWithReuseIdentifier: "PhotoBrowserViewCellId")
        configCollectionViewHeight()
        // Initialization code
    }
    var model:TipOffModel? {
        didSet {
            previewAssets.removeAll()
            for imageV in model!.image_input {
                let networkImageURL = URL.init(string: imageV)!
                let networkImageAsset = PhotoAsset.init(networkImageAsset: NetworkImageAsset.init(thumbnailURL: networkImageURL, originalURL: networkImageURL)) // swiftlint:disable:this line_length
                previewAssets.append(networkImageAsset)
            }
            collectionView.reloadData()
           
            configCollectionViewHeight()
         }
    }
    
    

    func configCollectionViewHeight() {
        var rowCount = 1
        var lineSpace = 0
        if previewAssets.count > 6{
            rowCount = 3
            lineSpace = 10
        }else if previewAssets.count > 3 {
            rowCount = 2
            lineSpace = 5
        }else{
            rowCount = 1
            lineSpace = 0
        }
        let itemWidth = Int((screenWidth - 40 - CGFloat(row_Count - 1) * 5)) / row_Count
        let heightConstraint = CGFloat(rowCount * itemWidth + lineSpace)
        if heightConstraint > 110 {
            collectionViewHeightConstraint.constant = heightConstraint
        }else{
            collectionViewHeightConstraint.constant = 112
        }
    }
 
    
    
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return previewAssets.count
    }
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "PhotoBrowserViewCellId",
            for: indexPath
        ) as! ResultViewCell
        cell.photoAsset = previewAssets[indexPath.item]
        cell.hideDelete()
        return cell
    }
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        let cell = collectionView.cellForItem(
            at: indexPath
        ) as? ResultViewCell
        
        PhotoBrowser.show(
            previewAssets,
            pageIndex: indexPath.item,
            transitionalImage: cell?.photoView.image
        ) {
            self.collectionView.cellForItem(
                at: IndexPath(
                    item: $0,
                    section: 0
                )
            )
        }
    }
    
    @available(iOS 13.0, *)
    public func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ResultViewCell else {
            return nil
        }
        let viewSize = CGSize(width: screenWidth, height: screenHeight)
        return .init(
            identifier: indexPath as NSCopying
        ) {
            let imageSize = cell.photoAsset.imageSize
            let aspectRatio = imageSize.width / imageSize.height
            let maxWidth = viewSize.width - UIDevice.leftMargin - UIDevice.rightMargin - 60
            let maxHeight = UIScreen.main.bounds.height * 0.659
            var width = imageSize.width
            var height = imageSize.height
            if width > maxWidth {
                width = maxWidth
                height = min(width / aspectRatio, maxHeight)
            }
            if height > maxHeight {
                height = maxHeight
                width = min(height * aspectRatio, maxWidth)
            }
            width = max(120, width)
            height = max(120, height)
            // 不下载，直接播放
            PhotoManager.shared.loadNetworkVideoMode = .play
            let vc = PhotoPeekViewController(cell.photoAsset)
            vc.preferredContentSize = CGSize(width: width, height: height)
            return vc
        }
    }
    
    @available(iOS 13.0, *)
    public func collectionView(
        _ collectionView: UICollectionView,
        willPerformPreviewActionForMenuWith
            configuration: UIContextMenuConfiguration,
        animator: UIContextMenuInteractionCommitAnimating
    ) {
        guard let indexPath = configuration.identifier as? IndexPath else {
            return
        }
        let cell = collectionView.cellForItem(
            at: indexPath
        ) as? ResultViewCell
        animator.addCompletion { [weak self] in
            guard let self = self else { return }
            PhotoBrowser.show(
                self.previewAssets,
                pageIndex: indexPath.item,
                transitionalImage: cell?.photoView.image
            ) { index in
                self.collectionView.cellForItem(
                    at: IndexPath(
                        item: index,
                        section: 0
                    )
                )
            }
        }
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
