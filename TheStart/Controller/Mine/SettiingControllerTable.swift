//
//  SettiingControllerTable.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/06/13.
//

import UIKit
import IQKeyboardManager
import SwiftyJSON
import ObjectMapper

class SettiingControllerTable: BaseTableController,Requestable {

    
    var userAgreementHtml = ""
    var privasyHtml = ""
    
    var isopen = 1
    
    
    @IBOutlet weak var isOpenSwitch: UISwitch!
    
    @IBAction func isOpenAction(_ sender: Any) {
        
        
        if isOpenSwitch.isOn == true{
            isopen = 1
          }else{
            isopen = 0
         }
        
        let requestParams = HomeAPI.userinfo_openPathAndParam(ifopen: isopen)
        postRequest(pathAndParams: requestParams,showHUD: false)
        
        //static let userinfo_openPath = "/api/user/userinfo_open"
        //static func userinfo_openPathAndParam(ifopen:Bool = true) -> PathAndParams {

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        loadPrivateAndAbouutUs()
        if intForKey(key: Constants.ifOpen) != nil {
            isopen = intForKey(key: Constants.ifOpen)!
        }
        
        if isopen == 0{
            isOpenSwitch.isOn = false
        }else{
            isOpenSwitch.isOn = true
        }
        
      
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        //ischeck 是否审核  0 未审核  1  审核中  2 通过审核 3 审核为通过
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        
        if requestPath.containsStr(find: "/api/danye/4"){
            privasyHtml = responseResult["content"].stringValue
        } else if requestPath.containsStr(find: "/api/danye/3"){
            userAgreementHtml = responseResult["content"].stringValue
        }
 
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
        
        super.onFailure(responseCode: responseCode, description: description, requestPath: requestPath)
        
    }
    
    func loadPrivateAndAbouutUs() {
        
       
 
        let requestParamsP0 = HomeAPI.privacyUserAgreementPathAndParam(id:2)
        getRequest(pathAndParams: requestParamsP0,showHUD: false)

        let requestParamsP1 = HomeAPI.privacyUserAgreementPathAndParam(id:3)
        getRequest(pathAndParams: requestParamsP1,showHUD: false)
        
        let requestParamsP2 = HomeAPI.privacyUserAgreementPathAndParam(id:4)
        getRequest(pathAndParams: requestParamsP2,showHUD: false)
       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2{
            let noticeView = UIAlertController.init(title: "", message: "您确定拨打客服联系电话吗？", preferredStyle: .alert)
            
             noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
                 
                 
                 let urlstr = "telprompt://" + "15002500877"
                 if let url = URL.init(string: urlstr){
                      if #available(iOS 10, *) {
                         UIApplication.shared.open(url, options: [:], completionHandler: nil)
                     } else {
                         UIApplication.shared.openURL(url)
                      }
                   }
     
            }))
             noticeView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
                
            }))
            self.present(noticeView, animated: true, completion: nil)
        }else if indexPath.row == 3{
            let conroller = PrivateStatusViewController()
            conroller.htmlString = userAgreementHtml
            self.present(conroller, animated: true, completion: nil)
        }else if indexPath.row == 4{
            let conroller = PrivateStatusViewController()
            conroller.htmlString = privasyHtml
            self.present(conroller, animated: true, completion: nil)
        }else if indexPath.row == 5{
            let noticeView = UIAlertController.init(title: "提示", message: "您确定注销账号么，注销后您的所有信息将被清除", preferredStyle: .alert)
            noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { [self] (action) in
 
                 let requestParams = HomeAPI.logoutPathAndParam()
                 self.getRequest(pathAndParams: requestParams,showHUD:false)
     
            }))
             noticeView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
                
            }))
            self.present(noticeView, animated: true, completion: nil)
        }else if indexPath.row == 1{
            let conroller = UIStoryboard.getCodeShareController()
            self.navigationController?.pushViewController(conroller, animated: true)
        }
        
        
    }
 
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
