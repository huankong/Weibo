//
//  PopAnimation.swift
//  Weibo
//
//  Created by ldy on 16/6/29.
//  Copyright © 2016年 ldy. All rights reserved.
//

import UIKit

let popNotificationChange  = "popNotificationChange"

class PopAnimation: NSObject,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning {
   
    //记录是否展开
    var isPresent: Bool = false
    //展开的菜单大小
    var presentFrame = CGRectZero
    
    //MARK: - UIViewControllerTransitioningDelegate，只要实现了以下的方法，那么系统自带的默认动画就失效，需要程序员自己写
    /**
     实现代理方法, 告诉系统谁来负责转场动画
     
     - parameter presented:  被展现的控制器
     - parameter presenting: 发起的控制器
     
     - returns: 转场动画
     */
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?
    {
        
        let popPresentation = PopPresentationController(presentedViewController: presented, presentingViewController: presenting)
        popPresentation.presentFrame = presentFrame
        return popPresentation
    }
    /**
     告诉系统谁来负责Modal的展现动画
     
     - parameter presented:  被展现的视图
     - parameter presenting: 发起的视图
     - returns: 谁来负责
     */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresent = true
        NSNotificationCenter.defaultCenter().postNotificationName(popNotificationChange, object: self)
        return self
    }
    /**
     告诉系统谁开负责Modal的消失动画
     
     - parameter dismissed: 被关闭的视图
     
     - returns: 谁来负责
     */
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresent = false
        NSNotificationCenter.defaultCenter().postNotificationName(popNotificationChange, object: self)
        return self
    }


    //MARK: - UIViewControllerAnimatedTransitioning
    /**
     返回动画时长
     
     - parameter transitionContext: 上下文，里面保存了动画需要的所有参数
     
     - returns: 动画时长
     */
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        return 0.25
    }
    /**
     告诉系统如何动画，无论是展现还是消失都会调用这个方法
     
     - parameter transitionContext: 上下文，里面保存了动画需要的所有参数
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        if isPresent {
            //1.拿到展现的视图
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            toView.transform = CGAffineTransformMakeScale(1.0, 0.0)
            
            //添加到容器中
            transitionContext.containerView()?.addSubview(toView)
            
            //设置锚点
            toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            //2.执行动画
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                //2.1清空transform
                toView.transform = CGAffineTransformIdentity
            }) { (_) in
                //2.2动画执行完毕，一定要告诉系统
                //必须写,否则可能导致一些未知错误
                transitionContext.completeTransition(true)
            }
        }
        else {
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                //注意：由于CGFloat 是不准确的，所有如果写0.0会没有动画
                //压扁
                fromView?.transform = CGAffineTransformMakeScale(1.0, 0.00001)
                
                }, completion: { (_) in
                    transitionContext.completeTransition(true)
            })
        }
    }
}