//
//  MuiscListController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/19.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh


class MuiscListController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate,Requestable {

    
    var parentNavigationController: UINavigationController?
    var row_Count = 3
    
    var dataList = [AudioModel]()
    var pubBtn:UIButton!
    
    var isFromMine = false
    var isMypub = false
    var isMyCollect = false
    
    var rightBarButton:UIButton!
    var isFreeZone = false
    
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //createRightNavItem()
        self.limit = 15
        loadData()
        if isFreeZone{
            self.title = "会员免费专区"
        }else{
            self.title = "音乐馆"
        }
        
        view.backgroundColor = ZYJColor.main
        view.addSubview(collectionView)
        let itemWidth = Int((view.hx.width - 24 - CGFloat(row_Count - 1) * 8)) / row_Count
        flowLayout.itemSize = CGSize(width: itemWidth, height: 165)
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.minimumLineSpacing = 3
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 12, bottom: 20, right: 12)
        
        var collectionViewY = UIDevice.navigationBarHeight
        var y:CGFloat = 10
        
        
        if isMypub {
            
        }else if isMyCollect{
            
        }else{
            if isFreeZone{
               y = navigationHeaderAndStatusbarHeight
               collectionViewY = UIDevice.navigationBarHeight
            }else{
                collectionViewY = UIDevice.navigationBarHeight + bottomNavigationHeight + 44
                y = 10
            }
        }
        
        collectionView.frame = CGRect(
            x: 0,
            y: y,
            width: view.hx.width,
            height: view.hx.height - collectionViewY
        )
        if isFreeZone{
            
        }else{
            if isMypub || isMyCollect{
                
            }else{
                createPubBtn()
            }
            
           
        }
        
        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        
        if isMypub {
            let pathAndParams = HomeAPI.myaudioListPathAndParams(page: page, limit: limit)
            getRequest(pathAndParams: pathAndParams,showHUD: false)
        }else if isMyCollect{
            let pathAndParams = HomeAPI.collectaudioListPathAndParams(page: page, limit: limit)
            getRequest(pathAndParams: pathAndParams,showHUD: false)
        }else{
            if isFreeZone{
                let requestParams = HomeAPI.audioListPathAndParams(page: page, limit: limit, vip_free: 1)
                getRequest(pathAndParams: requestParams,showHUD:false)
              
            }else{
                let requestParams = HomeAPI.audioListPathAndParams(page: page, limit: limit, vip_free: 0)
                getRequest(pathAndParams: requestParams,showHUD:false)
            }
           
        }
     

    }
    
    func createPubBtn() {
        
        pubBtn = UIButton.init()
        pubBtn.frame = CGRect.init(x: 0, y: 4, width: 60, height: 60)
        pubBtn.addTarget(self, action: #selector(pubBtnClick(_:)), for: .touchUpInside)
        pubBtn.setImage(UIImage.init(named: "tipOffPost"), for: .normal)
        
        let bgview = UIView.init()
        bgview.frame = CGRect.init(x: screenWidth - 100, y: screenHeight - 300, width: 60, height: 60)
        bgview.addSubview(pubBtn)
        
        self.view.addSubview(bgview)
        
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: bgview)
    }
    @objc func pubBtnClick(_ btn: UIButton){
    
        let controller = PubMusicController()
   
//        controller.articleType = 1
//        controller.reloadBlock = {[weak self] () -> Void in
//            self!.refreshList()
//        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        collectionView.mj_header?.endRefreshing()
        collectionView.mj_footer?.endRefreshing()
        self.collectionView.mj_footer?.endRefreshingWithNoMoreData()
    }

    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        collectionView.mj_header?.endRefreshing()
        collectionView.mj_footer?.endRefreshing()

        let list:[AudioModel]  = getArrayFromJson(content: responseResult)
        dataList.append(contentsOf: list)
        if list.count < 15 {
            self.collectionView.mj_footer?.endRefreshingWithNoMoreData()
        }
        self.collectionView.reloadData()
    }
    
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        return flowLayout
    }()
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        
        let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
        view.mj_header = addressHeadRefresh

        let footerRefresh = GmmMJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(pullRefreshList))
        view.mj_footer = footerRefresh
        
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        view.register(UINib(nibName:"MusicViewCell", bundle:nil),
                                      forCellWithReuseIdentifier: "MusicViewCell")
        return view
    }()
    

    @objc func pullRefreshList() {
        page = page + 1
        self.loadData()
    }
    
    
    @objc func refreshList() {
        self.collectionView.mj_footer?.resetNoMoreData()
        dataList.removeAll()
        page = 1
        self.loadData()
    }
    
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: dataList.count ,isdisplay: true)
        return dataList.count
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
        controller.isFromMine = self.isMypub
        self.navigationController?.pushViewController(controller, animated: true)
        
    }

    
}
