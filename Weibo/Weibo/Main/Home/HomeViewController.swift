//
//  HomeViewController.swift
//  Weibo
//
//  Created by ldy on 16/6/22.
//  Copyright © 2016年 ldy. All rights reserved.
//

import UIKit

private let homeStatusesIdent = "homeStatusesIdent"
class HomeViewController: BaseViewController {

    var statuArr: [StatusesHomeModel]? {
        didSet {
            //设置完数据之后，刷新单元格
            tableView.reloadData()
            
        }
    }
    //移除通知
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if !islogin {
            
            vistorView?.visitorInfo(VisitorView.VisitorType.IsHome)
            return
        }
        
        //初始化UI
        setupUI()
        
        //初始化导航栏按钮
        createNav()
       
        //加载数据
        loadData()
        
        //添加通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.notificationAction), name: popNotificationChange, object: nil)
        
    }
    /// 初始化UI
    func setupUI() {
        view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    /**
     初始化导航栏按钮
     */
    func createNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.createNaviBtn(self, action: #selector(HomeViewController.rightNavAction), imageName: "navigationbar_pop")
        navigationItem.leftBarButtonItem = UIBarButtonItem.createNaviBtn(self, action: #selector(HomeViewController.leftNavAction), imageName: "navigationbar_friendattention")
        
        let btn = NaviTitleButton(type: UIButtonType.Custom)
        let nickName = UserAcount.readAccount()?.screen_name
        btn.setTitle(nickName!, forState: UIControlState.Normal)
         btn.addTarget(self, action: #selector(HomeViewController.titleBtnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = btn
        
    }
    /**
     加载数据
     */
    func loadData() {
       StatusesHomeModel.loadStatuses { (models, error) in
        if error != nil {
            return
        }
        self.statuArr = models
        }
    }
    //MARK:  -导航栏按钮点击事件
    func rightNavAction() {
        let qrCode = QRCodeViewController()
        let baseNavi = BaseNavigationViewController(rootViewController: qrCode)
        qrCode.hidesBottomBarWhenPushed = true
        self.presentViewController(baseNavi, animated: true, completion: nil)
    }
    func leftNavAction() {
        print(#function)
    }
    func titleBtnAction(btn: UIButton) {
        
        
        let popVC = PopViewController()
        popVC.transitioningDelegate = popAnimation
        popVC.modalPresentationStyle = UIModalPresentationStyle.Custom
        presentViewController(popVC, animated: true, completion: nil)
        
    }
    //通知接收方法
    func notificationAction() {
        let btn = navigationItem.titleView as! UIButton
        btn.selected = !btn.selected
        
    }
    //MARK: -懒加载
    private lazy var tableView: UITableView = {
        let tableV = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
       tableV.delegate = self
        tableV.dataSource = self
        tableV.rowHeight = UITableViewAutomaticDimension
        tableV.estimatedRowHeight = 300
        tableV.registerClass(HomeStatusesCell.self, forCellReuseIdentifier: homeStatusesIdent)
        return tableV
    }()
    /// 弹出动画
    private lazy var popAnimation: PopAnimation = {
        let pop = PopAnimation()
        pop.presentFrame = CGRect(x: 100, y: 56, width: 200, height: 200)
        return pop
    }()
    var rowCache: NSCache = NSCache()
    override func didReceiveMemoryWarning() {
        rowCache.removeAllObjects()
    }
    
}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuArr?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(homeStatusesIdent, forIndexPath: indexPath) as? HomeStatusesCell
        cell!.status = statuArr![indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let status = statuArr![indexPath.row]
        if let height = rowCache.objectForKey(status.id) {
            return height as! CGFloat
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(homeStatusesIdent) as? HomeStatusesCell
        let rowHeight = cell!.rowHeight(status)
        rowCache.setObject(rowHeight, forKey: status.id)
        return rowHeight
    }
}
