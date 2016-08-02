//
//  QRCodeViewController.swift
//  Weibo
//
//  Created by ldy on 16/6/29.
//  Copyright © 2016年 ldy. All rights reserved.
//

import UIKit
import AVFoundation
class QRCodeViewController: UIViewController {

    var isSetupConstrains: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //初始化导航栏按钮
        createNav()
        
        //添加tabBar
        createTabBar()
        
        //创建视图
        initView()
    }

    func createNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(QRCodeViewController.leftNavAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "访问", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(QRCodeViewController.rightNavAction))
        navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 0.57, green: 0.57, blue: 0.57, alpha: 1)
    }
    func createTabBar() {
        let tabBar = UITabBar()
        tabBar.barTintColor = UIColor.init(colorLiteralRed: 0.57, green: 0.57, blue: 0.57, alpha: 1)
        tabBar.delegate = self
        view.addSubview(tabBar)
        tabBar.snp_makeConstraints { (make) in
            make.bottom.equalTo(view)
            make.height.equalTo(64)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
        tabBar.tintColor = UIColor.orangeColor()
        let qrcodeItem = UITabBarItem(title: "二维码", image: UIImage(named: "qrcode_tabbar_icon_qrcode"), selectedImage: UIImage(named: "qrcode_tabbar_icon_qrcode_highlighted"))
        qrcodeItem.tag = 100
        let barcodeItem = UITabBarItem(title: "条形码", image: UIImage(named: "qrcode_tabbar_icon_barcode"), selectedImage: UIImage(named: "qrcode_tabbar_icon_barcode_highlighted"))
        barcodeItem.tag = 101
        tabBar.items = [qrcodeItem,barcodeItem]
        tabBar.selectedItem = qrcodeItem
        
    }
    //创建视图
    func initView() {
        
        view.addSubview(borderView)
        
        borderView.addSubview(scanlineView)
        //按钮
        view.addSubview(qrCodeBtn)

        view.setNeedsUpdateConstraints()
        
        //扫描二维码
        startReading()
       
        
    }
    func startReading() {
        if !session.canAddInput(input) {
            return
        }
        if !session.canAddOutput(output) {
            return
        }
        session.addInput(input)
        session.addOutput(output)
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        output.rectOfInterest = borderView.frame
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        //添加边线图层
        previewLayer.addSublayer(drawLayer)
        //开始会话
        session.startRunning()
        
    }
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(2.0) {
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.scanlineView.snp_updateConstraints(closure: { (make) in
                make.top.equalTo(self.borderView.snp_bottom)
            })
            self.borderView.layoutIfNeeded()
        
        }
        
    }
    override func updateViewConstraints() {
        if !isSetupConstrains {
        
            borderView.snp_makeConstraints { (make) in
                make.width.equalTo(200)
                make.height.equalTo(200)
                make.centerX.equalTo(view)
                make.centerY.equalTo(view)
            }
            scanlineView.snp_makeConstraints { (make) in
                make.size.equalTo(borderView.snp_size)
                make.bottom.equalTo(borderView.snp_top).priorityLow()
                make.left.equalTo(borderView)
            }
            qrCodeBtn.snp_makeConstraints(closure: { (make) in
                make.top.equalTo(borderView).offset(-50)
                make.centerX.equalTo(view)
            })
            
            isSetupConstrains = true
        }
        super.updateViewConstraints()
    }
    //MARK: -导航栏按钮点击事件
    func rightNavAction() {
        
    }
    func leftNavAction() {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    //按钮点击事件
    func qrCodeBtnAction() {
        let vc = QRProduceViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: -懒加载
    //生成二维码按钮
    private lazy var qrCodeBtn: UIButton = {
       let btn = UIButton(type: UIButtonType.Custom)
        btn.setTitle("生成二维码", forState: UIControlState.Normal)
        var image = UIImage(named: "qrcode_button_background")
        image = image?.stretchableImageWithLeftCapWidth(Int(image!.size.width/2.0), topCapHeight: Int(image!.size.height/2.0))
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn.setBackgroundImage(image, forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(QRCodeViewController.qrCodeBtnAction), forControlEvents: UIControlEvents.TouchUpInside)
        btn.sizeToFit()
        return btn
    }()
    //二维码边框
    private lazy var borderView: UIImageView = {
        var image = UIImage(named: "qrcode_border")
        image = image?.stretchableImageWithLeftCapWidth(Int(image!.size.width/2.0), topCapHeight: Int(image!.size.height/2.0))
        
        let borderV = UIImageView(image: image)
//        borderV.backgroundColor = UIColor.redColor()
        borderV.backgroundColor = UIColor.clearColor()
        borderV.clipsToBounds = true
        return borderV
    }()
    //冲击波
    private lazy var scanlineView: UIImageView = {
        let borderV = UIImageView(image: UIImage(named: "qrcode_scanline_qrcode"))
//        borderV.backgroundColor = UIColor.orangeColor()
        borderV.backgroundColor = UIColor.clearColor()
        return borderV
    }()
    //输入流
    private lazy var input: AVCaptureDeviceInput? = {
       let capture = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: capture)
            return input
        }
        catch {
            print(error)
            return nil
        }
        
    }()
    //输出流
    private lazy var output: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    //创建会话
    private lazy var session: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetHigh
        return session
    }()
    //预览图层
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let viewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        viewLayer.frame = UIScreen.mainScreen().bounds
        viewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        return viewLayer
    }()
    // 创建用于绘制边线的图层
    private lazy var drawLayer: CALayer = {
        let layer = CALayer()
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    }()
    
    
}


extension QRCodeViewController: UITabBarDelegate {
    
    //MARK: - UITabBarDelegate
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {

        if item.tag == 100 {
            borderView.snp_updateConstraints(closure: { (make) in
                make.height.equalTo(200)
            })
        }
        else if item.tag == 101 {
            borderView.snp_updateConstraints(closure: { (make) in
                make.height.equalTo(100)
            })
        }
    }
}


extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!)
    {
        //清除绘制的图层
        clearCorner()
        //停止会话
        session.stopRunning()
        
        //停止会话
//        session.stopRunning()
        if metadataObjects.count > 0 {
            for object in metadataObjects {
                if object is AVMetadataMachineReadableCodeObject {
                    //转化坐标系
                    let codeObject = previewLayer.transformedMetadataObjectForMetadataObject(object as! AVMetadataObject) as! AVMetadataMachineReadableCodeObject
                    //绘制图形
                        
                    self.drawPreview(codeObject)
                    
                    let alertView = UIAlertController(title: "扫描到的结果", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                    alertView.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (_) in
                        //重新扫描
                        self.clearCorner()
                        self.session.startRunning()
                    }))
                    alertView.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (_) in
                        print(codeObject.stringValue)
                        self.clearCorner()
                        self.session.startRunning()
                    }))
                    self.navigationController?.presentViewController(alertView, animated: true, completion: nil)
                }
            }
        }
       
        
    }
    func drawPreview(codeObject: AVMetadataMachineReadableCodeObject) {
        
        if codeObject.corners.isEmpty {
            return
        }
        //创建图层
        let layer = CAShapeLayer()
        layer.lineWidth = 4
        layer.strokeColor = UIColor.redColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        //创建路径
        let path = UIBezierPath()
        var point = CGPointZero
        var index: Int = 0
        
        //第一个点
        CGPointMakeWithDictionaryRepresentation((codeObject.corners[index] as! CFDictionaryRef), &point)
        index += 1
        path.moveToPoint(point)
        
        //其他点
        while index < codeObject.corners.count {
            CGPointMakeWithDictionaryRepresentation((codeObject.corners[index] as! CFDictionaryRef), &point)
            index += 1
            path.addLineToPoint(point)
        }
        
        //关闭路径
        path.closePath()
        
        //绘制路径
        layer.path = path.CGPath
        
        //将绘制好的路径添加到图层上
        drawLayer.addSublayer(layer)
        
    }
    //清除绘制的图层
    func clearCorner() {
        
        if drawLayer.sublayers == nil || drawLayer.sublayers?.count == 0{
            return
        }
        for subLayer in drawLayer.sublayers! {
            subLayer.removeFromSuperlayer()
        }
    }
}
