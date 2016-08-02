//
//  Oauth2ViewController.swift
//  Weibo
//
//  Created by ldy on 16/7/4.
//  Copyright © 2016年 ldy. All rights reserved.
//

//App Key：3078732713
//App Secret：58204b0c2c143b55a219866eff83d8a8
//https://www.baidu.com
import UIKit
import SVProgressHUD
class Oauth2ViewController: UIViewController {
    
    override func loadView() {
        view = webView
        
    }
    let appKey = "3078732713"
    let appSecret = "58204b0c2c143b55a219866eff83d8a8"
    let appURLDirect = "https://www.baidu.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: "https://api.weibo.com/oauth2/authorize?client_id=\(appKey)&redirect_uri=\(appURLDirect)")
        //        print(url)
        webView.loadRequest(NSURLRequest(URL: url!))
        
        //导航栏
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(Oauth2ViewController.naviBtnAction))
    }
//    deinit {
//        print("Oauth2ViewController销毁")
//    }
    //MARK: - 点击事件
    func naviBtnAction() {
        if webView.canGoBack {
            
            webView.goBack()
        }else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //MARK: - 懒加载
    private lazy var webView: UIWebView = {
        let webView = UIWebView(frame: UIScreen.mainScreen().bounds)
        webView.delegate = self
        return webView
    }()
}

extension Oauth2ViewController: UIWebViewDelegate {
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //取消    https://www.baidu.com/?error_uri=%2Foauth2%2Fauthorize&error=access_denied&error_description=user%20denied%20your%20request.&error_code=21330
        //授权之后  https://www.baidu.com/?code=9fe89e4e9539794f43e5179d7c4f5d64
        
        //获取完成字符串
        let urlStr = request.URL?.absoluteString
        //判断如果不是回调继续加载
        if !(urlStr!.hasPrefix(appURLDirect)) {
            return true
        }
        //获取回调地址code
        let queryStr = request.URL?.query
//        print(queryStr)
        let code = "code="
        if queryStr!.hasPrefix(code) {
            let codeStr = queryStr?.substringFromIndex(code.endIndex)
            //根据获取的codeToken换取Access Token
            getAccessToken(codeStr!)
        }
        else {
            dismissViewControllerAnimated(true, completion: nil)
        }
        return false
    }
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.showWithStatus("正在加载，请稍后。。。")
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.Dark)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Gradient)
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    /**
     根据获取的codeStr换取Access Token
     
     - parameter codeStr: codeToken
     */
    func getAccessToken(codeStr: String) {
        let paramer = ["client_id":appKey,"client_secret":appSecret,"grant_type":"authorization_code","code":codeStr,"redirect_uri":appURLDirect]
        DataServer.shareInstance().requsetData(NetMethod.POST, urlStr: "oauth2/access_token", paramer: paramer, success: { (response) in
            let acount = UserAcount(dict: response as! [String: AnyObject])
            acount.loadUserInfo({ (account, error) in
                if account != nil {
                    account?.saveAccount()
                    
                    SVProgressHUD.dismiss()
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                    // 去欢迎界面
                    NSNotificationCenter.defaultCenter().postNotificationName(KSwiftRootViewControllerKey, object: false)
                    return
                }
            })
        }) { (error) in
            print(error)
            SVProgressHUD.dismiss()
        }
    }
}
