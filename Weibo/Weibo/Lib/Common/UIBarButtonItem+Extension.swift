//
//  Category.swift
//  Weibo
//
//  Created by ldy on 16/6/27.
//  Copyright © 2016年 ldy. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    class func createNaviBtn(target: AnyObject?, action: Selector,imageName: String) -> UIBarButtonItem{
        let btn = UIButton(type: UIButtonType.Custom)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        return UIBarButtonItem(customView: btn)
    }
}