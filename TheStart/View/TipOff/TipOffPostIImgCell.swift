//
//  TipOffPostIImgCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/16.
//

import UIKit
import HXPHPicker


@objc protocol TipOffPostIImgCellDelegate: AnyObject {
    @objc func didSelected(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    @objc func deleteItem(indexPath: IndexPath)
}


class TipOffPostIImgCell: UITableViewCell,UICollectionViewDataSource,
                          UICollectionViewDelegate,
                          UICollectionViewDragDelegate,
                          UICollectionViewDropDelegate,ResultViewCellDelegate{
    
    var row_Count: Int = UIDevice.current.userInterfaceIdiom == .pad ? 5 : 3
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: TipOffPostIImgCellDelegate?
    
    /// 当前已选资源
    var selectedAssets: [PhotoAsset] = []

    weak var tableview:UITableView!
        
    var maximumSelectedCount: Int = 9
    
    var canSetAddCell: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        if heightConstraint > 135 {
            collectionViewHeightConstraint.constant = heightConstraint
        }else{
            collectionViewHeightConstraint.constant = 135
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
            delegate?.deleteItem(indexPath: indexPath)
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
 
    
    // MARK: UICollectionViewDelegate
    /// 跳转单独预览界面
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelected(collectionView: collectionView, didSelectItemAt: indexPath)
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
