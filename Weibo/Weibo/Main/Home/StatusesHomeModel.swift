//
//  StatusesHomeModel.swift
//  Weibo
//
//  Created by ldy on 16/7/11.
//  Copyright © 2016年 ldy. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON
private let KWBStatusesHome = "2/statuses/home_timeline.json"
let dicParamer = ["access_token": UserAcount.readAccount()!.access_token!]
class StatusesHomeModel: NSObject {
    /// 微博创建时间
    var created_at: String? {
        didSet {
            let date = NSDate.dateWithStr(created_at!)
            created_at = date.descDate
            
        }
    }
    /// 微博ID
    var id: Int = 0
    /// 微博信息内容
    var text: String?
    /// 微博来源
    var source: String? {
        didSet {
            //"<a href=\"http:\/\/app.weibo.com\/t\/feed\/6vtZb0\" rel=\"nofollow\">微博 weibo.com<\/a>"
            if source?.characters.count > 0 {
                do {
                    
                    let pattern = ">.*<"
                    let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
                    let res = regex.matchesInString(source!, options: NSMatchingOptions.ReportProgress, range: NSRange.init(location: 0, length: source!.characters.count))
                    for checkingRes in res {
                        source = (source! as NSString).substringWithRange(checkingRes.range)
                    }
                    source?.removeAtIndex(source!.endIndex.predecessor())
                    source?.removeAtIndex(source!.startIndex)
                    source = "来自：\(source!)"
                }
                catch {
                    print(error)
                }
            }
            
        }
    }
    /// 配图数组
    var pic_urls: [[String: AnyObject]]? {
        didSet {
            thumbnailPicURLS = [NSURL]()
            for dict in pic_urls! {
                if let urlStr = dict["thumbnail_pic"] {
                    
                    thumbnailPicURLS?.append(NSURL(string: urlStr as! String)!)
                }
            }
        }
    }
    /// 配图URL数组
    var thumbnailPicURLS: [NSURL]?
    
    var user: UserModel?
    class func loadStatuses(finished: (models: [StatusesHomeModel]?, error: NSError?) -> ()) {
    
        DataServer.shareInstance().requsetData(NetMethod.GET, urlStr: KWBStatusesHome, paramer: dicParamer, success: { (response) in
            if let res = response {
                let jsonData = JSON(res)
//                print(jsonData)
                //缓存配图
                cachePicURL(dealData(jsonData), finished: finished)
                    
                
            }
            
            }) { (error) in
                finished(models: nil, error: error)
        }
    }
    private class func dealData(jsonData: JSON) -> [StatusesHomeModel] {
        let arrData = jsonData["statuses"].array
        var models = [StatusesHomeModel]()
        for dict in arrData! {
            models.append(StatusesHomeModel(dict: dict))
        }
        return models
    }
    //缓存配图
    class func cachePicURL(models: [StatusesHomeModel] ,finished: (models: [StatusesHomeModel]?, error: NSError?) -> ()) {
        //创建一个组，控制线程执行顺序
//        print("cs".cacheDir())
        let group = dispatch_group_create()
        for homeModel in models {
            //如果条件为nil ,就会执行后面的语句
            if homeModel.thumbnailPicURLS?.count == 0 {
                continue
            }
            
            
            for url in homeModel.thumbnailPicURLS! {
                //加入组
                dispatch_group_enter(group)
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions.init(rawValue: 0), progress: nil, completed: { (_, _, _, _, _) in
                    //离开组
                    dispatch_group_leave(group)
                })
            }
        }
        //group中线程执行完毕之后，才会通知这个方法执行
        dispatch_group_notify(group, dispatch_get_main_queue(), {
            //处理数据
            
            finished(models: models, error: nil)
        })
    }
    // 字典转模型
    init(dict: JSON)
    {
        super.init()
        setValuesForKeysWithDictionary(dict.dictionaryObject!)
    }
    override func setValue(value: AnyObject?, forKey key: String) {
        if "user" == key {
            user = UserModel(dict: value as! [String: AnyObject])
            return
        }
        super.setValue(value, forKey: key)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
