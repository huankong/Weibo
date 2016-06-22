//
//  BaseTabBarViewController.swift
//  Weibo
//
//  Created by ldy on 16/6/22.
//  Copyright © 2016年 ldy. All rights reserved.
//

import UIKit

class BaseTabBarViewController: UITabBarController {

    override func viewWillAppear(animated: Bool) {
        for subView in tabBar.subviews {
            if subView.isKindOfClass(NSClassFromString("UITabBarButton")!) {
                subView.removeFromSuperview()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //添加控制器
        insertCtrlView()

        //创建tabBar
        createTabBar()
    }
    
    /**
     添加控制器
     */
    func insertCtrlView() {
        let homeNaviVC = BaseNavigationViewController(rootViewController: HomeViewController())
        let messageNaviVC = BaseNavigationViewController(rootViewController: MessageViewController())
        let sendNaviVC = BaseNavigationViewController(rootViewController: SendViewController())
        let discoverNaviVC = BaseNavigationViewController(rootViewController: DiscoverViewController())
        let profileNaviVC = BaseNavigationViewController(rootViewController: ProfileViewController())
        viewControllers = [homeNaviVC,messageNaviVC,sendNaviVC,discoverNaviVC,profileNaviVC]
    }
    
    /**
     创建tabbar
     */
    var lastBtn:UIButton?
    var arrImage: [String] {
        get{
    return["tabbar_home","tabbar_message_center","tabbar_compose_button","tabbar_discover","tabbar_profile"]
        }
    }
    
    func createTabBar() {
        tabBar.backgroundColor = UIColor(patternImage: UIImage(named: "tabbar_background")!)
//        let arrImage =
        let arrName = ["首页","消息","","发现","我"]
        let itemW = tabBar.frame.width/5.0
        let itemH = tabBar.frame.height
        let imageSize: CGFloat = 30;
        for i in 0..<arrImage.count {
            //添加UIButton
            let btn = UIButton(type: UIButtonType.Custom)
            btn.frame = CGRect(x: itemW*CGFloat(i), y: 0, width: itemW, height: itemH)
            btn.addTarget(self, action: #selector(btnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            btn.tag = i+100
            tabBar.addSubview(btn)
            
            //添加图片
            if i == 2 {
                let imageAddH: CGFloat = 25
                btn.setImage(UIImage(named: arrImage[i]), forState: UIControlState.Normal)
                let imageAdd = UIImageView(image: UIImage(named: "tabbar_compose_icon_add"))
                imageAdd.frame = CGRect(x: (itemW-imageAddH)/2.0, y: (itemH-imageAddH)/2.0, width: imageAddH, height: imageAddH)
                
                btn.addSubview(imageAdd)
            }
            else{
                
                let imageV = UIImageView(frame: CGRect(x: (itemW - imageSize)/2.0, y: 0, width: imageSize, height: imageSize))
                imageV.tag = i + 200
                imageV.image = UIImage(named: arrImage[i])
                btn.addSubview(imageV)
                
                let labelName = UILabel(frame: CGRect(x: CGRectGetMinX(imageV.frame), y: CGRectGetMaxY(imageV.frame)-3, width: imageSize, height: 20))
                labelName.tag = i + 300
                labelName.font = UIFont.systemFontOfSize(11)
                labelName.textAlignment = NSTextAlignment.Center
                labelName.text = arrName[i]
                btn.addSubview(labelName)
                if i == 0 {
                    imageV.image = UIImage(named: arrImage[i]+"_highlighted")
                    labelName.textColor = UIColor.orangeColor()
                    lastBtn = btn
                    selectedIndex = 0
                }
            }
        }
        
    }
    func btnAction(btn: UIButton) {
        if btn.tag-100 == 2 {
            return
        }
        
        selectedIndex = btn.tag-100
        print(btn.tag)
        print("selectedIndex:\(selectedIndex)")
        if btn == lastBtn {
            return
        }
        let imageV = btn.viewWithTag(btn.tag + 100) as! UIImageView
        imageV.image = UIImage(named: arrImage[btn.tag - 100]+"_highlighted")
        let label = btn.viewWithTag(btn.tag + 200) as! UILabel
        label.textColor = UIColor.orangeColor()
        
        let imageLast = lastBtn?.viewWithTag(lastBtn!.tag + 100) as! UIImageView
        imageLast.image = UIImage(named: arrImage[lastBtn!.tag-100])
        let labelLast = lastBtn?.viewWithTag(lastBtn!.tag + 200) as! UILabel
        labelLast.textColor = UIColor.blackColor()
        
        lastBtn = btn
        
        
    }


}
