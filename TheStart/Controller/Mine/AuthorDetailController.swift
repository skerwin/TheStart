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
 
    var flowLayout:UICollectionViewFlowLayout!
    
    
    var collectionView: UICollectionView!
    
    
    
    var dataList = [AudioModel]()
    
    var userModel = UserModel()
 
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "他/她的音乐"
 
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
                
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
 
        collectionView.register(UINib(nibName:"MusicViewCell", bundle:nil),
                                      forCellWithReuseIdentifier: "MusicViewCell")
        
        collectionView.frame = CGRect(
            x: 0,
            y: 0,
            width: view.hx.width,
            height: view.hx.height - collectionViewY - 188 - 44
        )
        
        
        view.addSubview(collectionView)
        // Do any additional setup after loading the view.
    }
 
//    func loadData(){
//        let requestParams = HomeAPI.authorDetailPathAndParams(id: 338)
//        postRequest(pathAndParams: requestParams,showHUD:false)
//    }
//
//    override func onFailure(responseCode: String, description: String, requestPath: String) {
//        DialogueUtils.dismiss()
//        DialogueUtils.showError(withStatus: description)
//
//        collectionView.mj_header?.endRefreshing()
//        self.collectionView.mj_footer?.endRefreshingWithNoMoreData()
//    }
//    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
//        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
//             collectionView.mj_header?.endRefreshing()
//            userModel = Mapper<UserModel>().map(JSONObject: responseResult.rawValue)
//            dataList = getArrayFromJsonByArrayName(arrayName: "audio_list", content: responseResult)
//            if userModel?.music_num == 0{
//                userModel?.music_num = dataList.count
//            }
//           // headView.configModel(model: userModel!)
//            self.collectionView.reloadData()
//     }
//
    
//    @objc func refreshList() {
//        self.collectionView.mj_footer?.resetNoMoreData()
//        dataList.removeAll()
//        page = 1
//        self.loadData()
//    }
//
    
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
//    //头section的高度
//    func collectionView(_ collectionView:UICollectionView, layout collectionViewLayout:UICollectionViewLayout, referenceSizeForHeaderInSection section:Int) -> CGSize {
//        return CGSize.init(width: screenWidth , height: 127)
//    }
 
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
    
//     func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
//
//
//        if kind == UICollectionView.elementKindSectionHeader {
//            headView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:AuthorDetailHeader.nameOfClass, for: indexPath) as! AuthorDetailHeader
//
//            return headView
//        }else{
//
//            return UICollectionReusableView()
//        }
//    }
    
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
