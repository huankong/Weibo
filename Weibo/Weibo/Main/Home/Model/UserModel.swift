//
//  UserModel.swift
//  Weibo
//
//  Created by ldy on 16/7/11.
//  Copyright © 2016年 ldy. All rights reserved.
//

import UIKit

class UserModel: NSObject {

     /// 昵称
    var screen_name: String?
     /// 用户ID
    var id: Int = 0
     /// 性别
    var gender: String?
    /// 粉丝数
    var followers_count: Int = 0
    /// 关注数
    var friends_count: Int = 0
    /// 微博数
    var statuses_count: Int = 0
    /// 头像地址
    var avatar_hd: String? {
        didSet {
            if let urlStr = avatar_hd {
                
                profileURL = NSURL(string: urlStr)
            }
        }
    }
    /// 头像地址URL
    var profileURL: NSURL?
    /// 是否是微博认证用户，即加V用户，true：是，false：否
    var verified: Bool = false
    /// 用户的认证类型，-1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
    var verified_type: Int = -1 {
        didSet {
            switch verified_type {
            case 2,3,5:
                verified_Image = UIImage(named: "avatar_enterprise_vip")
            case 0:
                verified_Image = UIImage(named: "avatar_vip")
            case 220:
                verified_Image = UIImage(named: "avatar_grassroot")
            default:
                verified_Image = nil
            }
        }
    }
    /// 用户的认证图片
    var verified_Image: UIImage?
    /// 会员等级
    var mbrank: Int = 0 {
        didSet {
            if mbrank > 0 && mbrank < 7 {
                mbrankImage = UIImage(named: "common_icon_membership_level" + "\(mbrank)")
            }
        }
    }
    // 会员等级图片
    var mbrankImage: UIImage?
    // 字典转模型
    init(dict: [String: AnyObject])
    {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
