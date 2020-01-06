//
//  RxSwiftViewController.swift
//  SwiftProject
//
//  Created by ryan on 2019/12/26.
//  Copyright © 2019 cactus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxSwiftViewController: BaseViewController {

    var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        rx_bindViewModel()
    }

    func setupViews() {
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
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    func rx_bindViewModel() {
        let disposeBag = DisposeBag()

        //1.创建可观察数据源
        let texts = ["Objective-C", "Swift", "RXSwift"]
        let textsObservable = Observable.from(optional: texts)
        //2. 将数据源与 tableView 绑定
        textsObservable.bind(to: (tableView?.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self))!) { (row, text, cell) in
            cell.textLabel?.text = text
        }.disposed(by: disposeBag)

        //3. 绑定 tableView 的事件
        tableView?.rx.itemSelected.bind { (indexPath) in
            print(indexPath)
        }.disposed(by: disposeBag)

        //4. 设置 tableView Delegate/DataSource 的代理方法
//        tableView?.rx.setDelegate(self).disposed(by: disposeBag)
//        tableView?.rx.setDataSource(self).disposed(by: disposeBag)
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
