//
//  UILabel+Extension.swift
//  Weibo
//
//  Created by ldy on 16/7/11.
//  Copyright © 2016年 ldy. All rights reserved.
//

import UIKit
extension UILabel {
    class func createLabel(textColor: UIColor, fontFloat: CGFloat) -> UILabel {
        
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(fontFloat)
        label.textColor = textColor
        return label
    }
}
