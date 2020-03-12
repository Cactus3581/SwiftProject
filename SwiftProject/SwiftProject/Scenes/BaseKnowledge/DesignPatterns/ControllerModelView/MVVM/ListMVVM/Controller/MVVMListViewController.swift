//
//  MVVMListViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

/*
宗旨：
 除了cell和cellVM，其他全部抽象化
 */

/*



 */


/*
 1. 数据不一样：工厂方法解决，一样的接口（可以通过继承或者协议实现），不一样的实现
 2. 样式不一样：通过提供identifier，本质上还是工厂方法
 3. 赋值方法：通过提供cell基类/协议，只要是要求通用的接口，可以用协议或者继承
 4. 事件不一样：cell内部可以判断具体类型，调用各自的方法；

 问题：
 1. json结构直接决定了工厂方法里的处理方式，也决定了适不适合session
 2. 如果带session怎么写
 3. 解决跳转的位置问题：函数调用路径应该是什么样子，如果使用路由可以放在vm里；
*/

class MVVMListViewController: BaseViewController {

    fileprivate let viewModel = MVVMListViewModel()
    var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        MVVMListAssembly.register()
        initializeViews()
    }

    func initializeViews() {
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        view.addSubview(tableView!)
        tableView?.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView?.backgroundColor = UIColor.white
        tableView?.separatorStyle = .singleLine
        tableView?.tableHeaderView = UIView()
        tableView?.tableFooterView = UIView()
        tableView?.estimatedRowHeight = 100
        tableView?.estimatedSectionHeaderHeight = 0
        tableView?.estimatedSectionFooterHeight = 0
        tableView?.dataSource = viewModel
        tableView?.register(MVVMListLabelTableViewCell.self, forCellReuseIdentifier: MVVMListLabelTableViewCell.identifier)
        tableView?.register(MVVMListImageTableViewCell.self, forCellReuseIdentifier: MVVMListImageTableViewCell.identifier)
        tableView?.register(MVVMListButtonTableViewCell.self, forCellReuseIdentifier: MVVMListButtonTableViewCell.identifier)
    }
}
