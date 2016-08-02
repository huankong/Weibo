//
//  HomeStatusesCell.swift
//  Weibo
//
//  Created by ldy on 16/7/11.
//  Copyright © 2016年 ldy. All rights reserved.
//

import UIKit



class HomeStatusesCell: UITableViewCell {

    var status: StatusesHomeModel? {
        
        didSet {
            //设置上面视图数据
            topView.status = status
            
            contentLabel.text = status?.text
            //设置配图数据
            pictureView.status = status

            
            let spain = 10.0
            topView.snp_makeConstraints { (make) in
                make.top.equalTo(self)
                make.left.right.equalTo(self)
                make.height.equalTo(50)
            }
            if let textStr = contentLabel.text {
                let contentSize = (textStr as NSString).boundingRectWithSize(CGSizeMake(self.frame.width-20, 10000.0), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(15)], context: nil).size
                contentLabel.snp_remakeConstraints { (make) in
                    make.top.equalTo(topView.snp_bottom).offset(spain)
                    make.left.equalTo(self).offset(spain)
                    make.right.equalTo(self).offset(-spain)
                    make.height.equalTo(contentSize.height+10)
                }
            }
            pictureView.snp_remakeConstraints { (make) in
                make.top.equalTo(contentLabel.snp_bottom).offset(spain)
                make.left.equalTo(contentLabel.snp_left)
                make.size.equalTo(pictureView.calculateImageSize())
            }
            toolView.snp_remakeConstraints { (make) in
                make.bottom.equalTo(self)
                make.right.left.equalTo(self)
                make.height.equalTo(44)
            }
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //初始化UI
        setupUI()
    }

    /**
     *  初始化UI
     */
    func setupUI() {
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(toolView)
        
    }
    /**
     获取行高
     */
    func rowHeight(status: StatusesHomeModel) -> CGFloat {
        //为了调用didSet,计算配图
        self.status = status
        layoutIfNeeded()
        let size = (status.text! as NSString).boundingRectWithSize(CGSizeMake(self.frame.width-20, 10000.0), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(15)], context: nil).size
        //返回底部视图最大值
        return size.height + CGRectGetMaxY(topView.frame) + 30 + 44 + pictureView.calculateImageSize().height
    }
   
    //MARK: - 懒加载
    /// 上面标示图
    private lazy var topView: StatuseTopView = StatuseTopView()
    /// 正文
    private lazy var contentLabel: UILabel = {
       let label = UILabel.createLabel(UIColor.darkGrayColor(), fontFloat: 15)
        label.numberOfLines = 0
        return label
    }()
    /// 配图
    private lazy var pictureView: StatusePictureView = StatusePictureView()
    /// 工具条
    private lazy var toolView: StatusesToolView = StatusesToolView()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



