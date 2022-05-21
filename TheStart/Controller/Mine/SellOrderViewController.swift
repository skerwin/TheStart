//
//  SellOrderViewController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/11.
//

import UIKit

class SellOrderViewController: BaseViewController,Requestable {

    
    var parentNavigationController: UINavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        let requestParams = HomeAPI.orderListPathAndParams()
        getRequest(pathAndParams: requestParams,showHUD:false)

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
