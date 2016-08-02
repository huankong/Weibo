//
//  String+Extension.swift
//  Weibo
//
//  Created by ldy on 16/7/6.
//  Copyright © 2016年 ldy. All rights reserved.
//

import UIKit

extension String {
    
    func cacheDir() -> String{
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! as NSString
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    }
    func documentDir() -> String{
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! as NSString
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)

    }
    func tempDic() -> String{
        let path = NSTemporaryDirectory() as NSString
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)

    }
}
