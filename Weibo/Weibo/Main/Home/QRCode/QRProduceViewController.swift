//
//  QRProduceViewController.swift
//  Weibo
//
//  Created by ldy on 16/7/4.
//  Copyright © 2016年 ldy. All rights reserved.
//

import UIKit

class QRProduceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "我的二维码"
        view.backgroundColor = UIColor.lightGrayColor()
        // 创建二维码
        view.addSubview(myCodeImage)
        myCodeImage.snp_makeConstraints { (make) in
            make.center.equalTo(view)
            make.size.equalTo(CGSize(width: 200, height: 200))
        }
    }
    func createQRCodeImage(textStr: String) -> UIImage {
        // 二维码滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        // 恢复滤镜的默认属性
        filter?.setDefaults()
        // 设置参数
        filter?.setValue(textStr.dataUsingEncoding(NSUTF8StringEncoding), forKey: "inputMessage")
        //获取滤镜输出的图像
        let outputImage = filter?.outputImage
        let bgImage = createNonInterpolatedUIImageFormCIImage(outputImage!, size: 200)
        //获取头像
        let iconImage = UIImage(named: "iconImage")
        
        //设置图片
        return createNewImageWithBg(bgImage, iconImage: iconImage!)
        
        
        
    }
    /**
     生成二维码名片
     
     :param: bgImage   背景图片
     :param: iconImage 头像
     
     :returns: 生成好的图片
     */
    private func createNewImageWithBg(bgImage:UIImage, iconImage: UIImage) -> UIImage{
        // 1.开启图片上下文
        UIGraphicsBeginImageContext(bgImage.size)
        // 2.绘制背景
        bgImage.drawInRect(CGRect(origin: CGPointZero, size: bgImage.size))
        // 3.绘制图标
        let iconW:CGFloat = 50.0
        let iconH:CGFloat = 50.0
        let iconX = (bgImage.size.width - iconW) * 0.5
        let iconY = (bgImage.size.height - iconH) * 0.5
        iconImage.drawInRect(CGRect(x: iconX, y: iconY, width: iconW, height: iconH))
        // 4.取出绘制好的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // 5.关闭上下文
        UIGraphicsEndImageContext()
        // 6.返回生成好得图片
        return newImage
    }

    //MARK: - 懒加载
    private lazy var myCodeImage: UIImageView = {
        let image = self.createQRCodeImage("幻空缥缈")
        let imgV = UIImageView(image: image)
       return imgV
    }()
    
    /**
     根据CIImage生成指定大小的高清UIImage
     
     :param: image 指定CIImage
     :param: size    指定大小
     :returns: 生成好的图片
     */
    private func createNonInterpolatedUIImageFormCIImage(image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = CGRectIntegral(image.extent)
        let scale: CGFloat = min(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent))
        
        // 1.创建bitmap;
        let width = CGRectGetWidth(extent) * scale
        let height = CGRectGetHeight(extent) * scale
        let cs: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!
        let bitmapRef = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, cs, 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImageRef = context.createCGImage(image, fromRect: extent)
        
        CGContextSetInterpolationQuality(bitmapRef,  CGInterpolationQuality.None)
        CGContextScaleCTM(bitmapRef, scale, scale);
        CGContextDrawImage(bitmapRef, extent, bitmapImage);
        
        // 2.保存bitmap到图片
        let scaledImage: CGImageRef = CGBitmapContextCreateImage(bitmapRef)!
        
        return UIImage(CGImage: scaledImage)
    }
}
