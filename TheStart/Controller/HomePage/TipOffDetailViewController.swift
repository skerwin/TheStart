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

class TipOffDetailViewController: BaseViewController,Requestable {

    
    var tableView:UITableView!
    var bottoomView:TipOffBottomView!
    var headerView:TipOffHeaderView!
    var headerViewbgView:UIView!
    var selectedSection = 0
    
    var dataModel = TipOffModel()
    var commentList = [CommentModel]()
    
    var dataCommentList = [Array<CommentModel>]()
    var dateID = 0
    var parentCommentID = -1
    var commentSection = 0
    var addComment = false
    var adjustFrame = false
    
    var rightBarButton:UIButton!
    var reportType = 1
    var reportID = 0
    var reportReason = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "详情内容"
        self.edgesForExtendedLayout = []
        createRightNavItem()
        loadDetail()
        loadComment()
        initHeaderView()
        initTableView()
        initBootomView()
        self.addChild(commentBarVC)
        // Do any additional setup after loading the view.
    }
    
    func loadDetail(){
        let requestParams = HomeAPI.tipOffListPathAndParams(id: dateID)
        getRequest(pathAndParams: requestParams,showHUD:false)
    }
    func loadComment(){
        print(page,limit)
        let requestCommentParams = HomeAPI.comentListPathAndParams(articleId: dateID,page: page,limit: limit)
        getRequest(pathAndParams: requestCommentParams,showHUD:false)
     }
 
    func createRightNavItem() {
        
        rightBarButton = UIButton.init()
        let bgview = UIView.init()
 
            
        rightBarButton.frame = CGRect.init(x: 0, y: 8, width: 63, height: 28)
        rightBarButton.setTitle("投诉", for: .normal)
        bgview.frame = CGRect.init(x: 0, y: 0, width: 65, height: 44)
        rightBarButton.setImage(UIImage.init(named: "jubao"), for: .normal)
        rightBarButton.addTarget(self, action: #selector(rightNavBtnClic(_:)), for: .touchUpInside)
        rightBarButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 0)
        rightBarButton.setTitleColor(.white, for: .normal)
        rightBarButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
     
        bgview.addSubview(rightBarButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: bgview)
        
    }

    @objc func rightNavBtnClic(_ btn: UIButton){
        reportType = 1
        reportID = dateID
        didRecommetnClick()
    
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
              tableView.mj_header?.endRefreshing()
              tableView.mj_footer?.endRefreshing()
              self.tableView.mj_footer?.endRefreshingWithNoMoreData()
    }


    
    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        
        if requestPath == HomeAPI.addComentPath{
            showOnlyTextHUD(text: "评论成功")
            addComment = true
            addRefresh()
        }else if requestPath.containsStr(find: HomeAPI.comentListPath){
            tableView.mj_header?.endRefreshing()
            tableView.mj_footer?.endRefreshing()
            let list:[CommentModel]  = getArrayFromJson(content: responseResult)
            commentList.append(contentsOf: list)
            for cModel in list {
                var tempList = [CommentModel]()
                tempList.append(cModel)
                if cModel.children_count != 0 {
                    for subModel in cModel.children {
                        tempList.append(subModel)
                    }
                }
                dataCommentList.append(tempList)
            }
             if list.count < 10 {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
            self.tableView.reloadData()
            if commentSection == 0 {
                if addComment {
                    if limit != 10{
                        let indexPath = IndexPath.init(row: 0, section: 1)
                        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                    }
                }

            }else{
                let row = dataCommentList[commentSection - 1].count - 1
                let indexPath = IndexPath.init(row: row, section: commentSection)
                tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
         }else if requestPath == HomeAPI.reportPath{
             showOnlyTextHUD(text: "投诉成功，将尽快处理")
            
         }
        else if requestPath == HomeAPI.collectAddPath{
            showOnlyTextHUD(text: "点赞成功")
            let num = responseResult["number"].intValue
            dataModel?.dianzan = num
            dataModel?.is_dianzan = 1
            bottoomView.configModel(model: dataModel!)
            
           
        }
        else if requestPath == HomeAPI.collectDelPath{
            showOnlyTextHUD(text: "取消点赞成功")
            let num = responseResult["number"].intValue
            dataModel?.dianzan = num
            dataModel?.is_dianzan = 0
            bottoomView.configModel(model: dataModel!)
        }
        
        else{
            dataModel = Mapper<TipOffModel>().map(JSONObject: responseResult.rawValue)
            headerView.configModel(model: dataModel!)
            bottoomView.configModel(model: dataModel!)
            
            self.tableView.reloadData()
        }
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
        headerView.delegate = self
 
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
        
        let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
        tableView.mj_header = addressHeadRefresh

        let footerRefresh = GmmMJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(pullRefreshList))
        tableView.mj_footer = footerRefresh
        
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
   
    }
    
    @objc func refreshList() {
        self.tableView.mj_footer?.resetNoMoreData()
        commentList.removeAll()
        dataCommentList.removeAll()
        commentSection = 0
        parentCommentID = 0
    
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
        }else{
            cModel?.rid = 0
        }
        
        
        let requestParams = HomeAPI.addComentPathAndParams(model: cModel!)
        postRequest(pathAndParams: requestParams,showHUD:false)
    }
    
    func reportContent(){
        let requestParams = HomeAPI.reportPathAndParams(articleId: reportID, type: reportType, reason: reportReason, remark: "我要举报")
        postRequest(pathAndParams: requestParams,showHUD:false)
    }
    
    func likeActiion(){
        let requestParams = HomeAPI.collectAddPathAndParams(articleId: dateID)
        postRequest(pathAndParams: requestParams,showHUD:false)
    }
    func unlikeActiion(){
        let requestParams = HomeAPI.collectDelPathAndParams(articleId: dateID)
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
        
        let acVC = ActionSheetViewController(cellTitleList: ["垃圾广告", "低俗色情","骚扰信息"])!
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


extension TipOffDetailViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataCommentList.count + 1
 
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //tableView.tableViewDisplayWithMsg(message: "暂无数据", rowCount: dateModelList.count ,isdisplay: true)
        if section == 0{
            if dataModel?.image_input.count == 0{
                return 0
            }else{
                return 1
            }
        }else{
            return dataCommentList[section - 1].count
        }
    }
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: TipOffContentView.nameOfClass) as! TipOffContentView
            cell.model = dataModel
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }else{
            let hv = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 0.5))
            hv.backgroundColor = ZYJColor.main
            return hv
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return UITableView.automaticDimension
        }else{
            return 0.5
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
            let hv = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 0.5))
            hv.backgroundColor = ZYJColor.main
            return hv
         }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        if section == 0{
            return 25
        }else{
            return 0.5
        }
 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let section = indexPath.section
        let row = indexPath.row
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TipOffDetailImgCell", for: indexPath) as! TipOffDetailImgCell
            cell.model = dataModel
            cell.selectionStyle = .none
            return cell
        }else{
            let modelList = dataCommentList[section - 1]
            if (modelList[row].rid) == 0{
                let section = indexPath.section
                let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.nameOfClass) as! CommentCell
                cell.selectionStyle = .none
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
                cell.delegeta = self
                cell.sectoin = indexPath.section
                cell.model = modelList[indexPath.row]
                return cell
            }
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

extension TipOffDetailViewController:TipOffHeaderViewDelegate{
    func msgBtnAction() {
        let noticeView = UIAlertController.init(title: "", message: "您确定拨打对方的联系电话吗？", preferredStyle: .alert)
        
         noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
             
             
//             let urlstr = "telprompt://" + "18153684982"
//             if let url = URL.init(string: urlstr){
//                  if #available(iOS 10, *) {
//                     UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                 } else {
//                     UIApplication.shared.openURL(url)
//                  }
//               }
 
        }))
        
        noticeView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
            
        }))
        self.present(noticeView, animated: true, completion: nil)
    }
    
    
}
extension TipOffDetailViewController:TipOffContentViewDelegate{
    func clarifyBtnAction() {
        let controller = ClarifyViewController()
        controller.isFromTipOffPage = true
        controller.clarifyId = dataModel!.id
        self.navigationController?.pushViewController(controller, animated: true)
    }
 }
extension TipOffDetailViewController:ReCommentCellDelegate{
    func reComplainActiion(cmodel: CommentModel, onView: UIButton) {
        didRecommetnClick()
    }
 
}
extension TipOffDetailViewController:CommentCellDelegate{
    func complainActiion(cmodel: CommentModel, section: Int) {
        
        reportType = 2
        reportID = commentList[section - 1].id
        print(commentList[section - 1].comment)
        self.adjustFrame = true
        didRecommetnClick()
    }
    
    
    func commentACtion(cmodel: CommentModel, section: Int) {
        commentSection = section
        parentCommentID = cmodel.id
        self.adjustFrame = true
        commentBarVC.barView.inputTextView.becomeFirstResponder()
    }
    
}
        
extension TipOffDetailViewController:TipOffBottomViewDelegate{
    func defecateViewAction() {
        
        if dataModel?.type == 1{
            if dataModel?.id == 0{
                return
            }
            let controller = TipOffPostViewController()
            controller.tipOffID = dataModel!.id
            controller.articleType = 3
            controller.reloadBlock = {[weak self] () -> Void in
                self!.adjustFrame = true
                self!.resetChatBarFrame()
                self!.adjustFrame = false
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
            let controller = TipOffDetailViewController()
            controller.dateID = dataModel!.clarify_id
            self.navigationController?.pushViewController(controller, animated: true)
        }
       
    }
    
    func commentViewAction() {
        self.adjustFrame = true
        commentSection = 0
        parentCommentID = 0
        commentBarVC.barView.inputTextView.becomeFirstResponder()
    }
    
    func goodViewAction() {
        
        if dataModel?.is_dianzan == 1{
            unlikeActiion()
        }else{
            likeActiion()
        }
       
        self.adjustFrame = true
        //commentBarVC.barView.inputTextView.becomeFirstResponder()
    }
    
    
}
extension TipOffDetailViewController:CommentBarControllerDelegate{
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
