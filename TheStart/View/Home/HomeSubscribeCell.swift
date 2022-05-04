//
//  HomeSubscribeCell.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/01/15.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit



protocol HomeSubscribeCellDelegate: NSObjectProtocol {
    func HomeCareBtnAction(num:Int)
}

class HomeSubscribeCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    
    //var recommendList = [SubscribeModel]()
    var collectionView:UICollectionView!  //collectView
    
    var parentNavigationController: UINavigationController?
 
    weak var delegate: HomeSubscribeCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        //Initialization code
        bgView.layer.cornerRadius = 10;
        bgView.layer.masksToBounds = true
        initCollectView()
    
        initCollectView()
     }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     }
    
    func refreshList (){
        collectionView.reloadData()
    }
 
    func initCollectView(){
        
        
        let collectionViewFrame = CGRect.init(x: 0, y:0, width: screenWidth, height: 102)
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        self.collectionView = UICollectionView.init(frame: collectionViewFrame, collectionViewLayout: layout)
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
        self.collectionView?.backgroundColor = ZYJColor.main
        //self.collectionView?.allowsMultipleSelection = true
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0 )
        self.collectionView!.register(UINib(nibName:"SuperManCell", bundle:nil),
                                                   forCellWithReuseIdentifier: "SuperManCell")
       // self.collectionView?.backgroundColor = UIColor.yellow
       // self.collectionView?.layer.cornerRadius = 10;
        //self.collectionView?.layer.masksToBounds = true
        
        self.bgView.addSubview(self.collectionView)
      
  }
    
}
extension HomeSubscribeCell:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize.init(width:(screenWidth - 10)/2 , height:102)
        return size
    }
    
    //itme间的上下距离
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //itme间的左右距离
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    //整个itme区域上下左右的编剧
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
    }
    
}
extension HomeSubscribeCell:SuperManCellDelegate {
    func careBtnAction(num: Int) {
        delegate?.HomeCareBtnAction(num: num)
    }
    
    
}
extension HomeSubscribeCell:UICollectionViewDataSource,UICollectionViewDelegate {
    
    func numberOfSections(in collectionView:UICollectionView) ->Int{
        //return  .dataSources.count
        return 1
    }
    
    func collectionView(_ collectionView:UICollectionView, numberOfItemsInSection section:Int) -> Int {
        return 10
        //recommendList.count
         
    }
    
    func collectionView(_ collectionView:UICollectionView, cellForItemAt indexPath:IndexPath) -> UICollectionViewCell {
 
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuperManCell.nameOfClass, for: indexPath) as! SuperManCell
        cell.delegate = self
        //cell.model = recommendList[indexPath.row]
        return cell
        
     }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        let controller = ColumForDetailController()
//        controller.columForModel = recommendList[indexPath.row]
//        self.parentNavigationController?.pushViewController(controller, animated: true)
        
//        let vc = ChannelViewController()
//        vc.menupagetype = MenuPageType.ColumForDetail
//        vc.cid = ColumnForModelList[indexPath.row].id
//        vc.columForModel = ColumnForModelList[indexPath.row]
//        self.navigationController?.pushViewController(vc, animated: true)
    }

}
 
