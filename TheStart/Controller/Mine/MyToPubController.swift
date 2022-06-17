//
//  MyToPubController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/05/11.
//

import UIKit

class MyToPubController: BaseViewController {

    @IBOutlet weak var jobBtn: UIButton!
    @IBOutlet weak var workerBtn: UIButton!
    
    @IBOutlet weak var musicBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "信息发布"
        jobBtn.layer.masksToBounds = true
        jobBtn.layer.cornerRadius = 20

        workerBtn.layer.masksToBounds = true
        workerBtn.layer.cornerRadius = 20
        
        musicBtn.layer.masksToBounds = true
        musicBtn.layer.cornerRadius = 20
        
         // Do any additional setup after loading the view.
    }
    

    @IBAction func jobBtnAction(_ sender: Any) {
        let controller = WorkerPubViewController()
        controller.pubType = 2
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func workerBtnAction(_ sender: Any) {
        let controller = WorkerPubViewController()
        controller.pubType = 1
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func musicBtnAction(_ sender: Any) {
        let controller = PubMusicController()
        self.navigationController?.pushViewController(controller, animated: true)
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
