//
//  GoodsCashDeskController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/25.
//


import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh
 
class GoodsCashDeskController:BaseTableController,PayRequestDelegate,Requestable {
    @IBOutlet weak var goodsImg: UIImageView!
    @IBOutlet weak var goodsname: UILabel!
    
    @IBOutlet weak var goodsDes: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var weixinTipImg: UIImageView!
    @IBOutlet weak var alipayTipImg: UIImageView!
    
    
    @IBOutlet weak var confirmpricelabel: UILabel!
    
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var cancleBtn: UIButton!

    
    
    @IBOutlet weak var addressalabel: UILabel!
    var priceStr = ""
    var payMode = 1 //0微信 1支付宝
    
    var paymodel = PayModel()
    var aliPaySignStr = ""
 
    var goodModel = GoodsModel()
    var addressmodel = AddressModel()
    
    var ordermodel = OrderModel()
    
  
    var isFromOrder = false
    var orderId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        if isFromOrder {
            weixinTipImg.image = UIImage.init(named: "successCircle")
            alipayTipImg.image = UIImage.init(named: "successCircle")
            
            loadOrderInfo()
        }else{
            cancleBtn.isHidden = true
            goodsImg.displayImageWithURL(url: goodModel?.image)
            goodsname.text = goodModel?.goods_name
            goodsDes.text = goodModel?.description
            priceLabel.text = goodModel?.price
            confirmpricelabel.text = "实付" + "¥" + goodModel!.price
            self.tableView.backgroundColor = UIColor.white
            weixinTipImg.image = UIImage.init(named: "successCircle")
            alipayTipImg.image = UIImage.init(named: "successCircle")
            alipayTipImg.isHidden = true
        }
      
        
    }
    
  
    func loadOrderInfo(){
        let requestParams = HomeAPI.goodsOrderDetailPathAndParams(id: orderId)
        postRequest(pathAndParams: requestParams,showHUD:false)
    }
    
    func cancleOrder(){
        let requestParams = HomeAPI.goodsOrderCanclePathAndParams(id: orderId)
        postRequest(pathAndParams: requestParams,showHUD:false)
    }
    
    
    func payOrder(){
        let requestParams = HomeAPI.goodsOrderNextPayPathAndParams(id: orderId)
        postRequest(pathAndParams: requestParams,showHUD:false)
    }
    
    func payRequestSuccess(data: String) {
        DialogueUtils.showSuccess(withStatus: "购买成功")
        delay(second: 1) { [self] in
            DialogueUtils.dismiss()
            self.dismiss(animated: true)
        }
     }
    
    
    func payRequestError(error: String) {
        DialogueUtils.showError(withStatus: "支付失败")
        delay(second: 1) { [self] in
            DialogueUtils.dismiss()
            self.dismiss(animated: true)
        }
    }
 
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
    @IBAction func cancleBtnAction(_ sender: Any) {
        let requestParams = HomeAPI.goodsOrderCanclePathAndParams(id: orderId)
        postRequest(pathAndParams: requestParams,showHUD:false)
    }
    
    @IBAction func buyBtnAction(_ sender: Any) {
        
        if isFromOrder{
            PaySDK.instance.payDelegate = self
            let requestParams = HomeAPI.goodsOrderNextPayPathAndParams(id: orderId)
            postRequest(pathAndParams: requestParams,showHUD:false)
        }else{
            PaySDK.instance.payDelegate = self
           let requestParams = HomeAPI.orderAddPathAndParams(goods_id: goodModel!.id, address_id: addressmodel!.id , pay_type: payMode)
            postRequest(pathAndParams: requestParams,showHUD:false)
        }
     }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
           
    }

    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        
       
        if requestPath == HomeAPI.orderAddPath{
            if payMode == 1 {
                paymodel = Mapper<PayModel>().map(JSONObject: responseResult["config"].rawValue)
                if paymodel?.prepayid != ""{
                    PaySDK.instance.wechatPayRequest(signData: paymodel!)
                }else{
                    showOnlyTextHUD(text: "下单失败")
                }
            }else{
                aliPaySignStr = responseResult["config"].stringValue
                if aliPaySignStr != ""{
                    PaySDK.instance.alipayPayRequest(sign: aliPaySignStr)
                }else{
                    showOnlyTextHUD(text: "下单失败")
                }
            }
        }else if requestPath == HomeAPI.goodsOrderDetailPath{
            
            ordermodel = Mapper<OrderModel>().map(JSONObject: responseResult.rawValue)
            
            goodsImg.displayImageWithURL(url: ordermodel?.image)
            goodsname.text = ordermodel?.goods_name
            goodsDes.text = "订单号:" + ordermodel!.order_sn
            priceLabel.text = ordermodel?.price
            confirmpricelabel.text = "实付" + "¥" + ordermodel!.price
            buyBtn.setTitle("继续支付", for: .normal)
            self.tableView.backgroundColor = UIColor.white
            if ordermodel?.pay_type == 1{
                alipayTipImg.isHidden = true
            }else{
                weixinTipImg.isHidden = true
            }
            addressalabel.text =  ordermodel!.province + ordermodel!.city + ordermodel!.district + ordermodel!.detail
            
        }else if requestPath == HomeAPI.goodsOrderCanclePath{
            showOnlyTextHUD(text: "订单已取消")
            delay(second: 0.1) { [self] in
    //            if (self.reloadBlock != nil) {
    //                self.reloadBlock!()
    //            }
                DialogueUtils.dismiss()
                self.navigationController?.popViewController(animated: true)
            }
         
            
        }else if requestPath == HomeAPI.goodsOrderNextPayPath{
            if payMode == 1 {
                paymodel = Mapper<PayModel>().map(JSONObject: responseResult["config"].rawValue)
                if paymodel?.prepayid != ""{
                    PaySDK.instance.wechatPayRequest(signData: paymodel!)
                }else{
                    showOnlyTextHUD(text: "下单失败")
                }
            }else{
                aliPaySignStr = responseResult["config"].stringValue
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
        if isFromOrder {
            return 3
        }
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFromOrder{
            
        }else{
            if indexPath.row == 0{
                payMode = 1
                weixinTipImg.isHidden = false
                alipayTipImg.isHidden = true
            }else if indexPath.row == 1{
                payMode = 2
                alipayTipImg.isHidden = false
                weixinTipImg.isHidden = true
            }
        }
      
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isFromOrder {
            if indexPath.row == 2{
                return 130
            }
        }
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
