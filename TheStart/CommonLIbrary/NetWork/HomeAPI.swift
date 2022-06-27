//
//  HomeAPI.swift
//  BossJob
//
//  Created by zhaoyuanjing on 2017/12/01.
//  Copyright © 2017年 zhaoyuanjing. All rights reserved.
//

import Foundation

struct HomeAPI {
 
    
    //    ************************登录注册************************
    
    
    static let imageUpLoadUrl       = "/api/upload/image"
    
    
    static let privacyUserAgreementPath = "/api/danye/"
    static func privacyUserAgreementPathAndParam(id:Int) -> PathAndParams {

        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
 
        let urlPath = URLs.getHostAddress() + privacyUserAgreementPath + "\(id)"
        return (urlPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    static let openMarketPath = "/api/goods/if_goods"
    static func openMarketPathAndParam() -> PathAndParams {
         return (openMarketPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
 
 
   
    static let userinfoPath = "/api/userinfo"
    static func userinfoPathAndParam() -> PathAndParams {
 
        let urlPath = URLs.getHostAddress() + userinfoPath
        return (urlPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    static let logoutPath = "/api/logout"
    static func logoutPathAndParam() -> PathAndParams {
 
        let urlPath = URLs.getHostAddress() + logoutPath
        return (urlPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
 
    
    //工种
    static let homePath = "/api/index/index"
    static func homePathAndParams() -> PathAndParams {

        let paramsDictionary = Dictionary<String, AnyObject>()
        let urlPath = generateUrlWithParams(paramsDictionary,path: homePath)
        return (urlPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    //列表
    static let MyCoinListPath = "/api/recharge/index"
    static func MyCoinListPathAndParams() -> PathAndParams {
        
        let paramsDictionary = Dictionary<String, AnyObject>()
 
        let urlPath = generateUrlWithParams(paramsDictionary,path: MyCoinListPath)
        return (urlPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
 
    //音乐列表
    static let audioListPath = "/api/audio/list"
    static func audioListPathAndParams(page:Int = 1,limit:Int = 10,vip_free:Int) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["page"] = page as AnyObject
        paramsDictionary["limit"] = limit as AnyObject
        paramsDictionary["vip_free"] = vip_free as AnyObject
        let urlPath = generateUrlWithParams(paramsDictionary,path: audioListPath)
        return (urlPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    //作者列表
    static let authorListPath = "/api/audio/author"
    static func authorListPathAndParams(page:Int = 1,limit:Int = 10) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["page"] = page as AnyObject
        paramsDictionary["limit"] = limit as AnyObject
        return (authorListPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    //作者详情
    static let authorDetailPath = "/api/audio/author_info"
    static func authorDetailPathAndParams(id:Int) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["uid"] = id as AnyObject
        return (authorDetailPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    //作者收藏取消
    static let authorCollectionPath = "/api/user/musician_collection"
    static func authorCollectionPathAndParams(musician_id:Int) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["musician_id"] = musician_id as AnyObject
        return (authorCollectionPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //作者收藏列表
    static let UserAuthorDetailPath = "/api/user/musician_list"
    static func UserAuthorDetailPathAndParams(page:Int = 1,limit:Int = 10) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["page"] = page as AnyObject
        paramsDictionary["limit"] = limit as AnyObject
        return (UserAuthorDetailPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    
    //音乐tianjia
    static let audioPubPath = "/api/audio/add"
    static func audioPubPathAndParams(model:AudioModel) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["name"] = model.name as AnyObject
        paramsDictionary["price"] = model.price as AnyObject
        paramsDictionary["link"] = model.link as AnyObject
        paramsDictionary["code"] = model.code as AnyObject
        paramsDictionary["info"] = model.info as AnyObject
        paramsDictionary["audio_path"] = model.audio_path as AnyObject
        paramsDictionary["images"] = model.imagesUrl as AnyObject
        paramsDictionary["image"] = model.image as AnyObject
        paramsDictionary["vip_free"] = model.vip_free as AnyObject
        return (audioPubPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    //黑人/澄清添加
    static let addTipOffPath = "/api/article/add"
    static func addTipOffPathAndParams(model:TipOffModel) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["type"] = model.type as AnyObject
        paramsDictionary["title"] = model.title as AnyObject
        paramsDictionary["address"] = model.address as AnyObject
        paramsDictionary["content"] = model.content as AnyObject
        paramsDictionary["image_input"] = model.upLoadImg as AnyObject
        if model.type == 3{
            paramsDictionary["clarify_id"] = model.clarify_id as AnyObject
        }
        return (addTipOffPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //澄清
    static let clarifyListPath = "/api/article/clarify_list"
    static func clarifyListPathAndParams(clarify_id:Int,page:Int = 1,limit:Int = 10) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["clarify_id"] = clarify_id as AnyObject
        paramsDictionary["page"] = page as AnyObject
        paramsDictionary["limit"] = limit as AnyObject
        return (clarifyListPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //黑人/澄清列表
    static let tipOffListPath = "/api/article/list"
    static func tipOffListPathAndParams(type:Int,page:Int = 1,limit:Int = 10) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["type"] = type as AnyObject
        paramsDictionary["page"] = page as AnyObject
        paramsDictionary["limit"] = limit as AnyObject
        
        let urlPath = generateUrlWithParams(paramsDictionary,path: tipOffListPath)
        return (urlPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    //黑人/澄清详情
    static let tipOffDetailsPath = "/api/article/details/"
    static func tipOffListPathAndParams(id:Int) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
 
        let urlPath = URLs.getHostAddress() + tipOffDetailsPath + "\(id)"
        return (urlPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    //找人找厂列表
    static let workAddPath = "/api/work/add"
    static func workAddPathAndParams(model:JobModel) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["type"] = model.type as AnyObject
        paramsDictionary["title"] = model.title as AnyObject
        paramsDictionary["city"] = model.city as AnyObject
        paramsDictionary["address"] = model.address as AnyObject
        paramsDictionary["cate_id"] = model.cate_id as AnyObject
        paramsDictionary["salary"] = model.salary as AnyObject
        paramsDictionary["phone"] = model.phone as AnyObject
        paramsDictionary["mobile"] = model.mobile as AnyObject
        paramsDictionary["wechat"] = model.wechat as AnyObject
        paramsDictionary["detail"] = model.detail as AnyObject
        paramsDictionary["images"] = model.imagesURL as AnyObject
        paramsDictionary["name"] = model.name as AnyObject
        paramsDictionary["gender"] = model.gender as AnyObject
        paramsDictionary["video"] = model.videoURL as AnyObject
        return (workAddPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //找人找厂详情
    static let workDetailPath = "/api/work/details/"
    static func workDetailPathAndParams(id:Int) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
 
        let urlPath = URLs.getHostAddress() + workDetailPath + "\(id)"
        return (urlPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    //找人找厂收藏
    static let workCollectPath = "/api/work/collect/add"
    static func workCollectPathAndParams(id:Int) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
 
         return (workCollectPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    //找人找厂取消收藏
    static let delWorkCollectPath = "/api/work/collect/del"
    static func delWorkCollectPathAndParams(id:Int) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
 
         return (delWorkCollectPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    //打电话控制接口
    static let userCallPath = "/api/user/user_call"
    static func userCallPathAndParams(type:Int) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["type"] = type as AnyObject
 
        return (userCallPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //聊一聊控制
    
    static let userImPathPath = "/api/user/user_im"
    static func userImPathPathAndParams(type:Int,to_uid:Int) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["type"] = type as AnyObject
        paramsDictionary["to_uid"] = type as AnyObject
 
        return (userImPathPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    //音乐收藏
    static let audioCollectPath = "/api/audio/collect/add"
    static func audioCollectPathAndParams(id:Int) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
 
        return (audioCollectPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    //音乐取消收藏
    static let delAudioCollectPath = "/api/audio/collect/del"
    static func delAudioCollectPathAndParams(id:Int) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
 
         return (delAudioCollectPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
 
    
    //音乐详情
    static let audioDetailPath = "/api/audio/details/"
    static func audioDetailPathAndParams(id:Int) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
 
        let urlPath = URLs.getHostAddress() + audioDetailPath + "\(id)"
        return (urlPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    //添加评论
    static let addComentPath = "/api/article/comment"
    static func addComentPathAndParams(model:CommentModel) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["article_id"] = model.article_id as AnyObject
        paramsDictionary["comment"] = model.comment as AnyObject
        paramsDictionary["rid"] = model.rid as AnyObject
        return (addComentPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    //评论列表
    static let comentListPath = "/api/article/comment_list/"
    static func comentListPathAndParams(articleId:Int,page:Int = 1,limit:Int = 10,order:String = "add_time") -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["page"] = page as AnyObject
        paramsDictionary["limit"] = limit as AnyObject
        paramsDictionary["order"] = order as AnyObject
 
        var urlPath = comentListPath + "\(articleId)"
        urlPath = generateUrlWithParams(paramsDictionary,path: urlPath)
        return (urlPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    //jubao
    static let reportPath = "/api/article/report"
    static func reportPathAndParams(articleId:Int,type:Int = 1,reason:String = "",remark:String) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["article_id"] = articleId as AnyObject
        paramsDictionary["type"] = type as AnyObject
        paramsDictionary["reason"] = reason as AnyObject
        paramsDictionary["remark"] = "我要投诉" as AnyObject
        return (reportPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //dianzan
    
    static let collectAddPath = "/api/article/collect/add"
    static func collectAddPathAndParams(articleId:Int) -> PathAndParams {

        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = articleId as AnyObject
    
        return (collectAddPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //取消点赞
    static let collectDelPath = "/api/article/collect/del"
    static func collectDelPathAndParams(articleId:Int) -> PathAndParams {

        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = articleId as AnyObject
        return (collectDelPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    //工种
    static let workCategoryPath = "/api/work/category/list"
    static func workCategoryPathAndParams() -> PathAndParams {

        let paramsDictionary = Dictionary<String, AnyObject>()
        let urlPath = generateUrlWithParams(paramsDictionary,path: workCategoryPath)
        return (urlPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    
    //工资
    static let salaryPath = "/api/salary"
    static func salaryPathAndParams() -> PathAndParams {

        let paramsDictionary = Dictionary<String, AnyObject>()
        let urlPath = generateUrlWithParams(paramsDictionary,path: salaryPath)
        return (urlPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
 
    //工资
    static let jobAndWorkerPath = "/api/work/list"
    static func jobAndWorkerPathAndParams(type:Int,cate_id:Int,salary:Int,page:Int = 1,limit:Int = 10,city:String,keyword:String = "",gender:String = "") -> PathAndParams {

        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["type"] = type as AnyObject
        
        paramsDictionary["page"] = page as AnyObject
        paramsDictionary["limit"] = limit as AnyObject
        
        
        if cate_id != 0{
            paramsDictionary["cate_id"] = cate_id as AnyObject
        }
        if salary != 0{
            paramsDictionary["salary"] = salary as AnyObject
        }
        if city != ""{
            paramsDictionary["city"] = city as AnyObject
        }
        if keyword != ""{
            paramsDictionary["keyword"] = keyword as AnyObject
        }
        if gender != ""{
            paramsDictionary["gender"] = gender as AnyObject
        }
        
        
        let urlPath = generateUrlWithParams(paramsDictionary,path: jobAndWorkerPath)
        return (urlPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
 
    
    //注册
    static let registerAccoountPath = "/api/register"
    static func registerAccoountPathAndParams(phone:String,captcha:String,password:String,confirm_pwd:String,nickname:String) -> PathAndParams {

        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["phone"] = phone as AnyObject
        paramsDictionary["captcha"] = captcha as AnyObject
        paramsDictionary["password"] = password as AnyObject
        paramsDictionary["confirm_pwd"] = confirm_pwd as AnyObject
        if nickname != ""{
            paramsDictionary["nickname"] = nickname as AnyObject
        }
        return (registerAccoountPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    //验证码key
    static let verifyCodeKeyPath = "/api/verify_code"
    static func verifyCodeKeyPathAndParams() -> PathAndParams {
        let paramsDictionary = Dictionary<String, AnyObject>()
        let urlPath = generateUrlWithParams(paramsDictionary,path: verifyCodeKeyPath)
        return (urlPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    //验证码
    static let getVerifyCodePath = "/api/register/verify"
    static func getVerifyCodePathAndParams(phone:String,type:String,key:String) -> PathAndParams {

        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["phone"] = phone as AnyObject
        paramsDictionary["type"] = type as AnyObject
 
        paramsDictionary["key"] = key as AnyObject
        return (getVerifyCodePath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //验证码登陆
    static let verifyCodeLoginPath = "/api/login/mobile"
    static func verifyCodeLoginPathAndParams(phone:String,captcha:String) -> PathAndParams {

        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["phone"] = phone as AnyObject
        paramsDictionary["captcha"] = captcha as AnyObject
         return (verifyCodeLoginPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //账号密码登陆
 
    static let acountCodeLoginPath = "/api/login"
    static func acountCodeLoginPathAndParams(account:String,password:String) -> PathAndParams {

        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["account"] = account as AnyObject
        paramsDictionary["password"] = password as AnyObject
         return (acountCodeLoginPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //重置密码
 
    static let resetPwdPath = "/api/register/reset"
    static func resetPwdPathAndParams(phone:String,captcha:String,password:String) -> PathAndParams {

        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["phone"] = phone as AnyObject
        paramsDictionary["captcha"] = captcha as AnyObject
        paramsDictionary["password"] = password as AnyObject
        paramsDictionary["confirm_pwd"] = password as AnyObject
         return (resetPwdPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
 
    
    //我的厂招人列表
    static let myJobWorkerListPath = "/api/work/index"
    static func myJobWorkerListPathAndParams(type:Int,page:Int = 1,limit:Int = 10) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["type"] = type as AnyObject
        paramsDictionary["page"] = page as AnyObject
        paramsDictionary["limit"] = limit as AnyObject
   
         let urlPath = generateUrlWithParams(paramsDictionary,path: myJobWorkerListPath)
         return (urlPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    //我的收藏厂招人列表
    static let collectJobWorkerListPath = "/api/work/collect/user"
    static func collectJobWorkerListPathAndParams(type:Int,page:Int = 1,limit:Int = 10) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["type"] = type as AnyObject
        paramsDictionary["page"] = page as AnyObject
        paramsDictionary["limit"] = limit as AnyObject
   
         let urlPath = generateUrlWithParams(paramsDictionary,path: collectJobWorkerListPath)
         return (urlPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    //我的收藏音乐
    static let collectaudioListPath = "/api/audio/collect/user"
    static func collectaudioListPathAndParams(page:Int = 1,limit:Int = 10) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["page"] = page as AnyObject
        paramsDictionary["limit"] = limit as AnyObject
   
         let urlPath = generateUrlWithParams(paramsDictionary,path: collectaudioListPath)
         return (urlPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    
    //下线
    static let showMyJobWorkerPath = "/api/work/set/show"
    static func ShowMyJobWorkerPathAndParams(dateID:Int,status:Int) -> PathAndParams {

        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = dateID as AnyObject
        paramsDictionary["status"] = status as AnyObject
         return (showMyJobWorkerPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    //删除
    static let delMyJobWorkerPath = "/api/work/del"
    static func delMyJobWorkerPathAndParams(dateID:Int) -> PathAndParams {

        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = dateID as AnyObject
         return (delMyJobWorkerPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    //我的黑人发布
    static let myArticleListPath = "/api/article/article/list"
    static func myArticleListPathAndParams(page:Int = 1,limit:Int = 10) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["page"] = page as AnyObject
        paramsDictionary["limit"] = limit as AnyObject
   
         let urlPath = generateUrlWithParams(paramsDictionary,path: myArticleListPath)
         return (urlPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    //我的音乐发布
    static let myaudioListPath = "/api/audio/index"
    static func myaudioListPathAndParams(page:Int = 1,limit:Int = 15) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["page"] = page as AnyObject
        paramsDictionary["limit"] = limit as AnyObject
   
         let urlPath = generateUrlWithParams(paramsDictionary,path: myaudioListPath)
         return (urlPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    //购买音乐
    static let buyAudioListPath = "/api/audio/create"
    static func buyAudioListPathAndParams(id:Int) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
   
        return (buyAudioListPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //会员免费购买音乐
    static let buyAudioFreeListPath = "/api/audio/free"
    static func buyAudioFreeListPathAndParams(id:Int) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
   
        return (buyAudioFreeListPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
  
    
    //编辑个人信息
    static let userEditPath = "/api/user/edit"
    static func userEditPathAndParams(model:UserModel) -> PathAndParams {

        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["nickname"] = model.nickname as AnyObject
        paramsDictionary["pone"] = model.phone as AnyObject
        paramsDictionary["avatar"] = model.avatar as AnyObject
        paramsDictionary["address"] = model.addres as AnyObject
        
        return (userEditPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    //银行信息提交
    static let bankInfoPath = "/api/user/extract"
    static func bankInfoPathAndParams(model:UserModel) -> PathAndParams {

        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["bank_name"] = model.bank_name as AnyObject
        paramsDictionary["bank_realname"] = model.bank_realname as AnyObject
        paramsDictionary["bank_code"] = model.bank_code as AnyObject
 
        return (bankInfoPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //申请
    static let bankOutCashPath = "/api/user/cash"
    static func bankOutCashPathAndParams(extract_price:Float) -> PathAndParams {

        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["extract_price"] = extract_price as AnyObject
   
 
        return (bankOutCashPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //记录
    static let bankOutListPath = "/api/user/cash_list"
    static func bankOutListPathAndParams(page:Int = 1,limit:Int = 10) -> PathAndParams {

        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["page"] = page as AnyObject
        paramsDictionary["limit"] = limit as AnyObject
 
        return (bankOutListPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //提交实名认证
    static let shimingSumbitPath = "/api/user/shiming"
    static func shimingSumbitPathAndParams(model:UserModel) -> PathAndParams {

        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["real_name"] = model.real_name as AnyObject
        paramsDictionary["card_id"] = model.card_id as AnyObject
        paramsDictionary["gender"] = model.gender as AnyObject
        paramsDictionary["phone"] = model.phone as AnyObject
        
        paramsDictionary["birthday"] = model.birthday as AnyObject
        paramsDictionary["shiming_work"] = model.shiming_work as AnyObject
        paramsDictionary["address"] = model.address as AnyObject
        paramsDictionary["shiming_company"] = model.shiming_company as AnyObject
        
         return (shimingSumbitPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //音乐人认证
    static let audioUserSumbitPath = "/api/user/audio"
    static func audioUserSumbitPathAndParams(model:UserModel) -> PathAndParams {

        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["logo"] = model.logo as AnyObject
        paramsDictionary["video_type"] = model.video_type as AnyObject
        paramsDictionary["video_path"] = model.video_path as AnyObject
        paramsDictionary["images"] = model.imagesUrl as AnyObject
        paramsDictionary["introduce"] = model.introduce as AnyObject
        
         return (audioUserSumbitPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //开通会员
    static let openVipPath = "/api/user/vip"
    static func openVipPathAndParams(pay_type:String,level_id:Int,price:String) -> PathAndParams {

        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["price"] = price as AnyObject
        paramsDictionary["pay_type"] = pay_type as AnyObject
        paramsDictionary["level_id"] = level_id as AnyObject
        return (openVipPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //下单微信
    static let wechatPayPath = "/api/recharge/wechat"
    static func wechatPayPathAndParams(price:String,leixing:Int) -> PathAndParams {

        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["price"] = price as AnyObject
        paramsDictionary["leixing"] = leixing as AnyObject
 
        return (wechatPayPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //下单支付宝
    static let aliPayPath = "/api/recharge/alipay"
    static func aliPayPathPathAndParams(price:String,leixing:Int) -> PathAndParams {

        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["price"] = price as AnyObject
        paramsDictionary["leixing"] = leixing as AnyObject
 
        return (aliPayPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //开通会员
    static let buyVipPath = "/api/user/vip"
    static func buyVipPathAndParams(level_id:Int,pay_type:String,price:String) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["level_id"] = level_id as AnyObject
        paramsDictionary["pay_type"] = pay_type as AnyObject
        paramsDictionary["price"] = price as AnyObject
   
        return (buyVipPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //订单列表
   static let orderListPath = "/api/order/order_list"
   static func orderListPathAndParams(type:Int,order_type:Int,page:Int = 1,limit:Int = 10) -> PathAndParams {

       var paramsDictionary = Dictionary<String, AnyObject>()
       paramsDictionary["type"] = type as AnyObject
       paramsDictionary["order_type"] = order_type as AnyObject
       paramsDictionary["page"] = page as AnyObject
       paramsDictionary["limit"] = limit as AnyObject
       
       return (orderListPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
   }
    
    //订单列表
   static let myAudioOrderPath = "/api/order/my_audio_order"
   static func myAudioOrderPathAndParams(page:Int = 1,limit:Int = 10) -> PathAndParams {

       var paramsDictionary = Dictionary<String, AnyObject>()
       paramsDictionary["page"] = page as AnyObject
       paramsDictionary["limit"] = limit as AnyObject
       
       return (myAudioOrderPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
   }
   
    
      //聊天列表
    static let getContactListPath = "/api/user/service/news_list"
    static func getContactListPathAndParams(keyword:String,page:Int = 1,limit:Int = 10) -> PathAndParams {

 
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["page"] = page as AnyObject
        paramsDictionary["limit"] = limit as AnyObject
        if keyword != ""{
            paramsDictionary["keyword"] = keyword as AnyObject
        }
            
       
   
         let urlPath = generateUrlWithParams(paramsDictionary,path: getContactListPath)
 
         return (urlPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    
    //聊天消息
    static let getMessageListPath = "/api/user/service/record/"
    static func getMessageListPathAndParams(page:Int = 1,limit:Int = 10,toUid:Int) -> PathAndParams {

        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["page"] = page as AnyObject
        paramsDictionary["limit"] = limit as AnyObject
        let temp = getMessageListPath + "\(toUid)"
        let urlPath = generateUrlWithParams(paramsDictionary,path: temp)
        return (urlPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    //商品列表
    static let goodsListPath = "/api/goods/goods_list"
    static func goodsListPathAndParams(page:Int = 1,limit:Int = 10) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["page"] = page as AnyObject
        paramsDictionary["limit"] = limit as AnyObject
   
         return (goodsListPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    //商品详情
    static let goodsInfoPath = "/api/goods/goods_info"
    static func goodsInfoPathAndParams(id:Int) -> PathAndParams {
        
          var paramsDictionary = Dictionary<String, AnyObject>()
          paramsDictionary["id"] = id as AnyObject
   
          return (goodsInfoPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //商品下单
    static let orderAddPath = "/api/goods/order_add"
    static func orderAddPathAndParams(goods_id:Int,address_id:Int,pay_type:Int) -> PathAndParams {
        
          var paramsDictionary = Dictionary<String, AnyObject>()
          paramsDictionary["goods_id"] = goods_id as AnyObject
          paramsDictionary["address_id"] = address_id as AnyObject
          paramsDictionary["pay_type"] = pay_type as AnyObject
   
          return (orderAddPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    
    
    //商品订单列表
    static let goodsOrderListPath = "/api/goods/order_list"
    static func goodsOrderListPathAndParams(order_status:Int,page:Int = 1,limit:Int = 10) -> PathAndParams {
        
          var paramsDictionary = Dictionary<String, AnyObject>()
          paramsDictionary["order_status"] = order_status as AnyObject
          paramsDictionary["page"] = page as AnyObject
          paramsDictionary["limit"] = limit as AnyObject
   
          return (goodsOrderListPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
 
    //商品订单详情
    static let goodsOrderDetailPath = "/api/goods/order_info"
    static func goodsOrderDetailPathAndParams(id:Int) -> PathAndParams {
        
          var paramsDictionary = Dictionary<String, AnyObject>()
          paramsDictionary["id"] = id as AnyObject
          return (goodsOrderDetailPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //商品订单取消
    static let goodsOrderCanclePath = "/api/goods/order_cancel"
    static func goodsOrderCanclePathAndParams(id:Int) -> PathAndParams {
        
          var paramsDictionary = Dictionary<String, AnyObject>()
          paramsDictionary["id"] = id as AnyObject
          return (goodsOrderCanclePath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    //商品订单继续支付
    static let goodsOrderNextPayPath = "/api/goods/order_pay"
    static func goodsOrderNextPayPathAndParams(id:Int) -> PathAndParams {
        
          var paramsDictionary = Dictionary<String, AnyObject>()
          paramsDictionary["id"] = id as AnyObject
          return (goodsOrderNextPayPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    
    //收获地址列表
    static let addressListPath = "/api/goods/address_list"
    static func addressListPathAndParams() -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        return (addressListPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }

    //收获地址详情
    static let addressInfoPath = "/api/goods/address_info"
    static func addressInfoPathAndParams(id:Int) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
        return (addressInfoPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
 
    //收获地址添加
    static let addressAddPath = "/api/goods/address_add"
    static func addressAddPathAndParams(model:AddressModel) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["real_name"] = model.real_name as AnyObject
        paramsDictionary["phone"] = model.phone as AnyObject
        paramsDictionary["province"] = model.province as AnyObject
        paramsDictionary["city"] = model.city as AnyObject
        paramsDictionary["district"] = model.district as AnyObject
        
        paramsDictionary["detail"] = model.detail as AnyObject
        paramsDictionary["post_code"] = model.post_code as AnyObject
        paramsDictionary["is_default"] = model.is_default as AnyObject
        //print(paramsDictionary)
         return (addressAddPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }

    //收获地址编辑
    static let addressEditPath = "/api/goods/address_edit"
    static func addressEditPathAndParams(model:AddressModel) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["real_name"] = model.real_name as AnyObject
        paramsDictionary["phone"] = model.phone as AnyObject
        paramsDictionary["province"] = model.province as AnyObject
        paramsDictionary["city"] = model.city as AnyObject
        paramsDictionary["district"] = model.district as AnyObject
        
        paramsDictionary["detail"] = model.detail as AnyObject
        paramsDictionary["post_code"] = model.post_code as AnyObject
        paramsDictionary["is_default"] = model.is_default as AnyObject
        
        
        paramsDictionary["id"] = model.id as AnyObject
        return (addressEditPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    
    //删除文章
    static let articleDelPath = "/api/article/del"
    static func articleDelPathAndParams(id:Int) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
        return (articleDelPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    
    //删除音乐
    static let audioDelPath = "/api/audio/audio_del"
    static func audioDelPathAndParams(id:Int) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
        return (audioDelPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }
    //删除招人招场
    static let workDelPath = "/api/work/del"
    static func workDelPathAndParams(id:Int) -> PathAndParams {
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["id"] = id as AnyObject
        return (workDelPath, getRequestParamsDictionary(paramsDictionary: paramsDictionary))
    }

    static let testPath = "/api/work/list"
    static func testPathAndParams() -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["type"] = 1 as AnyObject
        paramsDictionary["page"] = 1 as AnyObject
        paramsDictionary["limit"] = 10 as AnyObject
        paramsDictionary["gender"] = "女" as AnyObject
        paramsDictionary["cate_id"] = 1 as AnyObject
        
        let urlPath = generateUrlWithParams(paramsDictionary,path: testPath)
 
        return (urlPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
}
