//
//  MyStarCoinController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/06.
//

import UIKit

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh


class MyStarCoinController: BaseViewController,Requestable {

    var row_Count = 3
    
    var parentNavigationController: UINavigationController?
    var dataList = [DictModel]()
    var pubBtn:UIButton!
    var bannerList = [ImageModel]()
    
    var myCoins = 0
    var flowLayout:UICollectionViewFlowLayout!
    
    var rowNum = -1
    
    
    var collectionView: UICollectionView!
    
    var usermodel = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadData()
        self.title = "我的星币"
        view.backgroundColor = ZYJColor.main
     
       
        flowLayout = UICollectionViewFlowLayout.init()
        
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionHeadersPinToVisibleBounds = true
        
  
        let collectionViewY = UIDevice.navigationBarHeight
        
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
        collectionView.mj_header = addressHeadRefresh
 
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        collectionView.register(UINib(nibName:"MineStarCoinHeder", bundle:nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MineStarCoinHeder.nameOfClass)
        
        collectionView.register(UINib(nibName:"MyStarCoinFootView", bundle:nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MyStarCoinFootView.nameOfClass)
        
        
        collectionView.register(UINib(nibName:"MyStarCollectionViewCell", bundle:nil),
                                      forCellWithReuseIdentifier: "MyStarCollectionViewCell")
        
        
        
        collectionView.frame = CGRect(
            x: 0,
            y: collectionViewY,
            width: view.hx.width,
            height: view.hx.height - collectionViewY
        )
        
        
        view.addSubview(collectionView)
        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        let requestParams = HomeAPI.MyCoinListPathAndParams()
        getRequest(pathAndParams: requestParams,showHUD:false)

    }
 
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        collectionView.mj_header?.endRefreshing()
        
        self.collectionView.mj_footer?.endRefreshingWithNoMoreData()
    }

    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        collectionView.mj_header?.endRefreshing()
 
        myCoins = responseResult["coins"].intValue
        
        dataList = getArrayFromJsonByArrayName(arrayName: "recharge_quota", content: responseResult)
        bannerList = getArrayFromJsonByArrayName(arrayName: "banner", content: responseResult)
        
        self.collectionView.reloadData()

 
    }
 
    
    @objc func refreshList() {
        self.collectionView.mj_footer?.resetNoMoreData()
        dataList.removeAll()
        page = 1
        self.loadData()
    }
    
    
 }

extension MyStarCoinController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let itemWidth = Int((view.hx.width - 24 - CGFloat(row_Count - 1) * 10)) / row_Count
        return CGSize(width: itemWidth, height: 110)
    }
    
    //itme间的上下距离
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    //itme间的左右距离
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    //头section的高度
    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout:UICollectionViewLayout, referenceSizeForHeaderInSection section:Int) -> CGSize {
        return CGSize.init(width: screenWidth , height: 258)
    }
  
    //尾section的高度
    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout:UICollectionViewLayout, referenceSizeForFooterInSection section:Int) -> CGSize {
        return CGSize.init(width: screenWidth , height: 80)
    }
    //整个itme区域上下左右的编剧
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 12, bottom: 20, right: 12)
    }
}
extension MyStarCoinController:MineStarCoinHederDelegate {
    func cashDone() {
      
        let controller = ChargeOrderController()
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
  
    
    
}

extension MyStarCoinController:MyStarCoinFootViewDelegate{

    
    func buyAction() {
        if rowNum == -1{
            showOnlyTextHUD(text: "请选择要充值的星币")
            return
        }
//        let priceStr = self.dataList[rowNum].price
//        let controller = UIStoryboard.getCashierDeskController()
//        controller.paytype = .ChargeStarCoin
//        controller.priceStr = priceStr
//        self.present(controller, animated: true)
    }
    
    
}
extension MyStarCoinController:UICollectionViewDataSource,UICollectionViewDelegate {
    
    func numberOfSections(in collectionView:UICollectionView) ->Int{
        return 1
    }
    
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
     func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{


        if kind == UICollectionView.elementKindSectionHeader {
            let filerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:MineStarCoinHeder.nameOfClass, for: indexPath) as! MineStarCoinHeder
            
             filerView.delegate = self
             filerView.titleLabel.text = usermodel!.coins
            
             return filerView
        }else{
       
            let filerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:MyStarCoinFootView.nameOfClass, for: indexPath) as! MyStarCoinFootView
            
             filerView.delegate = self
            return filerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyStarCollectionViewCell.nameOfClass, for: indexPath) as! MyStarCollectionViewCell
        cell.model = dataList[indexPath.item]
        if indexPath.item == rowNum{
            cell.BgView.layer.borderColor = ZYJColor.coinColor.cgColor
            cell.BgView.layer.borderWidth = 1
        }else{
            //BgView.layer.borderColor = ZYJColor.coinColor.cgColor
            cell.BgView.layer.borderWidth = 0
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        rowNum = indexPath.item
     
        collectionView.reloadData()
        
        
    }

    
}
