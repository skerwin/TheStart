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
    
    
    
   
    
    //工种
    static let homePath = "/api/index/index"
    static func homePathAndParams() -> PathAndParams {

        let paramsDictionary = Dictionary<String, AnyObject>()
        let urlPath = generateUrlWithParams(paramsDictionary,path: homePath)
        return (urlPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
    
    //金币列表
    static let MyCoinListPath = "/api/recharge/index"
    static func MyCoinListPathAndParams() -> PathAndParams {
        
        let paramsDictionary = Dictionary<String, AnyObject>()
 
        let urlPath = generateUrlWithParams(paramsDictionary,path: MyCoinListPath)
        return (urlPath, getRequestParamsDictionary(paramsDictionary: nil))
    }
 
    //音乐列表
    static let audioListPath = "/api/audio/list"
    static func audioListPathAndParams(page:Int = 1,limit:Int = 10) -> PathAndParams {
        
        var paramsDictionary = Dictionary<String, AnyObject>()
        paramsDictionary["page"] = page as AnyObject
        paramsDictionary["limit"] = limit as AnyObject
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
    //推出登陆
 
    static let logoutPath = "/api/logout"
    static func logoutPathAndParams(phone:String,captcha:String,password:String) -> PathAndParams {

        let paramsDictionary = Dictionary<String, AnyObject>()
        let urlPath = generateUrlWithParams(paramsDictionary,path: verifyCodeKeyPath)
        return (urlPath, getRequestParamsDictionary(paramsDictionary: nil))
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