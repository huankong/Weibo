//
//  UIButton+Extension.swift
//  Weibo
//
//  Created by ldy on 16/7/11.
//  Copyright © 2016年 ldy. All rights reserved.
//

import UIKit

extension UIButton {
    
    class func createButton(imageName: String, title: String) -> UIButton{
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setTitle(title, forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(15)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return btn
    }
}
