//
//  StoreDetailController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/08/21.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh
import Reachability
import SnapKit


class StoreDetailController: BaseViewController,Requestable  {
    
    var tableView:UITableView!
    var headView:StoreHeadView!
    var headerBgView:UIView!
    var selectedSection = 0
    
    var commentList = [CommentModel]()
    var dataCommentList = [Array<CommentModel>]()
    var dateID = 0
    var parentCommentID = -1
    
    var parentComment = CommentModel()
    
    var commentSection = 0
    var addComment = false
    var delCommet = false
    var adjustFrame = false
    
    
    var reportType = 1
    var reportID = 0
    var reportReason = ""
    
    var delindex = IndexPath.init(row: 0, section: 0)
    
    var bottoomView:StoreBottomView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "商家详情"
        initHeadView()
        initBootomView()
        initTableView()
        // Do any additional setup after loading the view.
    }
    
    func loadDetail(){
        let requestParams = HomeAPI.tipOffListPathAndParams(id: dateID)
        getRequest(pathAndParams: requestParams,showHUD:false)
    }
    func loadComment(){
        //print(page,limit)
        let requestCommentParams = HomeAPI.comentListPathAndParams(articleId: dateID,page: page,limit: limit)
        getRequest(pathAndParams: requestCommentParams,showHUD:false)
        
        
    }
    func initHeadView(){
        headView = Bundle.main.loadNibNamed("StoreHeadView", owner: nil, options: nil)!.first as? StoreHeadView
        headView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height:615)
        // headView.delegate = self
        headView.parentNavigationController = self.navigationController
        headerBgView = UIView.init(frame:  CGRect.init(x: 0, y: navigationHeaderAndStatusbarHeight, width: screenWidth, height: 615))
        headView.backgroundColor = ZYJColor.main
        headerBgView.addSubview(headView)
    }
    
    func initBootomView(){
        bottoomView = Bundle.main.loadNibNamed("StoreBottomView", owner: nil, options: nil)!.first as? StoreBottomView
        bottoomView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 48)
      //  bottoomView.delegate = self
        
        let bottoombgView = UIView.init(frame:  CGRect.init(x: 0, y: screenHeight - 48 - bottomBlankHeight, width: screenWidth, height: 48 + bottomBlankHeight))
        bottoombgView.backgroundColor = ZYJColor.barColor
        bottoombgView.addSubview(bottoomView)
        self.view.addSubview(bottoombgView)
        
      }
    
    lazy var commentBarVC: CommentBarController = { [unowned self] in
        let barVC = CommentBarController()
        self.view.addSubview(barVC.view)
        barVC.view.snp.makeConstraints { (make) in
            make.left.right.width.equalTo(self.view)
            if iphoneXOrIphoneX11 {
                //make.bottom.equalTo(self.view.snp.bottom).offset(-distance)
                make.bottom.equalTo(self.view.snp.bottom).offset(ZChatBarOriginHeight)
            }else{
                make.bottom.equalTo(self.view.snp.bottom).offset(ZChatBarOriginHeight)
            }
            make.height.equalTo(ZChatBarOriginHeight)
        }
        barVC.delegate = self
        return barVC
    }()
    
    func initTableView(){
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - bottomBlankHeight - 48), style: .grouped)
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
        
        let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
        tableView.mj_header = addressHeadRefresh
        
        let footerRefresh = GmmMJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(pullRefreshList))
        tableView.mj_footer = footerRefresh
        
        tableView.tableHeaderView = headerBgView
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
    }
    
    @objc func refreshList() {
        self.tableView.mj_footer?.resetNoMoreData()
        commentList.removeAll()
        dataCommentList.removeAll()
        commentSection = 0
        parentCommentID = 0
        parentComment = CommentModel()
        
        limit = 10
        page = 1
        self.loadComment()
    }
    
    @objc func pullRefreshList() {
        if limit == 10{
            page = page + 1
        }else{
            page = limit/10 + 1
        }
        limit = 10
        self.loadComment()
    }
    
    func addRefresh(){
        self.tableView.mj_footer?.resetNoMoreData()
        commentList.removeAll()
        dataCommentList.removeAll()
        if page != 1{
            limit = page * 10
        }
        page = 1
        self.loadComment()
        
    }
    
    func savemessage(text:String){
        
        if (text.hasEmoji()) {
            showOnlyTextHUD(text: "不支持发送表情")
            return
            // message = message!.disable_emoji(text: message! as NSString)
        }
        
        if (text.containsEmoji()) {
            showOnlyTextHUD(text: "不支持发送表情")
            return
            // message = message!.disable_emoji(text: message! as NSString)
        }
        if text.isEmptyStr()  {
            showOnlyTextHUD(text: "评论内容不能为空")
            return
        }
        
        var cModel = CommentModel()
        cModel?.article_id = self.dateID
        cModel?.comment = text
        if parentCommentID != -1{
            cModel?.rid = parentCommentID
            cModel?.uid = parentComment!.uid
        }else{
            cModel?.rid = 0
        }
        
        
        let requestParams = HomeAPI.addComentPathAndParams(model: cModel!, isTopComment: true)
        postRequest(pathAndParams: requestParams,showHUD:false)
    }
    
    
    func commentDelete(delrid:Int){
        let requestParams = HomeAPI.comentDelPathAndParams(rid: delrid)
        postRequest(pathAndParams: requestParams,showHUD:false)
        
    }
    
    
    func reportContent(){
        let requestParams = HomeAPI.reportPathAndParams(articleId: reportID, type: reportType, reason: reportReason, remark: "我要举报")
        postRequest(pathAndParams: requestParams,showHUD:false)
    }
    
    
    // MARK: 重置barView的位置
    func resetChatBarFrame() {
        
        commentBarVC.resetKeyboard()
        UIApplication.shared.keyWindow?.endEditing(true)
        commentBarVC.view.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(ZChatBarOriginHeight)
        }
        UIView.animate(withDuration: kKeyboardChangeFrameTime, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func didRecommetnClick() {
        
        let acVC = ActionSheetViewController(cellTitleList: ["垃圾广告", "不良信息","骚扰信息"])!
        acVC.valueBlock = { index in
            if index == 0{
                self.reportReason = "垃圾广告"
            }else if index == 0{
                self.reportReason = "低俗色情"
            }else{
                self.reportReason = "骚扰信息"
            }
            
        }
        acVC.confirmBlock = {
            if self.reportReason == ""{
                self.showOnlyTextHUD(text: "请选择投诉原因")
            }
            self.reportContent()
        }
        acVC.cellTitleColor = UIColor.darkGray
        acVC.cellTitleFont = 16
        acVC.titleString = "选择投诉原因"
        present(acVC, animated: false, completion:  nil)
        
    }
    
}


extension StoreDetailController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataCommentList.count
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataCommentList[section].count
    }
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //
    //        if section == 0{
    //            let cell = tableView.dequeueReusableCell(withIdentifier: TipOffContentView.nameOfClass) as! TipOffContentView
    //            cell.model = dataModel
    //            cell.delegate = self
    //            cell.selectionStyle = .none
    //            return cell
    //        }else{
    //            let hv = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 0.5))
    //            hv.backgroundColor = ZYJColor.main
    //            return hv
    //        }
    //    }
    //
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        if section == 0{
    //            return UITableView.automaticDimension
    //        }else{
    //            return 0.5
    //        }
    //    }
    //
    //    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //
    //        if section == 0{
    //            let sectionView = Bundle.main.loadNibNamed("TipOffCommentHeaderView", owner: nil, options: nil)!.first as! TipOffCommentHeaderView
    //            sectionView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: 25)
    //            let bgView = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: screenWidth, height: 25))
    //            bgView.addSubview(sectionView)
    //            return bgView
    //        }else{
    //            let hv = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 0.5))
    //            hv.backgroundColor = ZYJColor.main
    //            return hv
    //         }
    //    }
    //    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //
    //        if section == 0{
    //            return 25
    //        }else{
    //            return 0.5
    //        }
    //
    //    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let section = indexPath.section
        let row = indexPath.row
        
        let modelList = dataCommentList[section]
        if (modelList[row].rid) == 0{
            let section = indexPath.section
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.nameOfClass) as! CommentCell
            cell.selectionStyle = .none
            cell.parentNavigationController = self.navigationController
            cell.sectoin = section
            cell.delegeta = self
            cell.model = modelList[indexPath.row]
            let childArr = modelList[row].children
            if childArr.count != 0{
                cell.lineView.isHidden = true
            }else{
                cell.lineView.isHidden = false
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "reCommentCell", for: indexPath) as! reCommentCell
            cell.selectionStyle = .none
            cell.parentNavigationController = self.navigationController
            cell.delegeta = self
            cell.indexpath = indexPath
            cell.model = modelList[indexPath.row]
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if adjustFrame{
            resetChatBarFrame()
        }
        
    }
}


extension StoreDetailController:ReCommentCellDelegate{
    //回复
    func reComplainActiion(cmodel:CommentModel,onView:UIButton,index:IndexPath){
        
        commentSection = index.section
        let modelList = dataCommentList[commentSection - 1]
        let tempm = modelList[index.row]
        parentCommentID = tempm.rid
        parentComment = tempm
        self.adjustFrame = true
        commentBarVC.barView.inputTextView.becomeFirstResponder()
    }
    //举报和删除
    func redelActiion(cmodel:CommentModel,onView:UIButton,index:IndexPath){
        
        
        if (cmodel.uid == getUserId()){
            commentSection = index.section
            let modelList = dataCommentList[commentSection - 1]
            let tempm = modelList[index.row]
            parentCommentID = tempm.rid
            parentComment = tempm
            
            delindex = index
            self.adjustFrame = true
            
            let noticeView = UIAlertController.init(title: "", message: "您确定要删除此条评论么", preferredStyle: .alert)
            noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { [self] (action) in
                self.commentDelete(delrid: cmodel.id)
            }))
            noticeView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
                
            }))
            self.present(noticeView, animated: true, completion: nil)
        }else{
            commentSection = index.section
            reportType = 2
            let modelList = dataCommentList[commentSection - 1]
            let tempm = modelList[index.row]
            reportID = tempm.id
            self.adjustFrame = true
            didRecommetnClick()
        }
        
    }
    
    
    
}
extension StoreDetailController:CommentCellDelegate{
    
    //举报和删除
    func complainActiion(cmodel: CommentModel, section: Int) {
        
        if (cmodel.uid == getUserId()){
            commentSection = section
            parentCommentID = cmodel.id
            parentComment = cmodel
            self.adjustFrame = true
            
            let noticeView = UIAlertController.init(title: "", message: "您确定要删除此条评论么", preferredStyle: .alert)
            noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { [self] (action) in
                self.commentDelete(delrid: cmodel.id)
            }))
            noticeView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
                
            }))
            self.present(noticeView, animated: true, completion: nil)
        }else{
            reportType = 2
            reportID = commentList[section - 1].id
            self.adjustFrame = true
            didRecommetnClick()
        }
    }
    //回复
    func commentACtion(cmodel: CommentModel, section: Int) {
        commentSection = section
        parentCommentID = cmodel.id
        parentComment = cmodel
        self.adjustFrame = true
        commentBarVC.barView.inputTextView.becomeFirstResponder()
    }
}

extension StoreDetailController:CommentBarControllerDelegate{
    func commentBarGood() {
        
    }
    func sendMessage(messge: String) {
        self.savemessage(text: messge)
        adjustFrame = true
        resetChatBarFrame()
        adjustFrame = false
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

