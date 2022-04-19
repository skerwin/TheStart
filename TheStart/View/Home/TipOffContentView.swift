//
//  TipOffContentView.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/15.
//

import UIKit

class TipOffContentView: UITableViewCell {

    @IBOutlet weak var contextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        contextLabel.text = "如果读者是初学者，那估计每个老司机都会告诉你，要熟悉2的指数。1、2、4、8、16、32、64、128。熟悉这几个数在网络基础入门会轻松很多。假设我们现在的A部门需要50个IP地址，对192.168.2.0/24进行子网划分，我下面介绍一下我的思路：在原来的网段中我们有256个IP地址，子网划分不管怎么分，都是对网段中的IP地址数量进行平均分配（不平均分配的VLSM我们在后面讲），有这样的概念我们就好办很多了。我们看下面这两个网段：192.168.1.0/24192.168.1.0/25 (这里我们划/25，网络位向主机位借了一位"
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
