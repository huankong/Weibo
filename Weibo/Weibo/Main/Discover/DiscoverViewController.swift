//
//  DiscoverViewController.swift
//  Weibo
//
//  Created by ldy on 16/6/22.
//  Copyright © 2016年 ldy. All rights reserved.
//

import UIKit

class DiscoverViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "发现"
        if !islogin {
            vistorView?.visitorInfo(VisitorView.VisitorType.IsDiscover)
            navigationItem.leftBarButtonItem = UIBarButtonItem()
            navigationItem.rightBarButtonItem = UIBarButtonItem()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
