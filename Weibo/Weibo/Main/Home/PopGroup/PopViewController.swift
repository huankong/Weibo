//
//  PopViewController.swift
//  Weibo
//
//  Created by ldy on 16/6/29.
//  Copyright © 2016年 ldy. All rights reserved.
//

import UIKit

class PopViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var imageName = UIImage(named: "popover_background")
        imageName = imageName?.stretchableImageWithLeftCapWidth(Int(imageName!.size.width/2.0), topCapHeight: 20)
        let imgV = UIImageView(image: imageName)
        view.addSubview(imgV)
        
        imgV.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }

    

}
