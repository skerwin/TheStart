//
//  ChatMsgModel.swift
//  WeChatDemo
//
//  Created by wangxiaole on 2018/12/10.
//  Copyright © 2018年 wangxiaole. All rights reserved.
//

import UIKit

enum ChatMsgUserType: Int {
    case me
    case friend
}

enum ChatMsgModelType: Int {
    case text
    case image
    case time
    case audio
    case video
    case file
}



class ChatMsgModel: NSObject {
    var cellHeight: CGFloat = 0
    // 会话类型
    var modelType: ChatMsgModelType = .text
    // 会话来源
    var userType: ChatMsgUserType = .me
    
    // 头像
    var headImg: String?
    
    // 信息来源id
    var fromUserId: String?
    // 会话id(即当前聊天的userId)
    var sessionId: String?
    // 信息id
    var messageId: String?
    // 附件
    var messageObject: Any?
    var messageObjectFileName: String?
    // 信息时间辍
    var time: TimeInterval?
    var timeStr: String?
    
    /* ============================== 文字 ============================== */
    // 文字
    var text: String?
    /* ============================== 图片 ============================== */
    // 本地原图地址
    var imgPath: String?
    // 云信原图地址
    var imgUrl: String?
    // 本地缩略图地址
    var thumbPath: String?
    // 云信缩略图地址
    var thumbUrl: String?
    // 图片size
    var imgSize: CGSize?
    // 文件大小
    var fileLength: Int64?
    
    var showName: Bool = false
    
    
    /* ============================== 语音 ============================== */
    // 语音的本地路径
    var audioPath: String?
    // 语音的远程路径
    var audioUrl: String?
    // 语音时长，毫秒为单位
    var audioDuration: CGFloat = 0
    /* ============================== 视频 ============================== */
    // 视频展示名
    var videoDisplayName: String?
    // 视频的本地路径
    var videoPath: String?
    // 视频的远程路径
    var videoUrl: String?
    // 视频封面的远程路径
    var videoCoverUrl : String?
    // 视频封面的本地路径
    var videoCoverPath : String?
    // 封面尺寸
    var videoCoverSize: CGSize?
    // 视频时长，毫秒为单位
    var videoDuration: Int?
//

    
//    var message: ImMessageModel? {
//        didSet {
//            guard let message = message else {
//                return
//            }
//            self.text = message.message
//            userType = message.fromUserId == WeChatTools.shared.getCurrentUserId() ? .me : .friend
//            self.fromUserId = message.fromUserId
//            
//            if message.msgType == "image" {
//                self.modelType = .image
//            } else if message.msgType == "text" {
//                self.modelType = .text
//            } else {
//                self.modelType = .time
//            }
//        }
//    }
}
