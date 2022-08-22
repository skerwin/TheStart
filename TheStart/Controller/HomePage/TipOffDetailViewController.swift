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
    
    var parentComment = CommentModel()
    
    var commentSection = 0
    var addComment = false
    var delCommet = false
    var adjustFrame = false
    
    var rightBarButton:UIButton!
    var rightBarButton2:UIButton!
    
    var reportType = 1
    var reportID = 0
    var reportReason = ""
    
    var isFromMine = false
    
    var delindex = IndexPath.init(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "详情内容"
        //self.edgesForExtendedLayout = []
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
        //print(page,limit)
        let requestCommentParams = HomeAPI.comentListPathAndParams(articleId: dateID,page: page,limit: limit)
        getRequest(pathAndParams: requestCommentParams,showHUD:false)
     }
    //暂时不用
    func loadSectionComment(){
        //print(page,limit)
        let requestCommentParams = HomeAPI.comentListPathAndParams(articleId: dateID,page: page,limit: limit)
        getRequest(pathAndParams: requestCommentParams,showHUD:false)
     }
 
   
    
    func createRightNavItem() {
        
       
        var bgview:UIView
        bgview = UIView.init()
        
        if isFromMine{
          
            
            bgview.frame = CGRect.init(x: 0, y: 0, width: 65, height: 44)
            rightBarButton = UIButton.init()
            rightBarButton.frame = CGRect.init(x: 0, y: 8, width: 63, height: 28)
            rightBarButton.setTitle("删除", for: .normal)
            rightBarButton.addTarget(self, action: #selector(rightNavBtnClick(_:)), for: .touchUpInside)
            rightBarButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 0)
            rightBarButton.setTitleColor(.darkGray, for: .normal)
            rightBarButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            bgview.addSubview(rightBarButton)
        }else{
           
            bgview.frame = CGRect.init(x: 0, y: 0, width: 80, height: 44)
            rightBarButton = UIButton.init()
            rightBarButton.frame = CGRect.init(x: 40, y: 2, width: 40, height: 40)
            rightBarButton.setImage(UIImage.init(named: "jubao"), for: .normal)
            rightBarButton.addTarget(self, action: #selector(rightNavBtnClick(_:)), for: .touchUpInside)
            rightBarButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            rightBarButton.setTitleColor(.darkGray, for: .normal)
            rightBarButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            
            
            rightBarButton2 = UIButton.init()
            rightBarButton2.frame = CGRect.init(x: 0, y: 2, width: 40, height:40)
            rightBarButton2.setImage(UIImage.init(named: "share"), for: .normal)
            //rightBarButton.setTitle("投诉", for: .normal)
            rightBarButton2.addTarget(self, action: #selector(rightNavBtnClick2(_:)), for: .touchUpInside)
            rightBarButton2.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            rightBarButton2.setTitleColor(.darkGray, for: .normal)
            rightBarButton2.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            bgview.addSubview(rightBarButton)
            bgview.addSubview(rightBarButton2)
        }
         self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: bgview)
    }
    
    @objc func rightNavBtnClick2(_ btn: UIButton){
        self.shareView.show(withContentType: JSHAREMediaType(rawValue: 3)!)
    }

    @objc func rightNavBtnClick(_ btn: UIButton){
        if isFromMine{
            let noticeView = UIAlertController.init(title: "", message: "你确定要删除本条信息么", preferredStyle: .alert)
            noticeView.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { [self] (action) in
                let requestParams = HomeAPI.articleDelPathAndParams(id: dateID)
                postRequest(pathAndParams: requestParams,showHUD:false)
            }))
            noticeView.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
                
            }))
            self.present(noticeView, animated: true, completion: nil)
        }else{
            reportType = 1
            reportID = dateID
            didRecommetnClick()
           
        }
    }
    
    
    lazy var shareView: ShareView = {
        let sv = ShareView.getFactoryShareView { (platform, type) in
            self.shareInfoWithPlatform(platform: platform)
            
        }
        self.view.addSubview(sv!)
        return sv!
    }()

    func shareInfoWithPlatform(platform:JSHAREPlatform){
        let message = JSHAREMessage.init()
       // let dateString = DateUtils.dateToDateString(Date.init(), dateFormat: "yyy-MM-dd HH:mm:ss")
        message.title =  dataModel?.title
        message.text = dataModel?.content
 
        message.platform = platform
        message.mediaType = .link;
        message.url = dataModel?.link_url
        let imageLogo = UIImage.init(named: "logo")
       
        message.image = imageLogo?.pngData()
        var tipString = ""
        JSHAREService.share(message) { (state, error) in
            if state == JSHAREState.success{
                tipString = "分享成功";
            }else if state == JSHAREState.fail{
                tipString = "分享失败";
            }else if state == JSHAREState.cancel{
                tipString = "分享取消";
            } else if state == JSHAREState.unknown{
                tipString = "Unknown";
            }else{
                tipString = "Unknown";
            }
             DispatchQueue.main.async(execute: {
                let tipView = UIAlertController.init(title: "", message: tipString, preferredStyle: .alert)
                tipView.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: { (action) in
     
                }))
                self.present(tipView, animated: true, completion: nil)

            })
        }
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
        }
        else if requestPath == HomeAPI.comentDelPath{
            showOnlyTextHUD(text: "删除成功")
            delCommet = true
            addRefresh()
        }
        
        else if requestPath.containsStr(find: HomeAPI.comentListPath){
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
                if addComment || delCommet{
                    if limit != 10{
                        let indexPath = IndexPath.init(row: 0, section: 1)
                        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                        addComment = false
                        delCommet = false
                    }
                }

            }else{
                
                if delCommet {
                    if self.delindex.section != 0 {
                        //删回复
                        var row = 0
                        row = self.delindex.row - 1
                        let indexPath = IndexPath.init(row: row, section: commentSection)
                        tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
                    }else{
                        let row = 0
                        let indexPath = IndexPath.init(row: row, section: commentSection - 1)
                        tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
                    }
                    
                    
                }else if addComment{
                    let row = dataCommentList[commentSection - 1].count - 1
                    let indexPath = IndexPath.init(row: row, section: commentSection)
                    tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
                    addComment = false
                }
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
        else if requestPath == HomeAPI.articleDelPath{
            DialogueUtils.showSuccess(withStatus: "删除成功")
            delay(second: 0.1) { [self] in
    //            if (self.reloadBlock != nil) {
    //                self.reloadBlock!()
    //            }
                DialogueUtils.dismiss()
                self.navigationController?.popViewController(animated: true)
            }
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
        
        let bottoombgView = UIView.init(frame:  CGRect.init(x: 0, y: screenHeight - 48 - bottomBlankHeight, width: screenWidth, height: 48 + bottomBlankHeight))
        bottoombgView.backgroundColor = UIColor.systemGray6
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
                cell.indexpath = indexPath
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
        let noticeView = UIAlertController.init(title: "温馨提示", message: "会员无限，非会员每天仅可获取三次对方联系方式，您确定获取吗？", preferredStyle: .alert)
        
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
            reportType = 2
            let modelList = dataCommentList[commentSection - 1]
            let tempm = modelList[index.row]
            reportID = tempm.id
            self.adjustFrame = true
            didRecommetnClick()
        }
 
     }
    
    
 
}
extension TipOffDetailViewController:CommentCellDelegate{
    
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
        parentComment = CommentModel()
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
