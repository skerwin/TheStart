//
//  MuiscListController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/19.
//

import UIKit

class MuiscListController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    
    var row_Count = 3
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "音乐馆"
        view.backgroundColor = ZYJColor.main
        view.addSubview(collectionView)
        let itemWidth = Int((view.hx.width - 24 - CGFloat(row_Count - 1) * 8)) / row_Count
        flowLayout.itemSize = CGSize(width: itemWidth, height: 165)
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.minimumLineSpacing = 3
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 12, bottom: 20, right: 12)
        let collectionViewY = UIDevice.navigationBarHeight
        collectionView.frame = CGRect(
            x: 0,
            y: collectionViewY,
            width: view.hx.width,
            height: view.hx.height - collectionViewY
        )
        // Do any additional setup after loading the view.
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
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        view.register(UINib(nibName:"MusicViewCell", bundle:nil),
                                      forCellWithReuseIdentifier: "MusicViewCell")
        return view
    }()
    
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicViewCell.nameOfClass, for: indexPath) as! MusicViewCell
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
    }

    
}
