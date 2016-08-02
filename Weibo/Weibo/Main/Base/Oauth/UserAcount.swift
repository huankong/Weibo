//
//  UserAcount.swift
//  Weibo
//
//  Created by ldy on 16/7/6.
//  Copyright © 2016年 ldy. All rights reserved.
//

/*
 "access_token" = "2.006ViJ6DPBD33Da039f5f6cedJFW7C";
 "expires_in" = 157679999;
 "remind_in" = 157679999;
 uid = 3120122931;
 */
import UIKit

class UserAcount: NSObject, NSCoding {
    
    var access_token: String?   //用户授权的唯一票据，用于调用微博的开放接口，同时也是第三方应用验证微博用户登录的唯一票据，第三方应用应该用该票据和自己应用内的用户建立唯一影射关系，来识别登录状态，不能使用本返回值里的UID字段来做登录识别。
    /// access_token的生命周期，单位是秒数。
    var expires_in: NSNumber? {
        didSet {
            expites_Date = NSDate(timeIntervalSinceNow: expires_in!.doubleValue)
            print(expites_Date)
        }
    }
    /// 保存用户过期时间
    var expites_Date: NSDate?
    
    /// 授权用户的UID
    var uid: String?
    /// 用户头像地址
    var avatar_large: String?
    /// 用户昵称
    var screen_name: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
        //        access_token = dict["access_token"] as? String
        //        expires_in = dict["expires_in"] as? NSNumber
        //        uid = dict["uid"] as? String
    }
    //重写此方法，忽略kvc的某些键值对
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        //定义数组
        let properties = ["access_token","expires_in","uid","expites_Date","avatar_large","screen_name"]
        //根据数组，转换成字典
        let dict = dictionaryWithValuesForKeys(properties)
        return "\(dict)"
    }
    func loadUserInfo(finish: (account: UserAcount?, error: NSError?) -> ()) {
        assert(access_token != nil, "没有授权")
        
        let userPath = "2/users/show.json"
        let params = ["access_token": access_token!, "uid": uid!]
        DataServer.shareInstance().requsetData(NetMethod.GET, urlStr: userPath, paramer: params, success: { (response) in
            if response != nil {
                let dict = response as! [String: AnyObject]
                self.screen_name = dict["screen_name"] as? String
                self.avatar_large = dict["avatar_large"] as? String
                //保存用户信息
                finish(account: self, error: nil)
            }else {
                finish(account: nil, error: nil)
            }
        }) { (error) in
            finish(account: nil, error: error)
        }
    }
    
    /**
     返回用户是否登录的bool
     */
    class func userLogin() -> Bool {
        return UserAcount.readAccount() != nil
    }
    
    
    // MARK: - 保存读取 归档信息
    static let plistStr = "account.plist".cacheDir()
    func saveAccount() {
        
        NSKeyedArchiver.archiveRootObject(self, toFile: UserAcount.plistStr)
    }
    
    static var account: UserAcount?
    class func readAccount() -> UserAcount? {
        if account != nil {
            return account
        }
        account = NSKeyedUnarchiver.unarchiveObjectWithFile(UserAcount.plistStr) as? UserAcount
        //判断授权信息是否过期
        if account?.expites_Date?.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            //已经过期
            return nil
        }
        return account
    }
    
    // MARK: - NSCoding
    /**
     将对象写入到文件中
     */
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(expites_Date, forKey: "expites_Date")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
    }
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        expites_Date = aDecoder.decodeObjectForKey("expites_Date") as? NSDate
        uid = aDecoder.decodeObjectForKey("uid") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
    }
}
