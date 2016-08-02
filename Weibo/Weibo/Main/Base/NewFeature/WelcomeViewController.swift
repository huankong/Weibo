//
//  WelcomeViewController.swift
//  Weibo
//
//  Created by ldy on 16/7/7.
//  Copyright © 2016年 ldy. All rights reserved.
//

import UIKit
import SDWebImage
class WelcomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /// 初始化视图
        setupView()
    }
//    deinit {
//        print("WelcomeViewController销毁")
//    }
    /// 初始化视图
    func setupView() {
        view.addSubview(bgImgeV)
        view.addSubview(iconImageV)
        view.addSubview(textLabel)
        
        bgImgeV.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        iconImageV.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 100, height: 100))
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(-50)
        }
        textLabel.snp_makeConstraints { (make) in
            make.top.equalTo(iconImageV.snp_bottom).offset(20)
            make.centerX.equalTo(view)
        }
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //        self.iconImageV.transform = CGAffineTransformMakeScale(0,0)
        self.iconImageV.transform = CGAffineTransformMakeTranslation(0, 200)
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: UIViewAnimationOptions.init(rawValue: 0), animations: {
            self.iconImageV.transform = CGAffineTransformMakeTranslation(0, 0)
        }) { (_) in
            UIView.animateWithDuration(0.5, animations: {
                self.textLabel.alpha = 1
                }, completion: { (_) in
                    NSNotificationCenter.defaultCenter().postNotificationName(KSwiftRootViewControllerKey, object: true)
            })
        }
    }
    
    // MARK: - 懒加载
    /// 大背景图
    private lazy var bgImgeV = UIImageView(image: UIImage(named: "ad_background"))
    ///头像
    private lazy var iconImageV: UIImageView = {
        let imgV = UIImageView()
        imgV.layer.cornerRadius = 50
        imgV.layer.masksToBounds = true
        if let largeName = UserAcount.readAccount()?.avatar_large {
            imgV.sd_setImageWithURL(NSURL(string: largeName))
        }else {
            let imageName = "avatar_default_big"
            imgV.image = UIImage(named: imageName)
        }
        return imgV
    }()
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.grayColor()
        label.text = "欢迎回来"
        label.sizeToFit()
        label.alpha = 0
        return label
    }()
    
}
