//
//  MVCViewController.swift
//  SwiftProject
//
//  Created by ryan on 2019/12/29.
//  Copyright © 2019 cactus. All rights reserved.
//

import UIKit

/*

 1. controller：创建view，网络请求，将model封装，然后将model数据给view赋值；
 2. view接收事件，然后将事件传递给controller
 3. model和view不会有任何引用关系
 */
class MVCViewController: BaseViewController, MVCViewProtocol {

    lazy var mvcView: MVCView = MVCView()
    var model: MVCModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViews()
        handleData()
        reload()
    }

    func initializeViews() {
        mvcView.backgroundColor = UIColor.lightGray
        mvcView.delegate = self
        view.addSubview(mvcView)
        mvcView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

    func handleData() {
        self.model = MVCModel(name: "name", imageUrl: "navi_back")
    }

    func reload() {
        mvcView.model = model
    }

    func click() {
        print("MVCView click")
    }

    func push() {
        print("MVCView push")
    }
}
