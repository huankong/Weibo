//
//  BaseViewController.swift
//  Weibo
//
//  Created by ldy on 16/6/22.
//  Copyright © 2016年 ldy. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController,VisitorViewDelegate {

    var islogin = UserAcount.userLogin()
    var vistorView: VisitorView?
    override func loadView() {
        islogin ? super.loadView() : createVistorView()
    }
//    deinit {
//        print("BaseViewController销毁")
//    }
    private func createVistorView() {
        
        vistorView = VisitorView()
        vistorView!.delegate = self
        view = vistorView
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(registBtnDidAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(loginBtnDidAction))
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    //登录回调
    func loginBtnDidAction() {
        let navi = BaseNavigationViewController(rootViewController: Oauth2ViewController())
        self.presentViewController(navi, animated: true, completion: nil)

    }
    //注册回调
    func registBtnDidAction() {
        print(UserAcount.readAccount())
    }
    func attenBtnDidAction() {
        
    }
    
}

