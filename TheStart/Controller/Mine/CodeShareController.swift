//
//  CodeShareController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2021/02/08.
//  Copyright © 2021 gansukanglin. All rights reserved.
//

import UIKit

class CodeShareController: BaseViewController {

    @IBOutlet weak var shareCodeBtn: UIButton!
    @IBAction func shareCodeAction(_ sender: Any) {
        self.shareView.show(withContentType: JSHAREMediaType(rawValue: 3)!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        shareCodeBtn.layer.cornerRadius = 22
        shareCodeBtn.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }
    
    lazy var shareView: ShareView = {
        let sv = ShareView.getFactoryShareView { (platform, type) in
            self.shareInfoWithPlatform(platform: platform)
            
        }
        self.view.addSubview(sv!)
        return sv!
    }()

    func shareInfoWithPlatform(platform:JSHAREPlatform){
        let message = JSHAREMessage.init()
       // let dateString = DateUtils.dateToDateString(Date.init(), dateFormat: "yyy-MM-dd HH:mm:ss")
        message.title = "天亮前出发与梦想启程"
        message.text = "启程时代官方下载链接"
 
        message.platform = platform
        message.mediaType = .link;
        message.url = "https://apps.apple.com/cn/app/%E6%A9%99%E5%BF%83%E6%97%B6%E4%BB%A3/id1626455805"
        let imageLogo = UIImage.init(named: "logo")
       
        message.image = imageLogo?.pngData()
        var tipString = ""
        JSHAREService.share(message) { (state, error) in
            if state == JSHAREState.success{
                tipString = "分享成功";
            }else if state == JSHAREState.fail{
                tipString = "分享失败";
            }else if state == JSHAREState.cancel{
                tipString = "分享取消";
            } else if state == JSHAREState.unknown{
                tipString = "Unknown";
            }else{
                tipString = "Unknown";
            }
             DispatchQueue.main.async(execute: {
                
                let tipView = UIAlertController.init(title: "", message: tipString, preferredStyle: .alert)
                tipView.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: { (action) in
     
                }))
                self.present(tipView, animated: true, completion: nil)

            })
        }
 
    }
 

}
