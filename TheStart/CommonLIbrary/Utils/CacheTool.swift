//
//  DialogueUtils.swift
//  WisdomJapan
//
//  Created by zhaoyuanjing on 2017/09/15.
//  Copyright © 2017年 zhaoyuanjing. All rights reserved.
//

import UIKit

/**
 *  清除缓存
 */
func clearMyCache() -> Bool {
    
    var result = true
    let basePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: basePath!){
        let childrenPath = fileManager.subpaths(atPath: basePath!)
        for childPath in childrenPath!{
            let cachePath = basePath?.appending("/").appending(childPath)
            do{
                try fileManager.removeItem(atPath: cachePath!)
            }catch _{
                result = false
            }
        }
    }
    
    return result
}

class CacheTool: NSObject {
    /**
     *  计算缓存大小
     */
    static var cacheSize: String{
        get{
            let basePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
            let fileManager = FileManager.default
            
            func caculateCache() -> Float{
                var total: Float = 0
                if fileManager.fileExists(atPath: basePath!){
                    let childrenPath = fileManager.subpaths(atPath: basePath!)
                    if childrenPath != nil{
                        for path in childrenPath!{
                            let childPath = basePath!.appending("/").appending(path)
                            do{
                                let attr = try fileManager.attributesOfItem(atPath: childPath)
                                
                                let fileSize = attr[FileAttributeKey.init("NSFileSize")] as! Float
                                total += fileSize
                                
                            }catch _{
                                
                            }
                        }
                    }
                }
                
                return total
            }
            
            
            let totalCache = caculateCache()
            return NSString(format: "%.2f MB", totalCache / 1024.0 / 1024.0 ) as String
        }
    }
    
    static var clearResult: Bool{
        get{
            return clearMyCache()
        }
    }

}
//方法封装
func delay(second:TimeInterval=1.0, complete:@escaping() ->Void) {
    DispatchQueue.main.asyncAfter(deadline: .now()+second) {
        complete()
    }
}
func getAcctount() -> String {
    
    if stringForKey(key: Constants.account) != nil && stringForKey(key: Constants.account) != ""{
        return stringForKey(key: Constants.account)!
    }else{
        return ""
    }
}
func getToken() -> String {
    
    if stringForKey(key: Constants.token) != nil && stringForKey(key: Constants.token) != ""{
        return stringForKey(key: Constants.token)!
    }else{
        return ""
    }
}
func getUserId() -> Int {
    
    if intForKey(key: Constants.userid) != nil {
        return intForKey(key: Constants.userid)!
    }else{
        return 0
    }
}

func checkVip() -> Bool {
    
    if intForKey(key: Constants.isVip) != nil && intForKey(key: Constants.isVip) != 0 && intForKey(key: Constants.vipId) != nil && intForKey(key: Constants.vipId) != 0{
        return true
    }else{
        return false
    }
}

func checkMarketVer() -> Bool {
    
    if stringForKey(key: Constants.isMarketVer) != nil{
        if stringForKey(key: Constants.isMarketVer) == "1" {
            return true
        }else{
            return false
        }
    }else{
        return false
    }
}


func dicValueString(_ dic:[String : Any]) -> String?{
       let data = try? JSONSerialization.data(withJSONObject: dic, options: [])
       let str = String(data: data!, encoding: String.Encoding.utf8)
       return str
}

func stringValueDic(_ str: String) -> [String : Any]?{
    let data = str.data(using: String.Encoding.utf8)
    if let dict = try? JSONSerialization.jsonObject(with: data!,
                    options: .mutableContainers) as? [String : Any] {
        return dict
    }

    return nil
}
