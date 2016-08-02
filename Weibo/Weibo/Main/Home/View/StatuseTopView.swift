//
//  StatuseTopView.swift
//  Weibo
//
//  Created by ldy on 16/8/2.
//  Copyright © 2016年 ldy. All rights reserved.
//

import UIKit

class StatuseTopView: UIView {

    var status: StatusesHomeModel? {
        
        didSet {
            timeLabel.text = status?.created_at
            sourceLabel.text = status?.source
            nickNameLabel.text = status?.user?.screen_name
            certificationView.image = status?.user?.verified_Image
            memberShipView.image = status?.user?.mbrankImage
            if let url = status?.user?.profileURL {
                iconView.sd_setImageWithURL(url)
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        /// 初始化视图
        setupUI()
    }
    
    func setupUI() {
        //添加视图
        addSubview(iconView)
        addSubview(certificationView)
        addSubview(nickNameLabel)
        addSubview(memberShipView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        //布局
        let spain = 10.0
        iconView.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 50, height: 50))
            make.top.equalTo(self).offset(spain)
            make.left.equalTo(self).offset(spain)
        }
        certificationView.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 17, height: 17))
            make.bottom.equalTo(iconView)
            make.right.equalTo(iconView)
        }
        nickNameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(iconView.snp_right).offset(spain)
            make.top.equalTo(iconView)
            make.right.equalTo(memberShipView.snp_left).offset(-spain)
            make.bottom.equalTo(timeLabel.snp_top).offset(-spain/2.0)
        }
        memberShipView.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 17, height: 17))
            make.left.equalTo(nickNameLabel.snp_right).offset(spain)
            make.bottom.equalTo(nickNameLabel).offset(-3)
        }
        timeLabel.snp_makeConstraints { (make) in
            make.top.equalTo(nickNameLabel.snp_bottom).offset(spain/2.0)
            make.left.equalTo(nickNameLabel)
            make.bottom.equalTo(iconView)
            make.right.equalTo(sourceLabel.snp_left).offset(-spain)
        }
        sourceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp_right).offset(spain)
            make.top.equalTo(timeLabel)
            make.bottom.equalTo(timeLabel)
        }
    }
    //MARK: - 懒加载
    /// 头像
    private lazy var iconView: UIImageView = {
        let imgV = UIImageView(image: UIImage(named: "avatar_default_big"))
        imgV.layer.cornerRadius = 25
        imgV.layer.masksToBounds = true
        return imgV
    }()
    /// 认证图标
    private lazy var certificationView: UIImageView = UIImageView()
    /// 昵称
    private lazy var nickNameLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontFloat: 14)
    /// 会员图标
    private lazy var memberShipView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
    /// 时间
    private lazy var timeLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontFloat: 14)
    /// 来源
    private lazy var sourceLabel: UILabel = UILabel.createLabel(UIColor.darkGrayColor(), fontFloat: 14)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
