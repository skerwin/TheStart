//
//  VipCenterViewController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/06.
//
 
import UIKit

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh


class VipCenterViewController: BaseViewController,Requestable {

    var row_Count = 3
    
    var parentNavigationController: UINavigationController?
    var dataList = [DictModel]()
    var dataVipList = [DictModel]()
    var pubBtn:UIButton!
    var bannerList = [ImageModel]()
    
    var myCoins = 0
    var flowLayout:UICollectionViewFlowLayout!
    
    
    var collectionView: UICollectionView!
    
    var usermodel = UserModel()
    
    var strsVip = ["免费下载会员音乐","无限次查看联系方式","无限次发起聊天","每天发布3条找人求职信息","发布信息可添加9张图片","发布信息可添加3条视频"]
    var imagesVip = ["huiyuan","vipnoti","vipmsg","vipsou","vipvod","vipvod"]
    
    
    var strs = ["充值下载会员音乐","每天限拨打3次找人电话","每天限沟通3人","每天限发布1条信息","发布信息限添加3张图片","发布信息限添加1条视频"]
    var images = ["vipnoti","vipnoti","vipmsg","vipsou","vipvod","vipvod"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
 
        loadLocalData()
 
        self.title = "会员中心"
        view.backgroundColor = ZYJColor.main
     
       
        flowLayout = UICollectionViewFlowLayout.init()
        
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionHeadersPinToVisibleBounds = false
        
  
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
        collectionView.register(UINib(nibName:"VipCenterHeader1", bundle:nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: VipCenterHeader1.nameOfClass)
        
        collectionView.register(UINib(nibName:"VipCenterHeader2", bundle:nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: VipCenterHeader2.nameOfClass)
        
        
        
        collectionView.register(UINib(nibName:"MyVipCenterCell", bundle:nil),
                                      forCellWithReuseIdentifier: "MyVipCenterCell")
        
        
        
        
        collectionView.frame = CGRect(
            x: 0,
            y: collectionViewY,
            width: view.hx.width,
            height: view.hx.height - collectionViewY
        )
        
        
        view.addSubview(collectionView)
        // Do any additional setup after loading the view.
    }
    
    
    func loadLocalData(){
        for index in 0..<strsVip.count {
            var dict = DictModel()
            dict?.title = strsVip[index]
            dict?.image = imagesVip[index]
            dataVipList.append(dict!)
        }
        
        for index in 0..<strs.count {
            var dict = DictModel()
            dict?.title = strs[index]
            dict?.image = images[index]
            dataList.append(dict!)
        }
    }
    
  
 
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        self.collectionView.mj_header?.endRefreshing()
        self.collectionView.mj_footer?.endRefreshing()
        
        self.collectionView.mj_footer?.endRefreshingWithNoMoreData()
    }

    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        self.collectionView.mj_header?.endRefreshing()
        self.collectionView.mj_footer?.endRefreshing()
 
        self.collectionView.reloadData()
 
    }
 
    
    @objc func refreshList() {
        self.collectionView.mj_footer?.resetNoMoreData()
        dataList.removeAll()
        page = 1
        delay(second: 1) { [self] in
            self.collectionView.mj_header?.endRefreshing()
            self.collectionView.mj_footer?.endRefreshing()
        }
        
    }
    
    
 }

extension VipCenterViewController:UICollectionViewDelegateFlowLayout{
    
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
        
        if section == 0{
            return CGSize.init(width: screenWidth , height: 243)
        }else{
            return CGSize.init(width: screenWidth , height: 35)
        }
        
    }
  
    //尾section的高度
//    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout:UICollectionViewLayout, referenceSizeForFooterInSection section:Int) -> CGSize {
//        return CGSize.init(width: screenWidth , height: 75)
//    }
    //整个itme区域上下左右的编剧
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 15, right: 12)
    }
}
 
extension VipCenterViewController:VipCenterHeader1Delegate {
    func sureOpenAction() {
//        let controller = UIStoryboard.getCashierDeskController()
//        controller.paytype = .chargeVip
//        controller.priceStr = "98.00"
//        self.present(controller, animated: true)
        //self.navigationController?.pushViewController(controller, animated: true)
    }
 }
extension VipCenterViewController:UICollectionViewDataSource,UICollectionViewDelegate {
    
    func numberOfSections(in collectionView:UICollectionView) ->Int{
        return 2
    }
    
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return dataList.count
        }else{
            return dataVipList.count
          
        }
    }
    
     func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{


        if kind == UICollectionView.elementKindSectionHeader {
            
            if  indexPath.section == 0{
                let filerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:VipCenterHeader1.nameOfClass, for: indexPath) as! VipCenterHeader1
                
                filerView.configModel(user: self.usermodel!)
                 filerView.delegate = self
     
                 return filerView
            }else{
                let filerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:VipCenterHeader2.nameOfClass, for: indexPath) as! VipCenterHeader2
                
                  return filerView
            }
          
        }else{
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyVipCenterCell.nameOfClass, for: indexPath) as! MyVipCenterCell
        
        let section = indexPath.section
        let itme = indexPath.item
        
        if section == 0{
            cell.title.text = dataList[itme].title
            cell.images.image = UIImage.init(named: dataVipList[itme].image)
        }else{
            cell.title.text = dataVipList[itme].title
            cell.images.image = UIImage.init(named: dataVipList[itme].image)
        }
        //cell.model = dataList[indexPath.item]
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
    }

    
}

