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

        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        view.addSubview(tableView!)
        tableView?.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        tableView?.backgroundColor = UIColor.white
        tableView?.separatorStyle = .singleLine

        tableView?.register(MVVMListSectionTextHeaderView.self, forHeaderFooterViewReuseIdentifier: MVVMListSectionTextHeaderView.identifier)
        tableView?.register(MVVMListSectionTextFooterView.self, forHeaderFooterViewReuseIdentifier: MVVMListSectionTextFooterView.identifier)
        tableView?.register(MVVMListSectionImageHeaderView.self, forHeaderFooterViewReuseIdentifier: MVVMListSectionImageHeaderView.identifier)
        tableView?.register(MVVMListSectionImageFooterView.self, forHeaderFooterViewReuseIdentifier: MVVMListSectionImageFooterView.identifier)
        tableView?.register(MVVMListCourseTableViewCell.self, forCellReuseIdentifier: MVVMListCourseTableViewCell.identifier)
        tableView?.register(MVVMListListeningTableViewCell.self, forCellReuseIdentifier: MVVMListListeningTableViewCell.identifier)

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
        if var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: sessionViewModel.headerIdentifier) as? MVVMListSectionViewProtocol {
            view.sessionViewModel = viewModel.array[section]
            return view as? UIView
        }
        return nil
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let viewModel = viewModel else {
            return nil
        }
        let sessionViewModel = viewModel.array[section]
        if var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: sessionViewModel.footerIdentifier) as? MVVMListSectionViewProtocol {
            view.sessionViewModel = viewModel.array[section]
            return view as! UIView
        }
        return nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
