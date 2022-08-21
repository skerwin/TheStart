//
//  FreeOpenVipController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/07/27.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh
import IQKeyboardManager

class FreeOpenVipController:BaseTableController,PayRequestDelegate,Requestable {

    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var weixinTipImg: UIImageView!
    @IBOutlet weak var alipayTipImg: UIImageView!
    
    @IBOutlet weak var buyBtn: UIButton!
    
    @IBOutlet weak var phoneTextv: UITextField!
    
    var priceStr = ""
    var payMode = 0 //0微信 1支付宝
    
    var paytype = payType.ChargeStarCoin
    
    var paymodel = PayModel()
    var aliPaySignStr = ""
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }
    
    
    func payRequestSuccess(data: String) {
        //print(data)
        DialogueUtils.showSuccess(withStatus: "购买成功")
        delay(second: 1) { [self] in
 
            DialogueUtils.dismiss()
            self.dismiss(animated: true)
        }
    }
    
    
    func payRequestError(error: String) {
        delay(second: 1) { [self] in
            DialogueUtils.dismiss()
            self.dismiss(animated: true)
        }
       
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = UIColor.white
        weixinTipImg.image = UIImage.init(named: "successCircle")
        alipayTipImg.image = UIImage.init(named: "successCircle")
        alipayTipImg.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
    
    @IBAction func buyBtnAction(_ sender: Any) {
        
        if paytype == .ChargeStarCoin{
            if payMode == 0 {
                PaySDK.instance.payDelegate = self
                let requestParams = HomeAPI.wechatPayPathAndParams(price: priceStr, leixing: 1)
                postRequest(pathAndParams: requestParams,showHUD:false)
            }else{
                PaySDK.instance.payDelegate = self
                let requestParams = HomeAPI.aliPayPathPathAndParams(price: priceStr, leixing: 1)
                postRequest(pathAndParams: requestParams,showHUD:false)
            }
        }else{
            var payStr = "weixin"
            if payMode == 0 {
                payStr = "weixin"
            }else{
                payStr = "alipay"
            }
            PaySDK.instance.payDelegate = self
//           let requestParams = HomeAPI.buyVipPathAndParams(level_id: 3, pay_type: payStr, price: priceStr)
//           postRequest(pathAndParams: requestParams,showHUD:false)
            
            var phone = phoneTextv.text!
            if !(CheckoutUtils.isMobile(mobile: phone)){
                DialogueUtils.showWarning(withStatus: "请输入正确的手机号")
                return
            }
 
            let requestParams = HomeAPI.buyFreeVipPathAndParams(level_id: 3, pay_type: payStr, price: "0.01",phone:phone)
            postRequest(pathAndParams: requestParams,showHUD:false)
            
            
         }
      
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
        }else if requestPath == HomeAPI.buyVipPath{
            
            if payMode == 0 {
                paymodel = Mapper<PayModel>().map(JSONObject: responseResult["data"].rawValue)
                if paymodel?.prepayid != ""{
                    PaySDK.instance.wechatPayRequest(signData: paymodel!)
                }else{
                    showOnlyTextHUD(text: "下单失败")
                }
            }else{
                aliPaySignStr = responseResult["data"].stringValue
                if aliPaySignStr != ""{
                    PaySDK.instance.alipayPayRequest(sign: aliPaySignStr)
                }else{
                    showOnlyTextHUD(text: "下单失败")
                }
            }

        }else if requestPath == HomeAPI.buyFreeVipPath{
            
            if payMode == 0 {
                paymodel = Mapper<PayModel>().map(JSONObject: responseResult["data"].rawValue)
                if paymodel != nil{
                    PaySDK.instance.wechatPayRequest(signData: paymodel!)
                }else{
                    showOnlyTextHUD(text: "下单失败")
                }
            }else{
                aliPaySignStr = responseResult["data"].stringValue
                if aliPaySignStr != ""{
                    PaySDK.instance.alipayPayRequest(sign: aliPaySignStr)
                }else{
                    showOnlyTextHUD(text: "下单失败")
                }
            }

        }
 
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            payMode = 0
            weixinTipImg.isHidden = false
            alipayTipImg.isHidden = true
        }else if indexPath.row == 1{
            payMode = 1
            alipayTipImg.isHidden = false
            weixinTipImg.isHidden = true
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
