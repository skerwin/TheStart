//
//  PayService.swift
//  Pay_Example
//
//  Created by Tank on 2018/9/13.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

public protocol PayRequestDelegate {
    
    func payRequestSuccess(data: String) -> Void
    func payRequestError(error: String) -> Void
}


public class PaySDK: NSObject {
    public static let instance: PaySDK = PaySDK()
    
    public var signUrl: String? = nil
    public static var alipayAppid: String? = nil

    public var payDelegate: PayRequestDelegate?
    public func isInstalled() -> Bool {
        return WXApi.isWXAppInstalled()
    }
    
    func wechatPayRequest(signData: PayModel) {
        
        let payReq = PayReq()
        payReq.nonceStr = signData.noncestr
        payReq.partnerId = signData.partnerid
        payReq.prepayId = signData.prepayid
        payReq.timeStamp = signData.timestamp
        payReq.package = signData.package
        payReq.sign = signData.sign
        WXApi.send(payReq)
    }
    
    func alipayPayRequest(sign: String) {
        
        print(PaySDK.alipayAppid!)
        
        AlipaySDK.defaultService().payOrder(sign, fromScheme: PaySDK.alipayAppid!) { (result) in
          
        }
        
     }
    
    public func handleOpenURL(_ url: URL) -> Bool {
        
        if url.host == "safepay"{
            AlipaySDK.defaultService().processOrder(withPaymentResult: url) { resultDict in
                
                let resDict:Dictionary<String, AnyObject> = resultDict as! Dictionary<String, AnyObject>
                
                print(resDict)
//                for model in resDict {
//                    print(model.key)
//                    print(model.value)
//                }
//
//                let total = resDict["result"]!["total_amount"]
                
      //返回值
//                {"alipay_trade_app_pay_response":{"code":"10000","msg":"Success","app_id":"2021003109634497","auth_app_id":"2021003109634497","charset":"UTF-8","timestamp":"2022-05-13 18:05:48","out_trade_no":"wx2022051318054310337","total_amount":"0.01","trade_no":"2022051322001429471402178768","seller_id":"2088341354437402"},"sign":"C/0BA6tAA49tptnFF+9VKu07Y51FM/PKcL87cB6AunpxEj9tyCucL/rYHtZE+s040gIYfNeaW+BBPocn2tDSR/aCYSCASptWnHsd889EgwgYOZef1OkXMHF7A4UQRI9PmPkBp6mEGrhg+4aw/dasyDBEy8t3FawqRqsJfrGSoGRsyYQLpMESctdlaBLQYRMpoWb9pOXnyb/cD7wLmLhrrM0H+73rpqeH76qhb0t7FoaCKt7vQZ9zSg+5eZQ8vAoR1Ddb3JaZt2bg+ZDHrnV71lLIVEJG2NRnkMD4K5YZIJYADVgVsuGLx/7tFNBhXhWzGhjZIwwdmk88h/Llt2H29w==","sign_type":"RSA2"}
                
            }
            return true
        }else{  //"pay"
            return WXApi.handleOpen(url, delegate: PaySDK.instance)
        }
       
    }
    
}
extension PaySDK: WXApiDelegate {
    public func onReq(_ req: BaseReq) {
        
    }
    
    public func onResp(_ resp: BaseResp) {
        let payResp = resp as! PayResp
        if 0 == payResp.errCode {
            payDelegate?.payRequestSuccess(data: payResp.returnKey)
        } else {
            payDelegate?.payRequestError(error: payResp.errStr)
        }
    }
    
}

