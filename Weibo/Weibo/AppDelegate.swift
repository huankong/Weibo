//
//  AppDelegate.swift
//  Weibo
//
//  Created by ldy on 16/6/22.
//  Copyright © 2016年 ldy. All rights reserved.
//

import UIKit
import SDWebImage
//切换控制器通知
let KSwiftRootViewControllerKey = "KSwiftRootViewControllerKey"
let KScreenH = UIScreen.mainScreen().bounds.size.height
let KScreenW = UIScreen.mainScreen().bounds.size.width
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        /**
         创建window
         */
        initWindow()
        window?.rootViewController = defaultVC()
        
        //判断版本号
        isNewUpdate()
        
        //接受通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.swiftRootViewAction(_:)), name: KSwiftRootViewControllerKey, object: nil)
        return true
    }
    /**
     创建window
     */
    func initWindow() {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.makeKeyAndVisible()
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    func swiftRootViewAction(notification: NSNotification) {
        if notification.object as! Bool {
            window?.rootViewController = BaseTabBarViewController()
        }else {
            //重新创建window
            initWindow()
            window?.rootViewController = BaseTabBarViewController()
        }
    }
    /**
     获取默认界面
     
     - returns: 界面
     */
    func defaultVC() -> UIViewController {
        if UserAcount.userLogin() {
            return isNewUpdate() ? NewFeatureCollectionViewController() : WelcomeViewController()
        }
        return WelcomeViewController()
    }
    /**
     判断版本号
     */
    private func isNewUpdate() -> Bool {
        //当前版本号
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        //获取以前的版本号，自己存到文件的
        let sandVersion = NSUserDefaults.standardUserDefaults().objectForKey("CFBundleShortVersionString") as? String ?? ""
        if currentVersion.compare(sandVersion) == NSComparisonResult.OrderedDescending{
            NSUserDefaults.standardUserDefaults().setObject(currentVersion, forKey: "CFBundleShortVersionString")
            NSUserDefaults.standardUserDefaults().synchronize()
            return true
        }
        return false
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

