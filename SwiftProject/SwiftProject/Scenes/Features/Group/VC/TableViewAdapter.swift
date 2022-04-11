//
//  TableViewAdapter.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2022/4/9.
//  Copyright © 2022 cactus. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class TableViewAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {
    let vm: GroupVM
    weak var tableView: UITableView?
    let actionHandler: ActionHandler
    let disposeBag: DisposeBag

    init(vm: GroupVM,
         table: UITableView,
         actionHandler: ActionHandler) {
        self.vm = vm
        self.tableView = table
        self.actionHandler = actionHandler
        self.disposeBag = DisposeBag()
        super.init()
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }

    func setup() {
        bind()
    }

    func bind() {
        tableView?.register(GroupCell.self, forCellReuseIdentifier: "cell")
        vm.dataRelay
            .asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
            self?.tableView?.reloadData()
        }).disposed(by: disposeBag)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.dataSource.indexData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.dataSource.indexData.getIndexData(index: section)?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let child = vm.dataSource.getChildEntity(indexPath: indexPath),
           let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? GroupCell else {
               return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        }
        cell.setContent(row: indexPath.row)
        cell.setActionHandler(actionHandler)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "")  else {
            return nil
        }
        return header
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "")  else {
            return nil
        }
        return footer
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView.cellForRow(at: indexPath) != nil else { return }
    }
}
