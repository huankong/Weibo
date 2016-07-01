//
//  BaseViewController.swift
//  Weibo
//
//  Created by ldy on 16/6/22.
//  Copyright © 2016年 ldy. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var islogin = true
    var vistorView: VisitorView?
    override func loadView() {
        islogin ? super.loadView() : createVistorView()
    }
    private func createVistorView() {
        
        vistorView = VisitorView()
        view = vistorView
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(registerBtnAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(loginBtnAction))
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func registerBtnAction() {
        vistorView?.delegate?.registBtnDidAction()
    }
    func loginBtnAction() {
        vistorView?.delegate?.loginBtnDidAction()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
