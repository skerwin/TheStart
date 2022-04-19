//
//  MJRefresh+Extension.swift
 //
//  Created by zhaoyuanjing on 2017/09/29.
//  Copyright © 2017年 Berchina.Mobile. All rights reserved.
//

import Foundation


import MJRefresh

/// 下拉刷新头部封装
class GmmMJRefreshGifHeader: MJRefreshGifHeader {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let refreshingImages = getRefreshingImages()
        setImages([UIImage(named: "Loading_1.tiff")!], for: MJRefreshState.idle) // 设置普通状态的动画图片    1r
        setImages([UIImage(named: "Loading_1.tiff")!], for: MJRefreshState.idle) // 设置即将刷新状态的动画图片（一松开就会刷新的状态）  1r
        setImages(refreshingImages, for: MJRefreshState.refreshing) // 设置正在刷新状态的动画图片
        self.lastUpdatedTimeLabel?.isHidden = true
        self.stateLabel?.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        adjustGmmGifRefreshView(gifView: gifView!, stateLabel: stateLabel!, lastUpdatedTimeLabel: lastUpdatedTimeLabel)
    }
    
}

/// 上拉更多头部封装
class GmmMJRefreshAutoGifFooter: MJRefreshBackGifFooter {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //let refreshingImages = getRefreshingImages()
        //setImages([UIImage(named: "refresh1")!], for: MJRefreshState.idle) // 设置普通状态的动画图片   1r
        //setImages([UIImage(named: "refresh1")!], for: MJRefreshState.idle) // 设置即将刷新状态的动画图片（一松开就会刷新的状态）  1r
       // setImages(refreshingImages, for: MJRefreshState.refreshing) // 设置正在刷新状态的动画图片
        setTitle("正在载入...", for: MJRefreshState.refreshing)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        adjustGmmGifRefreshView(gifView: gifView!, stateLabel: stateLabel!, lastUpdatedTimeLabel: nil)
    }
    
}

/// 上拉更多(自动加载)头部封装
class GmmMJRefreshAutoLoadFooter: MJRefreshAutoGifFooter {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let refreshingImages = getRefreshingImages()
        setImages([UIImage(named: "refresh1")!], for: MJRefreshState.idle) // 设置普通状态的动画图片   1r
        setImages([UIImage(named: "refresh1")!], for: MJRefreshState.idle) // 设置即将刷新状态的动画图片（一松开就会刷新的状态）  1r
        setImages(refreshingImages, for: MJRefreshState.refreshing) // 设置正在刷新状态的动画图片
        setTitle("正在载入...", for: MJRefreshState.refreshing)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        adjustGmmGifRefreshView(gifView: gifView!, stateLabel: stateLabel!, lastUpdatedTimeLabel: nil)
    }
    
}

extension MJRefreshComponent {
    
    func adjustGmmGifRefreshView(gifView: UIView,stateLabel: UILabel,lastUpdatedTimeLabel: UILabel?) {
        let centerX = stateLabel.frame.origin.x + 0
        gifView.frame.origin.x = centerX
    }
    
    func getRefreshingImages() -> [UIImage] {
        var refreshingImages = [UIImage]()
        for i in 1 ... 8 {
            
            let image = UIImage(named: "Loading_" + "\(i)" + ".tiff")
            refreshingImages.append(image!)
//            let image = UIImage(named: "refresh1")
//            refreshingImages.append(image!)
        }
        return refreshingImages
    }
    
}
