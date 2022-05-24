//
//  AuthorDetailController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/09.
//
 

import UIKit

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh


class AuthorDetailController: BaseViewController,Requestable {

    var row_Count = 3
    
    var parentNavigationController: UINavigationController?
    var pubBtn:UIButton!
    var bannerList = [ImageModel]()
    
    var myCoins = 0
    var flowLayout:UICollectionViewFlowLayout!
    
    
    var collectionView: UICollectionView!
    
    var authorId = 0
    
    var dataList = [AudioModel]()
    
    var userModel = UserModel()
    
    var headView: AuthorDetailHeader!
    

    var rightBarButton:UIButton!
    
    var isCollect = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //loadData()
        self.title = "他/她的音乐"
        loadData()
        createRightNavItem()
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
        collectionView.register(UINib(nibName:"AuthorDetailHeader", bundle:nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AuthorDetailHeader.nameOfClass)
        
        collectionView.register(UINib(nibName:"MusicViewCell", bundle:nil),
                                      forCellWithReuseIdentifier: "MusicViewCell")
        
        collectionView.frame = CGRect(
            x: 0,
            y: collectionViewY,
            width: view.hx.width,
            height: view.hx.height - collectionViewY
        )
        
        
        view.addSubview(collectionView)
        // Do any additional setup after loading the view.
    }
    func createRightNavItem() {
        
        rightBarButton = UIButton.init()
        let bgview = UIView.init()
 
        rightBarButton.frame = CGRect.init(x: 0, y: 0, width: 28, height: 28)
        bgview.frame = CGRect.init(x: 0, y: 0, width: 28, height: 28)
        
        rightBarButton.addTarget(self, action: #selector(rightNavBtnClic(_:)), for: .touchUpInside)
        
        rightBarButton.setBackgroundImage(UIImage.init(named: "shoucangs"), for: .normal)
     
        bgview.addSubview(rightBarButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: bgview)
        
    }

    @objc func rightNavBtnClic(_ btn: UIButton){
        
        let requestParams = HomeAPI.authorCollectionPathAndParams(musician_id: authorId)
        postRequest(pathAndParams: requestParams,showHUD:false)
        
     }
  
    
    
    func loadData(){
        let requestParams = HomeAPI.authorDetailPathAndParams(id: authorId)
        postRequest(pathAndParams: requestParams,showHUD:false)
    }

    override func onFailure(responseCode: String, description: String, requestPath: String) {
        DialogueUtils.dismiss()
        DialogueUtils.showError(withStatus: description)
        
        collectionView.mj_header?.endRefreshing()
        self.collectionView.mj_footer?.endRefreshingWithNoMoreData()
    }
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        if requestPath == HomeAPI.authorCollectionPath{
            isCollect = responseResult["if_collection"].intValue
            if isCollect == 1{
                rightBarButton.setBackgroundImage(UIImage.init(named: "shoucangzhong"), for: .normal)
                showOnlyTextHUD(text: "收藏成功")
            }else{
                rightBarButton.setBackgroundImage(UIImage.init(named: "shoucangs"), for: .normal)
                showOnlyTextHUD(text: "取消收藏")
            }
        }else{
            collectionView.mj_header?.endRefreshing()
            userModel = Mapper<UserModel>().map(JSONObject: responseResult.rawValue)
            dataList = getArrayFromJsonByArrayName(arrayName: "audio_list", content: responseResult)
            headView.configModel(model: userModel!)
            self.collectionView.reloadData()
        }
        
       

 
    }
 
    
    @objc func refreshList() {
        self.collectionView.mj_footer?.resetNoMoreData()
        dataList.removeAll()
        page = 1
        self.loadData()
    }
    
    
 }


extension AuthorDetailController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let itemWidth = Int((view.hx.width - 24 - CGFloat(row_Count - 1) * 8)) / row_Count
        return CGSize(width: itemWidth, height: 165)
    }
    
    //itme间的上下距离
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    //itme间的左右距离
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 8
    }
    //头section的高度
    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout:UICollectionViewLayout, referenceSizeForHeaderInSection section:Int) -> CGSize {
        return CGSize.init(width: screenWidth , height: 127)
    }
 
    //整个itme区域上下左右的编剧
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 12, bottom: 20, right: 12)
    }
}
extension AuthorDetailController:UICollectionViewDataSource,UICollectionViewDelegate {
    
    func numberOfSections(in collectionView:UICollectionView) ->Int{
        return 1
    }
    
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
     func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{


        if kind == UICollectionView.elementKindSectionHeader {
            headView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:AuthorDetailHeader.nameOfClass, for: indexPath) as! AuthorDetailHeader
 
            return headView
        }else{
       
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicViewCell.nameOfClass, for: indexPath) as! MusicViewCell
        cell.model = dataList[indexPath.item]
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = MusicDetailController()
        controller.dateID = dataList[indexPath.item].id
        self.navigationController?.pushViewController(controller, animated: true)
    }

    
}
