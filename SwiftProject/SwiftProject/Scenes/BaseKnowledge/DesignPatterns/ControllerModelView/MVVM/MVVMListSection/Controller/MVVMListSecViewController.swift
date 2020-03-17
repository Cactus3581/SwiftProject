//
//  MVVMListSecViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit


class MVVMListSecViewController: BaseViewController, UITableViewDelegate {

    fileprivate var viewModel: MVVMListSecViewModel?
    var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // 注册 sessionViewModel
        MVVMListSecAssembly.register()
        // 创建 ViewModel
        self.viewModel = MVVMListSecViewModel()
        // 创建 tableView
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

        tableView?.register(MVVMListSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: MVVMListSectionHeaderView.identifier)
        tableView?.register(MVVMListSectionFooterView.self, forHeaderFooterViewReuseIdentifier: MVVMListSectionFooterView.identifier)
        tableView?.register(MVVMListSecGroupTableViewCell.self, forCellReuseIdentifier: MVVMListSecGroupTableViewCell.identifier)
        tableView?.register(MVVMListSecButtonTableViewCell.self, forCellReuseIdentifier: MVVMListSecButtonTableViewCell.identifier)

        let headerView =  MVVMListTableHeaderView.init(frame: CGRect(x: 0, y: 0, width: tableView?.bounds.width ?? 0, height: 50))
        tableView?.tableHeaderView = headerView
        headerView.viewModel = viewModel

        let footerView =  MVVMListTableFooterView.init(frame: CGRect(x: 0, y: 0, width: tableView?.bounds.width ?? 0, height: 50))
        tableView?.tableFooterView = footerView
        footerView.viewModel = viewModel

        tableView?.estimatedRowHeight = 50
        tableView?.estimatedSectionHeaderHeight = 50
        tableView?.estimatedSectionFooterHeight = 50

        tableView?.dataSource = viewModel
        tableView?.delegate = self
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel = viewModel else {
            return nil
        }

        let sessionViewModel = viewModel.array[section]
        let view: MVVMListSectionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: sessionViewModel.headerIdentifier) as! MVVMListSectionHeaderView
        view.viewModel = viewModel.array[section]
        return view
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let viewModel = viewModel else {
            return nil
        }
        let sessionViewModel = viewModel.array[section]
        let view: MVVMListSectionFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: sessionViewModel.footerIdentifier) as! MVVMListSectionFooterView
        view.viewModel = viewModel.array[section]
        return view
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
