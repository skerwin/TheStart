//
//  TipOffDetailViewController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/15.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh
import Reachability
import SnapKit

class TipOffDetailViewController: BaseViewController {

    
    var tableView:UITableView!
    var bottoomView:TipOffBottomView!
    var headerView:TipOffHeaderView!
    var headerViewbgView:UIView!
    var selectedSection = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "爆料详情"
        self.edgesForExtendedLayout = []
        initHeaderView()
        initTableView()
        initBootomView()
        self.addChild(commentBarVC)
        // Do any additional setup after loading the view.
    }
    lazy var commentBarVC: CommentBarController = { [unowned self] in
        let barVC = CommentBarController()
        self.view.addSubview(barVC.view)
        barVC.view.snp.makeConstraints { (make) in
            make.left.right.width.equalTo(self.view)
            if iphoneXOrIphoneX11 {
                //make.bottom.equalTo(self.view.snp.bottom).offset(-distance)
                make.bottom.equalTo(self.view.snp.bottom).offset(kChatBarOriginHeight)
            }else{
                make.bottom.equalTo(self.view.snp.bottom).offset(kChatBarOriginHeight)
            }
            make.height.equalTo(kChatBarOriginHeight)
        }
        barVC.delegate = self
        return barVC
    }()
    func initBootomView(){
        bottoomView = Bundle.main.loadNibNamed("TipOffBottomView", owner: nil, options: nil)!.first as? TipOffBottomView
        bottoomView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 48)
        bottoomView.delegate = self
        
        let bottoombgView = UIView.init(frame:  CGRect.init(x: 0, y: screenHeight - navigationHeaderAndStatusbarHeight - 48 - bottomBlankHeight, width: screenWidth, height: 48 + bottomBlankHeight))
        bottoombgView.backgroundColor = ZYJColor.barColor
        bottoombgView.addSubview(bottoomView)
        self.view.addSubview(bottoombgView)
        
      }
    
    func initHeaderView(){
        headerView = Bundle.main.loadNibNamed("TipOffHeaderView", owner: nil, options: nil)!.first as? TipOffHeaderView
        headerView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 69)
        //bottoomView.delegate = self
        
        headerViewbgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 69))
        headerViewbgView.backgroundColor = ZYJColor.barColor
        headerViewbgView.addSubview(headerView)
        
      }
    func initTableView(){
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - bottomBlankHeight - 48 - navigationHeaderAndStatusbarHeight), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = ZYJColor.main
        
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 110;
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.registerNibWithTableViewCellName(name: reCommentCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: CommentCell.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: TipOffContentView.nameOfClass)
        tableView.registerNibWithTableViewCellName(name: TipOffDetailImgCell.nameOfClass)
        
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
   
    }
    func savemessage(message:String){
        
    }
    // MARK: 重置barView的位置
    func resetChatBarFrame() {
        
        commentBarVC.resetKeyboard()
        UIApplication.shared.keyWindow?.endEditing(true)
        commentBarVC.view.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(kChatBarOriginHeight)
        }
        UIView.animate(withDuration: kKeyboardChangeFrameTime, animations: {
            self.view.layoutIfNeeded()
        })
    }

}
extension TipOffDetailViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: dateModelList.count ,isdisplay: true)
        
        if section == 0{
            return 1
        }else{
            if section%2 != 0{
                return 3
            }else{
                return 0
            }
        }

     }
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: TipOffContentView.nameOfClass) as! TipOffContentView
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.nameOfClass) as! CommentCell
            cell.selectionStyle = .none
            if section%2 != 0{
                cell.lineView.isHidden = true
            }else{
                cell.lineView.isHidden = false
            }
            return cell
        }
        
       
     }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 0{
            let sectionView = Bundle.main.loadNibNamed("TipOffCommentHeaderView", owner: nil, options: nil)!.first as! TipOffCommentHeaderView
            sectionView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 25)
            let bgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 25))
            bgView.addSubview(sectionView)
            return bgView
        }else{
            let sectionView = Bundle.main.loadNibNamed("CommemtFooerLineView", owner: nil, options: nil)!.first as! CommemtFooerLineView
            sectionView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 15)
            let bgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 15))
            bgView.addSubview(sectionView)

            if section%2 != 0{
                return bgView
            }else{
                return UIView()
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        if section == 0{
            return 25
        }else{
            if section%2 != 0{
                return 15
            }else{
                return 0
            }
        }
 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TipOffDetailImgCell", for: indexPath) as! TipOffDetailImgCell
            cell.selectionStyle = .none
            return cell
        }else{
            let row = indexPath.row
            let cell = tableView.dequeueReusableCell(withIdentifier: "reCommentCell", for: indexPath) as! reCommentCell
            cell.selectionStyle = .none
            cell.sectoin = indexPath.section
            if row == 0{
                cell.contentlabel.text = "她可能会威胁要拿出她的杀手锏：出自传来爆料糗事。她可能会威胁要拿出她的杀手锏：出自传来爆料糗事她可能会威胁要拿出她的杀手锏：出自传来爆料糗事"
            }else if row == 1{
                cell.contentlabel.text = "她可能会威胁要拿出她的杀手锏"
            }else if row == 2{
                cell.contentlabel.text = "她可能会威胁要拿出她的杀手锏：出自传来爆料糗事。她可能会威胁要拿出她的杀手锏：出自传来爆料糗事"
            }else if row == 3{
                cell.contentlabel.text = "她可能会威胁要拿出她的杀手锏：出自传来爆料糗事。"
            }else if row == 4{
                cell.contentlabel.text = "她可能会威胁要拿出她的杀手锏：出自传来爆料糗事。她可能会威胁要拿出她的杀手锏：出自传来爆料糗事"
            }else if row == 5{
                cell.contentlabel.text = "她可能会威胁要拿出她的杀手锏：出自传来爆料糗事。她可能会威胁要拿出她的杀手锏：出自传来爆料糗事她可能会威胁要拿出她的杀手锏：出自传来爆料糗事"
            }
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        resetChatBarFrame()
    }
}
extension TipOffDetailViewController:TipOffBottomViewDelegate{
    func defecateViewAction() {
        commentBarVC.barView.inputTextView.becomeFirstResponder()
    }
    
    func commentViewAction() {
        commentBarVC.barView.inputTextView.becomeFirstResponder()
    }
    
    func goodViewAction() {
        commentBarVC.barView.inputTextView.becomeFirstResponder()
    }
    
    
}
extension TipOffDetailViewController:CommentBarControllerDelegate{
    func commentBarGood() {
       
    }
    
    func sendMessage(messge: String) {
        if (messge.hasEmoji()) {
            showOnlyTextHUD(text: "不支持发送表情")
            return
            // message = message!.disable_emoji(text: message! as NSString)
        }
        
        if (messge.containsEmoji()) {
            showOnlyTextHUD(text: "不支持发送表情")
            return
            // message = message!.disable_emoji(text: message! as NSString)
        }
        if messge.isEmptyStr()  {
            showOnlyTextHUD(text: "评论内容不能为空")
            return
        }
        self.savemessage(message: messge)
        resetChatBarFrame()
    }
    
    func forLoginVC() {
         
    }
    
    
    func commentBarUpdateHeight(height: CGFloat) {
        commentBarVC.view.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
    }
    func commentBarVC(commentBarVC: CommentBarController, didChageChatBoxBottomDistance distance: CGFloat) {
        
       
        commentBarVC.view.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(-distance)
        }
        UIView.animate(withDuration: kKeyboardChangeFrameTime, animations: {
            self.view.layoutIfNeeded()
        })
        self.view.layoutIfNeeded()
      
        //self.tableView.scrollToRow(at: IndexPath(row: 0, section:selectedSection), at: .bottom, animated: true)
    }
    
}
