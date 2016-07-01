//
//  Poptranstion.swift
//  Weibo
//
//  Created by ldy on 16/6/29.
//  Copyright © 2016年 ldy. All rights reserved.
//

import UIKit


class PopPresentationController: UIPresentationController {

    //展开的菜单大小
    var presentFrame = CGRectZero

    /**
     初始化方法, 用于创建负责转场动画的对象
     
     :param: presentedViewController  被展现的控制器
     :param: presentingViewController 发起的控制器, Xocde6是nil, Xcode7是野指针
     
     :returns: 负责转场动画的对象
     */
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        
    }
    
    /**
     即将布局转场子视图时调用
     */
    override func containerViewWillLayoutSubviews() {
        
        super.containerViewWillLayoutSubviews()
        //修改弹出视图的大小
        if presentFrame == CGRectZero {
            
            presentedView()?.frame = CGRect(x: 100, y: 56, width: 200, height: 200)
        }
        else {
            presentedView()?.frame = presentFrame
        }
        
        //添加蒙版,插入展示视图的下面
        containerView?.insertSubview(converView, atIndex: 0)
    }
    
    private lazy var converView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.init(white: 0.5, alpha: 0.3)
        view.frame = UIScreen.mainScreen().bounds
        
        //添加监听
        let gestRec = UITapGestureRecognizer(target: self, action: #selector(PopPresentationController.tapAction))
        view.addGestureRecognizer(gestRec)
        return view
    }()
    
    func tapAction() {
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
}

