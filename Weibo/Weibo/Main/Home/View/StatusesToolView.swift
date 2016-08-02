//
//  StatusesToolView.swift
//  Weibo
//
//  Created by ldy on 16/8/2.
//  Copyright © 2016年 ldy. All rights reserved.
//

import UIKit

class StatusesToolView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
         /// 初始化视图
        setupUI()
    }
    
    func setupUI() {
        //添加视图
        addSubview(retweetBtn)
        addSubview(unlikeBtn)
        addSubview(commonBtn)
        //布局
        retweetBtn.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.height.equalTo(self)
            make.right.equalTo(unlikeBtn.snp_left).offset(-2)
            make.top.equalTo(self)
            make.width.equalTo(unlikeBtn)
        }
        unlikeBtn.snp_makeConstraints { (make) in
            make.left.equalTo(retweetBtn.snp_right).offset(2)
            make.right.equalTo(commonBtn.snp_left).offset(-2)
            make.height.equalTo(self)
            make.top.equalTo(self)
            make.width.equalTo(commonBtn)
        }
        commonBtn.snp_makeConstraints { (make) in
            make.left.equalTo(unlikeBtn.snp_right).offset(2)
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.width.equalTo(retweetBtn)
            make.height.equalTo(self)
        }
    }
    //MARK: - 懒加载
    /// 转发
    private lazy var retweetBtn: UIButton = UIButton.createButton("timeline_icon_retweet", title: "转发")
    /// 赞
    private lazy var unlikeBtn: UIButton = UIButton.createButton("timeline_icon_unlike", title: "赞")
    /// 评论
    private lazy var commonBtn: UIButton = UIButton.createButton("timeline_icon_comment", title: "评论")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
