//
//  PayViewController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/13.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh

class PayViewController: BaseViewController, PayRequestDelegate,Requestable {
    
    
    
    var paymodel = PayModel()
    var aliPaySignStr = ""
    
    
    @IBAction func weixinPayAction(_ sender: Any) {
        PaySDK.instance.payDelegate = self
        let requestParams = HomeAPI.wechatPayPathAndParams(price: "0.01", leixing: 1)
        postRequest(pathAndParams: requestParams,showHUD:false)
    }
    
    
    @IBAction func alipayAction(_ sender: Any) {
        PaySDK.instance.payDelegate = self
        let requestParams = HomeAPI.aliPayPathPathAndParams(price: "0.01", leixing: 1)
        postRequest(pathAndParams: requestParams,showHUD:false)
    }
    
    
    func payRequestSuccess(data: String) {
        print(data)
        DialogueUtils.showSuccess(withStatus: "购买成功")
    }
    
    
    func payRequestError(error: String) {
        DialogueUtils.showError(withStatus: "支付失败")
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
  
    override func onFailure(responseCode: String, description: String, requestPath: String) {
           
    }

    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        
        if requestPath == HomeAPI.wechatPayPath{
            paymodel = Mapper<PayModel>().map(JSONObject: responseResult["data"].rawValue)
            if paymodel?.prepayid != ""{
                PaySDK.instance.wechatPayRequest(signData: paymodel!)
            }else{
                showOnlyTextHUD(text: "下单失败")
            }
        }else if requestPath == HomeAPI.aliPayPath{
            aliPaySignStr = responseResult["data"].stringValue
            if aliPaySignStr != ""{
                PaySDK.instance.alipayPayRequest(sign: aliPaySignStr)
            }else{
                showOnlyTextHUD(text: "下单失败")
            }
        }
      

    }
    
    
        //拿到后台数据开始支付
//    //- MARK: payRequestDelegate
//    func wechatPaySign(data: NSDictionary) {
//        PaySDK.instance.wechatPayRequest(signData: data)
//    }
//
//    func alipayPaySign(str: String) {
//        PaySDK.instance.alipayPayRequest(sign: str)
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
