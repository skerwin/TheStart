//
//  MineViewController.swift
//  YiLuHuWei
//
//  Created by zhaoyuanjing on 2020/07/29.
//  Copyright © 2020 gansukanglin. All rights reserved.
//

//import IQKeyboardManagerSwift
import SwiftyJSON
import ObjectMapper
import SDCycleScrollView
import UIKit

class MineViewController: BaseTableController{
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的"
        self.tableView.backgroundColor = ZYJColor.main
        self.tableView.tableFooterView = UIView()
    }
 
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "我的"

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
   
    
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return 1
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
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
 
    
    }
    
}
 

