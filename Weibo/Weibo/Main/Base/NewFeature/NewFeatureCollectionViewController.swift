//
//  NewFeatureCollectionViewController.swift
//  Weibo
//
//  Created by ldy on 16/7/6.
//  Copyright © 2016年 ldy. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FeatureCell"

class NewFeatureCollectionViewController: UICollectionViewController {
        /// 页面个数
    private let pageCount = 4
        /// 布局对象
    private var layout: UICollectionViewFlowLayout = NewFeatureLayout()
    init() {
        super.init(collectionViewLayout: layout)
    }
//    deinit {
//        print("NewFeatureCollectionViewController销毁")
//    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.grayColor()
        collectionView!.registerClass(NewFeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return pageCount
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewFeatureCell

        cell.imageIndex = indexPath.row
        return cell
    }
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        //拿到当前索引
        let path = collectionView.indexPathsForVisibleItems().last!
        let thisCell = collectionView.cellForItemAtIndexPath(path) as! NewFeatureCell
        if path.row == pageCount-1 {
            thisCell.animationBtn()
        }
    }

}

private class NewFeatureCell: UICollectionViewCell {
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        //初始化视图
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///初始化视图
    func setupView() {
        contentView.addSubview(featureImageView)
        featureImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        contentView.addSubview(enterBtn)
        
        enterBtn.snp_makeConstraints(closure: { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-100)
            make.size.equalTo(CGSize(width: 185, height: 42))
        })
    }
    func animationBtn() {
        enterBtn.hidden = false
        enterBtn.userInteractionEnabled = false
        self.enterBtn.transform = CGAffineTransformMakeScale(0, 0)
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 20, options: UIViewAnimationOptions.LayoutSubviews, animations: {
            self.enterBtn.transform = CGAffineTransformIdentity
            }) { (_) in
                self.enterBtn.userInteractionEnabled = true
        }
    }
    //保存数据
    private var imageIndex: Int? {
        didSet {
            self.featureImageView.image = UIImage(named: "new_feature_\(imageIndex! + 1)")
            enterBtn.hidden = true
        }
    }
    
    //MARK: - 按钮点击事件
    @objc func enterBtnAction() {
        
        NSNotificationCenter.defaultCenter().postNotificationName(KSwiftRootViewControllerKey, object: true)
    }
    //MARK: - 懒加载
        /// 图片
    private lazy var featureImageView = UIImageView()
    private lazy var enterBtn: UIButton = {
       let btn = UIButton(type: UIButtonType.Custom)
        let strName = "new_feature_button"
        btn.setImage(UIImage(named: strName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: strName+"_highlighted"), forState: UIControlState.Highlighted)
        btn.addTarget(self, action: #selector(NewFeatureCell.enterBtnAction), forControlEvents: UIControlEvents.TouchUpInside)
        btn.hidden = true
        return btn
    }()
    
   
}

private class NewFeatureLayout: UICollectionViewFlowLayout {
   
    private override func prepareLayout() {
        //设置布局对象属性
        itemSize = UIScreen.mainScreen().bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        //设置collectionView属性
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
    }
}
