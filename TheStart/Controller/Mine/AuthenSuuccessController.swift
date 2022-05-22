//
//  AuthenSuuccessController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/22.
//

import UIKit

class AuthenSuuccessController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    var titlestr = "您已认证通过"
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titlestr
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
