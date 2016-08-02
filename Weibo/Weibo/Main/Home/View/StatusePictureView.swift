//
//  StatusePictureView.swift
//  Weibo
//
//  Created by ldy on 16/8/2.
//  Copyright © 2016年 ldy. All rights reserved.
//

import UIKit
import SDWebImage
private let homeStatusesPictureViewIdent = "homeStatusesPictureViewIdent"
class StatusePictureView: UICollectionView {
    
    var status: StatusesHomeModel? {
        
        didSet {
            //设置上面视图数据
            reloadData()
            
        }
    }
    
    init() {
        super.init(frame: CGRectZero, collectionViewLayout: self.pivLayout)
        
        
        backgroundColor = UIColor.clearColor()
        delegate = self
        dataSource = self
        registerClass(PictureViewCell.self, forCellWithReuseIdentifier: homeStatusesPictureViewIdent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     计算配图尺寸
     
     - returns:
     */
    func calculateImageSize() -> CGSize {
        
        let width = 90
        let spacing = 5
        
        let picCount = status?.thumbnailPicURLS?.count
        if picCount == 0 || picCount == nil{
            pivLayout.itemSize = CGSizeZero
            return CGSizeZero
        }else if picCount == 1 {
            let urlStr = status?.thumbnailPicURLS!.first?.absoluteString
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(urlStr)
            pivLayout.itemSize = image.size
            return image.size
        }else if picCount == 4 {
            let widthView = width * 2 + spacing * 2
            pivLayout.itemSize = CGSize(width: width, height: width)
            return CGSize(width: widthView, height: widthView)
        }else {
            let colNumber = 3
            let rowNumber = (picCount! - 1) / 3 + 1
            let widthV = colNumber * width + (colNumber - 1) * spacing
            let heightV = rowNumber * width + (rowNumber - 1) * spacing
            pivLayout.itemSize = CGSize(width: width, height: width)
            return CGSize(width: widthV, height: heightV)
        }
        
    }
    
    private var pivLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        return layout
    }()
    
}

extension StatusePictureView: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let index = status?.thumbnailPicURLS?.count {
            return index
        }
        return 0
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(homeStatusesPictureViewIdent, forIndexPath: indexPath) as! PictureViewCell
        
        cell.picImageURL = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(status?.thumbnailPicURLS![indexPath.row].absoluteString)
        
        
        return cell
    }
    
}

//MARK: - PictureViewCell
class PictureViewCell: UICollectionViewCell {
    
    var picImageURL: UIImage? {
        didSet {
            imageView.image = picImageURL
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
    }
    //MARK: -懒加载
    private lazy var imageView: UIImageView = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}