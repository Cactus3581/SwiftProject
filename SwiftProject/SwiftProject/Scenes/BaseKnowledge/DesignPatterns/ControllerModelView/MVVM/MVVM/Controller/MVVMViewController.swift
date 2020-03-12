//
//  MVVMViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

/*
MVVM
绑定机制：在view和viewModel之间进行绑定，可以使用闭包或者RxSwift进行响应式编程。通过事件进行绑定操作。通过函数式编程进行各种 Combine 或 Filter。
 */

class MVVMViewController: BaseViewController,MVVMViewProtocol {

    lazy var mvvmView: MVVMView = MVVMView()
    var viewModel: MVVMViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViews()
        handleData()
        reload()
    }

    func initializeViews() {
        mvvmView.backgroundColor = UIColor.lightGray
        mvvmView.delegate = self
        view.addSubview(mvvmView)
        mvvmView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

    func handleData() {
        self.viewModel = MVVMViewModel()
    }

    func reload() {
        mvvmView.viewModel = viewModel
    }

    func push() {
        print("MVVMView push")
    }
}
