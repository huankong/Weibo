//
//  DataServer.swift
//  Weibo
//
//  Created by ldy on 16/7/4.
//  Copyright © 2016年 ldy. All rights reserved.
//

import UIKit
import AFNetworking
public enum NetMethod: String {
    case GET = "GET"
    case POST = "POST"
}
class DataServer: AFHTTPSessionManager {
    let dateBaseURL: String = "https://api.weibo.com/"
    private static let instance: DataServer = {
       let instance = DataServer()
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return instance
    }()
    class func shareInstance() -> DataServer {
        return instance
    }
    //回调别名
    typealias SuccessCallBack = (response: AnyObject?) -> ()
    typealias FailureCallBack = (error: NSError?) -> ()
    func requsetData(method: NetMethod,urlStr: String,paramer: AnyObject?,success: SuccessCallBack,failure: FailureCallBack){
        let urlStr = dateBaseURL + urlStr
        switch method {
        case .GET:
            GET(urlStr, parameters: paramer,progress: nil, success: { (_,response: AnyObject?) in
                    success(response: response)
                },failure: { (_,error: NSError) in
                    failure(error: error)
            })
        case .POST:
            POST(urlStr, parameters: paramer,progress: nil, success: { (_, response: AnyObject?) in
                    success(response: response)
                }, failure: { (_, error: NSError) in
                    failure(error: error)
            })
        }
    }
}
