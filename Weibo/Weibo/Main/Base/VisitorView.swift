//
//  VisitorView.swift
//  Weibo
//
//  Created by ldy on 16/6/23.
//  Copyright © 2016年 ldy. All rights reserved.
//

import UIKit
import SnapKit

protocol VisitorViewDelegate: NSObjectProtocol{
    //登录回调
    func loginBtnDidAction()
    //注册回调
    func registBtnDidAction()
    //去关注回调
    func attenBtnDidAction()
}

class VisitorView: UIView {
    enum VisitorType {
        case IsHome
        case IsMessage
        case IsDiscover
        case IsProfile
    }
    //定义一个属性保存代理对象
    weak var delegate: VisitorViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initView() {
        addSubview(bgIconImage)
        addSubview(maskIconImage)
        addSubview(whithV)
        addSubview(iconImage)
        addSubview(messageLabel)
        addSubview(attenBtn)
        addSubview(registBtn)
        addSubview(loginBtn)
        
        maskIconImage.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        bgIconImage.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-100)
            make.size.equalTo(CGSize(width: 200, height: 200))

        }
        
        whithV.snp_makeConstraints(closure: { (make) in
            make.size.equalTo(CGSize(width: 200, height: 100))
            make.top.equalTo(bgIconImage.snp_top).offset(100)
            make.right.equalTo(bgIconImage.snp_right)
        })
        iconImage.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 100, height: 100))
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-100)
        }
        messageLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: 300, height: 50))
            make.top.equalTo(iconImage.snp_bottom).offset(50)
        }
        attenBtn.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: 100, height: 35))
            make.top.equalTo(messageLabel.snp_bottom).offset(20)
        }
        registBtn.snp_makeConstraints { (make) in
            make.centerX.equalTo(self).offset(-60)
            make.size.equalTo(CGSize(width: 100, height: 35))
            make.top.equalTo(messageLabel.snp_bottom).offset(20)
        }
        loginBtn.snp_makeConstraints { (make) in
            make.centerX.equalTo(self).offset(60)
            make.size.equalTo(CGSize(width: 100, height: 35))
            make.top.equalTo(messageLabel.snp_bottom).offset(20)
        }
       
    }
    func visitorInfo(visitorType: VisitorType) {
        switch visitorType {
        case .IsHome:
            //动画
            animationBgIcon()
            registBtn.hidden = true
            loginBtn.hidden = true
            attenBtn.hidden = false
            bgIconImage.hidden = false
        case .IsMessage:
            hidenView()
            iconImage.image = self.getbtnImage("visitordiscover_image_message")
            messageLabel.text = "登录后，别人评论你的微博，给你发消息，都会在这里收到通知"
        case .IsDiscover:
            hidenView()
        case .IsProfile:
            hidenView()
            iconImage.image = UIImage(named: "visitordiscover_image_profile")
            messageLabel.text = "登录后，你的微博、相册、个人资料会显示在这里，展示给别人"
        }
    }
    func hidenView() {
        bgIconImage.hidden = true
        attenBtn.hidden = true
        registBtn.hidden = false
        loginBtn.hidden = false
    }
    /**
     主页背景图标动画
     */
    func animationBgIcon() {
        let anima = CABasicAnimation(keyPath: "transform.rotation")
        anima.fromValue = 0
        anima.toValue = M_PI * 2
        anima.repeatCount = MAXFLOAT
        anima.duration = 20
        anima.removedOnCompletion = false
        bgIconImage.layer.addAnimation(anima, forKey: nil)
    }
    
    //MARK: -懒加载视图
        /// 背景图标
    private lazy var bgIconImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        
        return img
    }()
        /// 大背景视图
    private lazy var maskIconImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        return img
    }()
    private lazy var whithV: UIView = {
        let whiV = UIView()
        whiV.backgroundColor = UIColor.whiteColor()
        return whiV
    }()
        /// 房子
    private lazy var iconImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        return img
    }()
        /// 消息文字
    private lazy var messageLabel: UILabel = {
       let label = UILabel()
        label.text = "关注一些人，回这里看看有什么惊喜"
        label.textColor = UIColor.darkGrayColor()
        label.font = UIFont.systemFontOfSize(14)
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.Center
        return label
    }()
        /// 关注按钮
    private lazy var attenBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.Custom)
        btn.setTitle("去关注", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        btn.setBackgroundImage(self.getbtnImage("common_button_white_disable"), forState: UIControlState.Normal)
        //添加监听
        btn.addTarget(self, action: #selector(attenBtnAction), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
        /// 注册按钮
    private lazy var registBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.Custom)
        btn.setTitle("注册", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        btn.setBackgroundImage(self.getbtnImage("common_button_white_disable"), forState: UIControlState.Normal)
        //添加监听
        btn.addTarget(self, action: #selector(registBtnAction), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
        /// 登录按钮
    private lazy var loginBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.Custom)
        btn.setTitle("登录", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.setBackgroundImage(self.getbtnImage("common_button_white_disable"), forState: UIControlState.Normal)
        //添加监听
        btn.addTarget(self, action: #selector(loginBtnAction), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    //设置btn图片
    func getbtnImage(imageName: String) -> UIImage {
        var  btnImage = UIImage(named: imageName)
        
        btnImage = btnImage?.stretchableImageWithLeftCapWidth(Int((btnImage?.size.width)!/2.0), topCapHeight: Int((btnImage?.size.height)!/2.0))
        return btnImage!
    }
    
    //MARK: -按钮点击事件
    /**
     关注按钮点击事件
     */
    func attenBtnAction() {
        delegate?.attenBtnDidAction()
    }
    /**
     注册按钮点击事件
     */
    func registBtnAction() {
        delegate?.registBtnDidAction()
    }
    /**
     注册按钮点击事件
     */
    func loginBtnAction() {
        delegate?.loginBtnDidAction()
    }
}
