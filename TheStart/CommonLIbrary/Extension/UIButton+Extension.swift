//
//  UIButton+Extension.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/18.
//

import Foundation
import UIKit
import Kingfisher



// MARK: - 对应UIImageView的异步显示网络图片
extension UIButton {
    func displayButtonHeadImageWithURL(url: String?,isOpenScale: Bool = true) {
        contentMode = .scaleToFill
        if url == nil || url! == ""{
            
            self.setBackgroundImage(UIImage.init(named: "headNotify"), for: .normal)
            //self.setImage(#imageLiteral(resourceName: "headNotify"), for: .normal)
        }else{
            var PinUrl = url!
            if PinUrl.containsStr(find: "http"){
            }else{
                PinUrl = URLs.getHostAddress() + PinUrl
            }
            guard let imageUrl = URL.init(string:PinUrl.urlEncoded()) else { return }
            let resource = ImageResource.init(downloadURL: imageUrl)
            self.kf.setImage(with: resource, for: .normal, placeholder: UIImage.init(named: "headNotify"), options: [KingfisherOptionsInfoItem.targetCache(ImageCacheManager.default)], progressBlock: nil, completionHandler: nil)
        }
    }
}

 
