//
//  MessageController.swift
//  TheStart
//
//  Created by zhaoyuanjing on 2022/04/14.
//

import UIKit
import ObjectMapper
import SwiftyJSON
import MJRefresh


// cellID
 let ChatTextCellID = "ChatTextCellID"
 let ChatTextViewCellID = "ChatTextViewCellID"
 let ChatImageCellID = "ChatImageCellID"
 let ChatTimeCellID = "ChatTimeCellID"
 let ChatFileCellID = "ChatFileCellID"
 let ChatAudioCellID = "ChatAudioCellID"
 let ChatVideoCellID = "ChatVideoCellID"

// MARK:- 通知常量
// 通讯录好友发生变化
let kNoteContactUpdateFriends  = "noteContactUpdateFriends"
// 添加消息
let kNoteChatMsgInsertMsg    = "noteChatMsgInsertMsg"
// 更新消息状态
let kNoteChatMsgUpdateMsg = "noteChatMsgUpdateMsg"
// 重发消息状态
let kNoteChatMsgResendMsg = "noteChatMsgResendMsg"
// 点击消息中的图片
let kNoteChatMsgTapImg = "noteChatMsgTapImg"
// 音频播放完毕
let kNoteChatMsgAudioPlayEnd = "noteChatMsgAudioPlayEnd"
// 视频开始播放
let kNoteChatMsgVideoPlayStart = "noteChatMsgVideoPlayStart"
/* ============================== 录音按钮长按事件 ============================== */
let kNoteChatBarRecordBtnLongTapBegan = "noteChatBarRecordBtnLongTapBegan"
let kNoteChatBarRecordBtnLongTapChanged = "noteChatBarRecordBtnLongTapChanged"
let kNoteChatBarRecordBtnLongTapEnded = "noteChatBarRecordBtnLongTapEnded"
/* ============================== 与网络交互后返回 ============================== */
let kNoteWeChatGoBack = "noteWeChatGoBack"

enum WeChatKeyboardType: Int {
    case noting
    case voice
    case text
    case emotion
    case more
}


let kChatBarOriginHeight: CGFloat = 54.0
let kChatBarTextViewMaxHeight: CGFloat = 100
let kChatBarTextViewHeight: CGFloat = kChatBarOriginHeight - 14.0

// MARK: Funcs
class MessageController: BaseViewController,Requestable,UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    @IBOutlet weak var emoBtn: UIButton!
    
    @IBOutlet weak var BgLineHeight: NSLayoutConstraint!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var bottomMargin: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    var keyboardHeight: CGFloat = 0.0
    
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var emojiView: UIView!
    var currentKeyboardType: WeChatKeyboardType = .noting
    @IBOutlet weak var inputTextView: CustomResponderTextView!
    @IBOutlet weak var barHeight: NSLayoutConstraint!
    var inputTextViewCurHeight: CGFloat = kChatBarOriginHeight
    
    @IBOutlet weak var selectorPageControl: UIPageControl!
    @IBOutlet weak var selectorCollectionView: UICollectionView!
    @IBOutlet weak var emoPageControl: UIPageControl!
    @IBOutlet weak var emotionCollectionView: UICollectionView!
    var emotionViewModel: EmotionViewModel = EmotionViewModel()
    var moreSelectorViewModel: MoreActionViewModel = MoreActionViewModel()
   // var msgViewModel: MsgListViewModel = MsgListViewModel()
    
    var menuIndex: Int?
    
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var EmojiViewToTop: NSLayoutConstraint!
    @IBOutlet weak var MoreViewToTop: NSLayoutConstraint!
 
    
    var heightArr: [CGFloat] = []
    var dataArr: [ChatMsgModel] = []
    
    var dataCloneArr: [ChatMsgModel] = []
    
 
    var toID = 0
    var nameTitle = ""
    //weak var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !WebSocketManager.instance.socket.isConnected {
            WebSocketManager.instance.socketReconnect()
        }
        
         WebSocketManager.instance.setOntext(onTextBlock: { [weak self] (text) in
              self?.analyzeResult(result: text)
        })
 
        self.limit = 20
        loadData()
        self.title = nameTitle
        // Do any additional setup after loading the view, typically from a nib.
        bind()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            //self?.firstSetDatas()
            self?.scrollToBottom()
        }
        
    }
    func analyzeResult(result:String){
        
        let dict = stringValueDic(result)
        let data = dict!["data"] as! [String : Any]
        
        
        let chatMode = ChatMsgModel()
        chatMode.modelType = .text
        chatMode.uid = data["uid"] as! Int
        chatMode.text = data["msn"] as? String
        let touid = data["to_uid"] as! Int
        if touid == getUserId() {
            chatMode.userType = .friend
        }else{
            chatMode.userType = .me
        }
        chatMode.fromUserId = data["nickname"] as? String
        chatMode.headImg = data["avatar"] as? String
        
        inputTextView.text = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.insertNewMessage(new: chatMode)
        }
        
    }
    func loadData(){
        let requestParams = HomeAPI.getMessageListPathAndParams(page: page, limit: limit, toUid: toID)
        getRequest(pathAndParams: requestParams,showHUD:false)
    }
    
    override func onFailure(responseCode: String, description: String, requestPath: String) {
            tableView.mj_header?.endRefreshing()
    }

    override func onResponse(requestPath: String, responseResult: JSON, methodType: HttpMethodType) {
        super.onResponse(requestPath: requestPath, responseResult: responseResult, methodType: methodType)
        tableView.mj_header?.endRefreshing()
 
        let list:[CloneMsgModel]  = getArrayFromJson(content: responseResult)
        
 
        for model in list {
            let chatMode = ChatMsgModel()
            chatMode.modelType = .text
            chatMode.uid = model.uid
            chatMode.text = model.msn
            if model.to_uid == getUserId() {
                chatMode.userType = .friend
            }else{
                chatMode.userType = .me
            }
            chatMode.fromUserId = model.nickname
            chatMode.headImg = model.avatar
            dataCloneArr.append(chatMode)
        }
        
        if page == 1{
            dataArr.append(contentsOf: dataCloneArr)
            self.heightArr = ChatMsgDataHelper.shared.getCellHeights(models: dataCloneArr)
            self.tableView?.reloadData()
            self.tableView?.layoutIfNeeded()
            self.scrollToBottom()
        }else{
            
            if list.count == 0{
                showOnlyTextHUD(text: "没有更多记录了～～")
            }
            self.tableView.mj_header?.endRefreshing()
            self.tableView?.refreshControl?.endRefreshing()
            self.insertRowModel(model: dataCloneArr, isBottom: false)
        }
       
    }
 

    func firstSetDatas() {
        let history = WeChatTools.shared.getLocalMsgs(userId: "聊天人员的 id")
        let models = ChatMsgDataHelper.shared.getFormatMsgs(nimMsgs: history)
        let newDatas = ChatMsgDataHelper.shared.addTimeModel(models: models)
        self.dataArr = newDatas
        self.heightArr = ChatMsgDataHelper.shared.getCellHeights(models: newDatas)
        self.tableView?.reloadData()
        self.tableView?.layoutIfNeeded()
    }
    
    
    @objc func refreshList() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
//            guard let `self` = self else {
//                return
//            }
//            self.tableView.mj_header?.endRefreshing()
//            self.tableView?.refreshControl?.endRefreshing()
//            self.insertRowModel(model: self.moreOldMsgs(), isBottom: false)
//        }
        dataCloneArr.removeAll()
        page = page + 1
        self.loadData()
    }
    
    @objc func reloadOldMessages() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let `self` = self else {
                return
            }
            self.tableView?.refreshControl?.endRefreshing()
            self.insertRowModel(model: self.moreOldMsgs(), isBottom: false)
        }
    }
    
    func moreOldMsgs() -> [ChatMsgModel] {
        let history = WeChatTools.shared.getLocalMsgs(userId: "聊天人员的 id")
        let models = ChatMsgDataHelper.shared.getFormatMsgs(nimMsgs: history)
        let newDatas = ChatMsgDataHelper.shared.addTimeModel(models: models)
        return newDatas.reversed()
    }
    
    
    
    
    @IBAction func sendBtnAction(_ sender: Any) {
         sendCurrentInput()
    }
    
    func bind() {
        
        tableView.delegate = self
        tableView.dataSource = self
 
        
        tableView?.register(ChatImageCell.classForCoder(), forCellReuseIdentifier: ChatImageCellID)
        tableView?.register(ChatTimeCell.classForCoder(), forCellReuseIdentifier: ChatTimeCellID)
        tableView?.register(ChatTextViewCell.classForCoder(), forCellReuseIdentifier: ChatTextViewCellID)
        tableView?.register(ChatFileCell.classForCoder(), forCellReuseIdentifier: ChatFileCellID)
        tableView?.estimatedRowHeight = 0
        tableView?.backgroundColor = ZYJColor.main
        tableView?.estimatedSectionFooterHeight = 0
        tableView?.estimatedSectionHeaderHeight = 0
 
        let addressHeadRefresh = GmmMJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(refreshList))
        tableView.mj_header = addressHeadRefresh
 
        sendBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        inputTextView.delegate = self
        inputTextView.layer.cornerRadius = 8;
        inputTextView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        inputTextView.layer.borderWidth = 1
        inputTextView.layer.masksToBounds = true
        inputTextView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        // 表情
        emotionCollectionView.delegate = self.emotionViewModel
        emotionCollectionView.dataSource = self.emotionViewModel
        emotionCollectionView.register(UINib.init(nibName: "EmotionCell", bundle: nil), forCellWithReuseIdentifier: "EmotionCell")
        self.emotionViewModel.delegate = self;
        self.emotionViewModel.weakPageControl = self.emoPageControl
        self.emoPageControl.numberOfPages = emotionViewModel.getPageControlCount()
        
        // 更多
        selectorCollectionView.delegate = self.moreSelectorViewModel
        selectorCollectionView.dataSource = self.moreSelectorViewModel
        selectorCollectionView.register(UINib.init(nibName: "MoreActionCell", bundle: nil), forCellWithReuseIdentifier: "MoreActionCell")
        
        self.moreSelectorViewModel.weakPageControl = self.selectorPageControl
        self.moreSelectorViewModel.delegate = self
        self.selectorPageControl.numberOfPages = self.moreSelectorViewModel.getPageControlCount()
    }
    



    
  
    
    func scrollToBottom(animated: Bool = false, top: Bool = false) {
        self.tableView?.layoutIfNeeded()
        if dataArr.count > 0 {
            if top {
                tableView?.scrollToRow(at: IndexPath(row: dataArr.count - 1, section: 0), at: .top, animated: animated)
            } else {
                tableView?.scrollToRow(at: IndexPath(row: dataArr.count - 1, section: 0), at: .bottom, animated: animated)
            }
        }
    }
    

    
    func insertNewMessage(new: ChatMsgModel) {
        insertRowModel(model: [new], isBottom: true)
    }
    
    func deleteMessage(row: Int) {
        if dataArr.count > row {
            dataArr.remove(at: row)
            heightArr.remove(at: row)
            tableView?.reloadData()
        }
    }
    
    // MARK: 插入模型数据
    func insertRowModel(model: [ChatMsgModel], isBottom: Bool = true) {
        if isBottom {
            let newHeights = ChatMsgDataHelper.shared.getCellHeights(models: model)
            self.heightArr.append(contentsOf: newHeights)
            for msg in model {
                dataArr.append(msg)
                let indexPath = IndexPath(row: dataArr.count - 1, section: 0)
                //                self.tableView.reloadData()
                //                self.tableView.layoutIfNeeded()
                //                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                self.insertRows([indexPath], atBottom: true)
            }
        } else {
            var oldIndexPath = IndexPath(row: model.count, section: 0)
            for msg in model {
                dataArr.insert(msg, at: 0)
                let newHeight = ChatMsgDataHelper.shared.getCellHeights(models: [msg]).first
                heightArr.insert(newHeight ?? 0, at: 0)
            }
            self.tableView?.reloadData()
            self.tableView?.layoutIfNeeded()
            if model.count > 0 {
                oldIndexPath.row = model.count - 1
                self.tableView?.scrollToRow(at: oldIndexPath, at: .top, animated: false)
            }
        }
    }
    
    fileprivate func insertRows(_ rows: [IndexPath], atBottom: Bool = true) {
        UIView.setAnimationsEnabled(false)
        self.tableView?.beginUpdates()
        self.tableView?.insertRows(at: rows, with: .none)
        self.tableView?.endUpdates()
        if atBottom {
            self.scrollToBottom()
        }
        UIView.setAnimationsEnabled(true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let model = dataArr[indexPath.row];
        if model.modelType == .text {
            let cell: ChatTextViewCell = tableView.dequeueReusableCell(withIdentifier: ChatTextViewCellID, for: indexPath) as! ChatTextViewCell
            cell.delegate = self
            cell.parentNavigationController = self.navigationController
            cell.model = dataArr[indexPath.row];
            cell.row = indexPath.row
          
            //cell.backgroundColor = ZYJColor.main
            return cell
        } else if model.modelType == .image {
            let cell: ChatImageCell = tableView.dequeueReusableCell(withIdentifier: ChatImageCellID, for: indexPath) as! ChatImageCell
            cell.model = dataArr[indexPath.row];
            cell.backgroundColor = ZYJColor.main
            return cell
        } else if model.modelType == .file {
            let cell: ChatFileCell = tableView.dequeueReusableCell(withIdentifier: ChatFileCellID, for: indexPath) as! ChatFileCell
            cell.model = dataArr[indexPath.row]
            cell.backgroundColor = ZYJColor.main
            return cell
        } else {
            let cell: ChatTimeCell = tableView.dequeueReusableCell(withIdentifier: ChatTimeCellID, for: indexPath) as! ChatTimeCell
            cell.model = dataArr[indexPath.row];
            cell.backgroundColor = ZYJColor.main
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightArr[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hideKeyboardView()
    }
    
 
    
    
    
    @objc private func handleKeyboardWillShow(notification: NSNotification) {
        //BgLineHeight.constant = 0
        UIMenuController.shared.menuItems = nil
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let value = userInfo.object(forKey: UIResponder.keyboardFrameEndUserInfoKey)
        let keyboardRec = (value as AnyObject).cgRectValue
        var safeMargin: CGFloat = 0
        if #available(iOS 11.0, *) {
            safeMargin = self.view.safeAreaInsets.bottom
        } else {
            safeMargin = self.bottomLayoutGuide.length
        }
        let height = keyboardRec?.size.height
        
        self.keyboardHeight = height ?? 0
        if let tmpH = height {
            UIView.animate(withDuration: CATransaction.animationDuration()) { [weak self] in
                guard let `self` = self else { return }
                self.bottomMargin.constant = -(tmpH - safeMargin)
                self.view.layoutIfNeeded()
                self.scrollToBottom(animated: false, top: true)
            }
        }
    }
    
    @objc private func handleKeyboardWillHide(notification: NSNotification) {
        if self.bottomMargin.constant == 0 {
            return
        }
        if self.currentKeyboardType != .noting && self.currentKeyboardType != .text {
            return
        }
        
        UIView.animate(withDuration: CATransaction.animationDuration()) { [weak self] in
            guard let `self` = self else { return }
            self.bottomMargin.constant = 0
            self.view.layoutIfNeeded()
            self.scrollToBottom(animated: true, top: false)
        }
    }
    
    func resetBarFrame() {
        if (self.currentKeyboardType == .more || self.currentKeyboardType == .emotion) && self.bottomMargin.constant != -240 {
            UIView.animate(withDuration: CATransaction.animationDuration()) { [weak self] in
                guard let `self` = self else { return }
                self.EmojiViewToTop.constant = 0
                self.MoreViewToTop.constant = 0
                
                self.bottomMargin.constant = -240
                self.view.layoutIfNeeded()
                self.scrollToBottom(animated: false, top: false)
            }
        } else if self.currentKeyboardType == .noting && self.bottomMargin.constant != 0 {
            UIView.animate(withDuration: CATransaction.animationDuration()) { [weak self] in
                guard let `self` = self else { return }
                self.bottomMargin.constant = 0
                self.EmojiViewToTop.constant = 34
                self.MoreViewToTop.constant = 34
                
                self.view.layoutIfNeeded()
                self.scrollToBottom(animated: false, top: false)
            }
        }
    }
    
    @IBAction func moreAction(_ sender: UIButton) {
        if self.currentKeyboardType != .more {
            self.currentKeyboardType = .more
            self.inputTextView.resignFirstResponder()
            sender.setImage(#imageLiteral(resourceName: "ToolViewKeyboard"), for: .normal)
            resetBarFrame()
            self.view.bringSubviewToFront(self.moreView)
        } else {
            self.currentKeyboardType = .text
            self.inputTextView.becomeFirstResponder()
            sender.setImage(#imageLiteral(resourceName: "TypeSelectorBtn_Black"), for: .normal)
            resetBarFrame()
        }
        emoBtn.setImage(#imageLiteral(resourceName: "ToolViewEmotion"), for: .normal)
    }
    
    @IBAction func emojiAction(_ sender: UIButton) {
        if self.currentKeyboardType != .emotion {
            self.currentKeyboardType = .emotion
            self.inputTextView.resignFirstResponder()
            sender.setImage(#imageLiteral(resourceName: "ToolViewKeyboard"), for: .normal)
            resetBarFrame()
            self.view.bringSubviewToFront(self.emojiView)
        } else {
            self.currentKeyboardType = .text
            self.inputTextView.becomeFirstResponder()
            sender.setImage(#imageLiteral(resourceName: "ToolViewEmotion"), for: .normal)
            resetBarFrame()
        }
        moreBtn.setImage(#imageLiteral(resourceName: "TypeSelectorBtn_Black"), for: .normal)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            refreshBarFrame()
        }
    }
    
    func refreshBarFrame() {
        var height = inputTextView.sizeThatFits(CGSize(width: inputTextView.width, height: CGFloat(Float.greatestFiniteMagnitude))).height
        height = height > kChatBarTextViewHeight ? height : kChatBarTextViewHeight
        height = height < kChatBarTextViewMaxHeight ? height : inputTextView.height
        let newHeight = height + kChatBarOriginHeight - kChatBarTextViewHeight
        
        if newHeight == self.barHeight.constant {
            return
        }
        inputTextViewCurHeight = newHeight
        UIView.animate(withDuration: CATransaction.animationDuration(), animations: {
            // 调用代理方法
            self.barHeight.constant = self.inputTextViewCurHeight
            self.view.layoutIfNeeded()
            self.scrollToBottom(animated: false, top: true)
        })
    }
    
    
    
    
    
    @IBAction func sendEmoAction(_ sender: UIButton) {
        sendCurrentInput()
    }
    
    func sendCurrentInput() {
    
        let new = ChatMsgModel()
        new.text = inputTextView.text
        new.modelType = .text
        new.userType = .me
        
        if inputTextView.text == ""{
            showOnlyTextHUD(text: "请输入内容")
            return
        }
        
        var data = Dictionary<String, AnyObject>()
        data["to_uid"] = self.toID as AnyObject
        data["msn"] = inputTextView.text as AnyObject
        data["type"] = "1" as AnyObject

        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["type"] = "chat" as AnyObject
        paramsDictionary["data"] =  data as AnyObject

        let jsonStr = dicValueString(paramsDictionary)
        //print(jsonStr!)

        WebSocketManager.instance.sendMessage(msg: jsonStr!)
 
 
    }
    
    func sendMsg(msg: ChatMsgModel) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.insertNewMessage(new: msg)
        }
    }
    
    deinit {
        inputTextView.removeObserver(self, forKeyPath: "contentSize")
    }
}

// MARK: UITextViewDelegate
extension MessageController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.currentKeyboardType == .text {
            self.currentKeyboardType = .noting
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.currentKeyboardType = .text
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        refreshBarFrame()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            //print(textView.text)
            sendCurrentInput()
            return false
        }
        //删除
        if text.count == 0 && range.length == 1 {
            // 1.特殊情况长按调用系统UIMenuController只选择一个字符串删除
            if textView.selectedRange.length == 1 {
                return true
            }
            // 获取光标位置
            let loction = textView.selectedRange.location
            // 获取光标位置前的字符串
            let frontContent = NSString(string: textView.text).substring(to: loction)
            // 字符串以结尾比较,存在“]”
            if frontContent.hasSuffix("]") {
                return !deleteBackwardEmo()
            }
        }
        return true
    }
    
    func deleteBackwardEmo() -> Bool {
        // 获取光标位置
        var oldRange = inputTextView.selectedRange
        let loction = inputTextView.selectedRange.location
        //print(loction)
        // 获取光标位置前的字符串
        let frontContent = NSString(string: inputTextView.text).substring(to: loction)
        // 字符串以结尾比较,存在“]”
        if frontContent.hasSuffix("]") {
            let lastRange = frontContent.nsRange(from: frontContent.range(of: "]", options: .backwards)!)
            if let firstRange = frontContent.range(of: "[", options: .backwards) {
                let nsrange = frontContent.nsRange(from: firstRange)
                let length = lastRange.location - nsrange.location + 1
                let targetRange = NSRange(location: nsrange.location, length: length)
                let subStr = (frontContent as NSString).substring(with: targetRange)
                //print(subStr)
                if !ChatEmotionHelper.isEmotionStr(str: subStr) {
                    return false
                }
                let range = frontContent.range(from: targetRange)
                let new = inputTextView.text.replacingOccurrences(of: subStr, with: "", options: .backwards, range: range)
                inputTextView.text = new
                oldRange.location -= targetRange.length
                oldRange.length = 0
                if oldRange.location < 0 {
                    oldRange.location = 0
                }
                inputTextView.selectedRange = oldRange
                return true
            }
        }
        return false
    }
    
}

// MARK: EmotionViewModelDelegate
extension MessageController: EmotionViewModelDelegate {
    func didSelectedEmotion(emo: ChatEmotion) {
        if emo.isEmpty {
            return
        }
        if emo.isRemove {
            if !self.deleteBackwardEmo() {
                self.inputTextView.deleteBackward()
            }
            return
        }
        guard let text = emo.text else {
            return
        }
        self.inputTextView.text.append(text)
    }
}

// MARK: MoreSelectorDelegate
extension MessageController: MoreSelectorDelegate {
    
    func chosePicture() {
        //print("选择照片")
    }
    
    func takePhoto() {
        //print("照相")
    }
    
    func sendFile() {

        let allowedUTIs = ["com.microsoft.powerpoint.​ppt",
                           "com.microsoft.word.doc",
                           "org.openxmlformats.wordprocessingml.document",
                           "com.microsoft.excel.xls",
                           "com.microsoft.powerpoint.​pptx",
                           "com.microsoft.word.docx",
                           "com.microsoft.excel.xlsx",
                           "public.avi",
                           "public.3gpp",
                           "public.mpeg-4",
                           "com.compuserve.gif",
                           "public.jpeg",
                           "public.png",
                           "public.plain-text",
                           "com.adobe.pdf",
                           "com.apple.iwork.pages.pages",
                           "com.apple.iwork.numbers.numbers",
                           "com.apple.iwork.keynote.key"
                           ]
        let documentPickerVC = UIDocumentPickerViewController(documentTypes: allowedUTIs, in: .open)
        documentPickerVC.delegate = self
        documentPickerVC.modalPresentationStyle = .formSheet
        self.present(documentPickerVC, animated: true, completion: nil)
    }
}

extension MessageController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // 获取授权
        let fileUrlAuthozied = urls.first?.startAccessingSecurityScopedResource()
        if fileUrlAuthozied == true {
            // 通过文件协调工具来得到新的文件地址，以此得到文件保护功能
            let fileCoordinator = NSFileCoordinator()
            fileCoordinator.coordinate(readingItemAt: urls.first!, options: NSFileCoordinator.ReadingOptions(rawValue: 0), error: nil) { [weak self] (newURL) in
                // 读取文件
                
                let fileName = newURL.lastPathComponent
                if let fileData = try? NSData(contentsOf: newURL, options: .mappedIfSafe) {

                    // 发送文件
                    let new = ChatMsgModel()
                    new.modelType = .file
                    new.messageObject = fileData
                    new.messageObjectFileName = fileName
                    new.userType = .me
                    if let fileSize = try? FileManager.default.attributesOfItem(atPath: newURL.path) {
                        new.fileLength = (fileSize[FileAttributeKey.size] as? Int64)!
                    }
                    self?.sendMsg(msg: new)
                    //print(fileName)
                }
            }
            urls.first?.stopAccessingSecurityScopedResource()
        } else {
            // 授权失败
        }
    }
}

// MARK: CellMenuItemActionDelegate
extension MessageController: CellMenuItemActionDelegate {

    func hideKeyboardView() {
        self.currentKeyboardType = .noting
        self.inputTextView.resignFirstResponder()
        resetBarFrame()
    }
    
    func willShowMenu(view: MyTextView, row: Int) {
        self.menuIndex = row
        if self.inputTextView.isFirstResponder {
            inputTextView.overrideNext = view
            // Observe "will hide" to do some cleanup
            // Do not use "did hide" which is not fast enough
            NotificationCenter.default.addObserver(self, selector: #selector(menuControllerWillHide), name: UIMenuController.willHideMenuNotification, object: nil)
        } else {
            view.becomeFirstResponder()
        }

        let menu = UIMenuController.shared
        let copyItem = UIMenuItem(title: "复制", action: #selector(menuItemCopyAction))
        let forwardItem = UIMenuItem(title: "转发", action: #selector(menuItemForwardAction))
        let deleteItem = UIMenuItem(title: "删除", action: #selector(menuItemDeleteAction))
        menu.menuItems = [copyItem, forwardItem, deleteItem]
        menu.setTargetRect(view.frame, in: view.superview!)
        menu.setMenuVisible(true, animated: true)
    }
    
//    func delete(msg: ChatMsgModel) {
//        //print("删除这条消息")
//    }
//
//    func zhuanfa(text: String) {
//        let sb = UIStoryboard(name: "ZhuanFaViewController", bundle: nil)
//        let nav = sb.instantiateInitialViewController() as! UINavigationController
//        let vc = nav.viewControllers.first as! ZhuanFaViewController
//        let msg = ChatMsgModel()
//        msg.text = text
//        msg.modelType = .text
//        vc.zhuanfaMsg = msg
//        self.present(nav, animated: true, completion: nil)
//    }
    
    @objc private func menuControllerWillHide() {
        inputTextView.overrideNext = nil
        // Prevent custom menu items from displaying in text view
        UIMenuController.shared.menuItems = nil
        NotificationCenter.default.removeObserver(self, name: UIMenuController.willHideMenuNotification, object: nil)
    }
    
    @objc func menuItemCopyAction() {
        //print("复制")
    }
    
    @objc func menuItemForwardAction() {

        //print("转发")
        self.currentKeyboardType = .noting
        self.view.endEditing(true)
        self.inputTextView.resignFirstResponder()
        
        guard let indexRow = self.menuIndex else {
            return
        }
        //print(indexRow)
        let sb = UIStoryboard(name: "ZhuanFaViewController", bundle: nil)
        let nav = sb.instantiateInitialViewController() as! UINavigationController
        let vc = nav.viewControllers.first as! ZhuanFaViewController
        let msg = ChatMsgModel()
        msg.text = self.dataArr[indexRow].text
        msg.modelType = .text
        vc.zhuanfaMsg = msg
        self.menuIndex = nil
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func menuItemDeleteAction() {
        //print("删除")
        self.currentKeyboardType = .noting
        self.view.endEditing(true)
        self.inputTextView.resignFirstResponder()
        
        guard let indexRow = self.menuIndex else {
            return
        }
        self.deleteMessage(row: indexRow)
        //print(indexRow)
        self.menuIndex = nil
    }
}
