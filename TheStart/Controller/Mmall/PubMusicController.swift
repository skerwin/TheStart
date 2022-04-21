
//
//  WorkerPubViewController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/18.
//

import UIKit
import IQKeyboardManager
import HXPHPicker

class PubMusicController: BaseViewController {

    
    
    var tableView:UITableView!
 
    weak var collectionView: UICollectionView!
    /// 当前已选资源
    var selectedAssets: [PhotoAsset] = []
    /// 是否选中的原图
    var isOriginal: Bool = false
    /// 相机拍摄的本地资源
    var localCameraAssetArray: [PhotoAsset] = []
    var localAssetArray: [PhotoAsset] = []
    var mediaCell:PubMediaCell = PubMediaCell.init()
    
    var headView:PubMusicHeader!
    var headerBgView:UIView!
    var footerView:ChatBtnView!
    var footerBgView:UIView!
    
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
        initHeadView()
        self.view.backgroundColor = ZYJColor.main
        initFooterView()
        initTableView()
        self.title = "发布找场"
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
    
    func initHeadView(){
        headView = Bundle.main.loadNibNamed("PubMusicHeader", owner: nil, options: nil)!.first as? PubMusicHeader
        headView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 235)
        
        headerBgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 235))
        headerBgView.backgroundColor = UIColor.clear
        headerBgView.addSubview(headView)
        
      }
    
    
    func initFooterView(){
        footerView = Bundle.main.loadNibNamed("ChatBtnView", owner: nil, options: nil)!.first as? ChatBtnView
        footerView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 85)
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
        tableView.registerNibWithTableViewCellName(name: WokerPubIntroCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: WorkerVideoCell.nameOfClass)
        
        self.tableView.tableHeaderView = headerBgView
        tableView.tableFooterView = footerBgView
//        let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
//        tableView.mj_header = addressHeadRefresh
//         let footerRefresh = GmmMJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(pullRefreshList))
//        tableView.mj_footer = footerRefresh
        
        view.addSubview(tableView)
        
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
            cell.selectionStyle = .none
            cell.tableview = tableView;
            return cell;
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PubMediaCell", for: indexPath) as! PubMediaCell
            cell.delegate = self
            cell.selectionStyle = .none
            cell.selectedAssets = self.selectedAssets
            cell.canSetAddCell = self.canSetAddCell
            cell.maximumSelectedCount = config.maximumSelectedCount
            cell.tableview = tableView;
            self.collectionView = cell.collectionView
            return cell;
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PubMediaCell", for: indexPath) as! PubMediaCell
            cell.delegate = self
            cell.selectionStyle = .none
            cell.selectedAssets = self.selectedAssets
            cell.canSetAddCell = self.canSetAddCell
            cell.maximumSelectedCount = config.maximumSelectedCount
            cell.tableview = tableView;
            self.collectionView = cell.collectionView
            return cell;
        }
      
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let controller = TipOffDetailViewController()
      
         self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension PubMusicController: PubMediaCellDelegate {
    func deleteItem(index: Int) {
        selectedAssets.remove(at: index)
        mediaCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! PubMediaCell
        mediaCell.selectedAssets = self.selectedAssets
        mediaCell.canSetAddCell = self.canSetAddCell
        mediaCell.updateCollectionViewHeight()
    }
    
    func didSelected(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentPickerController()
    }
}
// MARK: PhotoPickerControllerDelegate
extension PubMusicController: PhotoPickerControllerDelegate {
    
    /// 选择完成之后调用
    func pickerController(_ pickerController: PhotoPickerController, didFinishSelection result: PickerResult) {
        selectedAssets = result.photoAssets
        isOriginal = result.isOriginal
        mediaCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! PubMediaCell
        mediaCell.selectedAssets = self.selectedAssets
        mediaCell.canSetAddCell = self.canSetAddCell
        mediaCell.updateCollectionViewHeight()
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
        
        mediaCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! PubMediaCell
        mediaCell.selectedAssets = self.selectedAssets
        mediaCell.canSetAddCell = self.canSetAddCell
        
        if isFull {
            collectionView.reloadData()
        }else {
            collectionView.deleteItems(at: [IndexPath.init(item: index, section: 0)])
            mediaCell.updateCollectionViewHeight()
            collectionView.reloadData()
        }
        
    }
    
    /// present 预览时起始的视图，用于获取位置大小。与 presentPreviewFrameForIndexAt 一样
    func pickerController(
        _ pickerController: PhotoPickerController,
        presentPreviewViewForIndexAt index: Int) -> UIView? {
            let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! PubMediaCell
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
            let cell = tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! PubMediaCell
            return cell
        }
    
}


