//
//  testCell.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/16.
//

import UIKit

class testCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
//let networkVideoURL = URL.init(string: "http://tsnrhapp.oss-cn-hangzhou.aliyuncs.com/chartle/IMG_3385.MP4")!
//let networkVideoAsset = PhotoAsset.init(networkVideoAsset: .init(videoURL: networkVideoURL))
//previewAssets.append(networkVideoAsset)
//
//let networkVideoURL1 = URL.init(string: "http://tsnrhapp.oss-cn-hangzhou.aliyuncs.com/picker_examle_video.mp4")!
//let networkVideoAsset1 = PhotoAsset.init(networkVideoAsset: .init(videoURL: networkVideoURL1))
//previewAssets.append(networkVideoAsset1)
//
//#if canImport(Kingfisher)
//let networkImageURL = URL.init(string: "https://wx4.sinaimg.cn/large/a6a681ebgy1gojng2qw07g208c093qv6.gif")!
//let networkImageAsset = PhotoAsset.init(networkImageAsset: NetworkImageAsset.init(thumbnailURL: networkImageURL, originalURL: networkImageURL)) // swiftlint:disable:this line_length
//previewAssets.append(networkImageAsset)
