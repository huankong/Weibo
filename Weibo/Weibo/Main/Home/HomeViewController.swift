//
//  HomeViewController.swift
//  Weibo
//
//  Created by ldy on 16/6/22.
//  Copyright © 2016年 ldy. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    //移除通知
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if !islogin {
            
            vistorView?.visitorInfo(VisitorView.VisitorType.IsHome)
            return
        }
        
        //初始化导航栏按钮
        createNav()
        //添加通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.notificationAction), name: popNotificationChange, object: nil)
        
    }
    /**
     初始化导航栏按钮
     */
    func createNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.createNaviBtn(self, action: #selector(HomeViewController.rightNavAction), imageName: "navigationbar_pop")
        navigationItem.leftBarButtonItem = UIBarButtonItem.createNaviBtn(self, action: #selector(HomeViewController.leftNavAction), imageName: "navigationbar_friendattention")
        
        let btn = NaviTitleButton(type: UIButtonType.Custom)
        btn.setTitle("幻空缥缈", forState: UIControlState.Normal)
         btn.addTarget(self, action: #selector(HomeViewController.titleBtnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = btn
        
    }
    //MARK:  -导航栏按钮点击事件
    func rightNavAction() {
        let qrCode = QRCodeViewController()
        let baseNavi = BaseNavigationViewController(rootViewController: qrCode)
        qrCode.hidesBottomBarWhenPushed = true
        self.presentViewController(baseNavi, animated: true, completion: nil)
    }
    func leftNavAction() {
        print(#function)
    }
    func titleBtnAction(btn: UIButton) {
        
        
        let popVC = PopViewController()
        popVC.transitioningDelegate = popAnimation
        popVC.modalPresentationStyle = UIModalPresentationStyle.Custom
        presentViewController(popVC, animated: true, completion: nil)
        
    }
    //通知接收方法
    func notificationAction() {
        let btn = navigationItem.titleView as! UIButton
        btn.selected = !btn.selected
        
    }
    //MARK: -懒加载
    private lazy var popAnimation: PopAnimation = {
        let pop = PopAnimation()
        pop.presentFrame = CGRect(x: 100, y: 56, width: 200, height: 200)
        return pop
    }()
}
