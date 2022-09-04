//
//  StoreViewController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/08/14.
//

 
import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh


class StoreViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate,Requestable {
 
    var parentNavigationController: UINavigationController?
    var row_Count = 2
    
    var dataList = [StoreModel]()
    var pubBtn:UIButton!
    override func loadView() {
        super.loadView()
        self.edgesForExtendedLayout = []
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.limit = 20
        loadData()
        self.title = "商家"
        view.backgroundColor = ZYJColor.main
        view.addSubview(collectionView)
        let itemWidth = Int((view.hx.width - 24 - CGFloat(row_Count - 1) * 8)) / row_Count
        flowLayout.itemSize = CGSize(width: itemWidth, height: 171)
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.minimumLineSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 12, bottom: 20, right: 12)
        var collectionViewY = UIDevice.navigationBarHeight
        collectionViewY = UIDevice.navigationBarHeight + bottomNavigationHeight
        collectionView.frame = CGRect(
            x:0,
            y: 0,
            width: view.hx.width,
            height: view.hx.height - collectionViewY
        )
         // Do any additional setup after loading the view.
    }
    
    func loadData(){
            let requestParams = HomeAPI.shopListPathAndParams(page: page, limit: limit)
            postRequest(pathAndParams: requestParams,showHUD:false)
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

        let list:[StoreModel]  = getArrayFromJson(content: responseResult)

        dataList.append(contentsOf: list)
        if list.count < 10 {
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
        view.register(UINib(nibName:"StoreViewCell", bundle:nil),
                                      forCellWithReuseIdentifier: "StoreViewCell")
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
        return  dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreViewCell.nameOfClass, for: indexPath) as! StoreViewCell
        cell.model = dataList[indexPath.item]
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let controller = PhotoBrowserViewController()
            let controller = StoreDetailController()
            controller.dateID = dataList[indexPath.row].id
            self.navigationController?.pushViewController(controller, animated: true)
 
        
    }

    
}
