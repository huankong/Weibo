//
//  NaviTitleButton.swift
//  Weibo
//
//  Created by ldy on 16/6/28.
//  Copyright © 2016年 ldy. All rights reserved.
//

import UIKit

class NaviTitleButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Selected)
        setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageEdgeInsets = UIEdgeInsets(top: 0, left: titleLabel!.frame.width, bottom: 0, right: 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageView!.frame.width*3, bottom: 0, right: 0)
    }
}
