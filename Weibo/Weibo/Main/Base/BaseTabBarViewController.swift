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
        super.viewWillAppear(animated)
        for subView in tabBar.subviews {
            if subView.isKindOfClass(NSClassFromString("UITabBarButton")!) {
                subView.removeFromSuperview()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //动态添加数据
        addData()
        
        //添加控制器
        insertCtrlView()
        
        //创建tabBar
        createTabBar()
        
    }
    
    private var lastBtn:UIButton?
    private var arrImage: [String] = []
    private var arrName: [String] = []
    private var arrVC: [String] = []
//    deinit {
//        print("BaseTabBarViewController销毁")
//    }
    /**
     动态添加数据
     */
    private func addData() {
        let path = NSBundle.mainBundle().pathForResource("VCSettings.json", ofType: nil)
        if let jsonPath = path {
            
            let dataJson = NSData(contentsOfFile: jsonPath)
            do {
                
                let jsonArr = try NSJSONSerialization.JSONObjectWithData(dataJson!, options: NSJSONReadingOptions.MutableContainers)
                for dict in jsonArr as! [[String: String]] {
                    arrImage.append(dict["imageName"]!)
                    arrName.append(dict["title"]!)
                    arrVC.append(dict["vcName"]!)
                }
            }
            catch{
                print(error)
            }
        }
    }
    
    /**
     添加控制器
     */
    private func insertCtrlView() {
        for strVC in arrVC {
            let bundleName = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
            
            let viewCtrl = NSClassFromString(bundleName + "." + strVC) as! BaseViewController.Type
            let homeNaviVC = BaseNavigationViewController(rootViewController: viewCtrl.init())
            addChildViewController(homeNaviVC)
        }
        
        /*
         let homeNaviVC = BaseNavigationViewController(rootViewController: HomeViewController())
         let messageNaviVC = BaseNavigationViewController(rootViewController: MessageViewController())
         let sendNaviVC = BaseNavigationViewController(rootViewController: SendViewController())
         let discoverNaviVC = BaseNavigationViewController(rootViewController: DiscoverViewController())
         let profileNaviVC = BaseNavigationViewController(rootViewController: ProfileViewController())
         viewControllers = [homeNaviVC,messageNaviVC,sendNaviVC,discoverNaviVC,profileNaviVC]
         */
    }
    
    /**
     创建tabbar
     */
    private func createTabBar() {
        tabBar.backgroundColor = UIColor(patternImage: UIImage(named: "tabbar_background")!)
        
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
    /**
     tabbarbtn 点击事件
     
     - parameter btn: 按钮
     */
    func btnAction(btn: UIButton) {
        if btn.tag-100 == 2 {
            return
        }
        
        selectedIndex = btn.tag-100
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
