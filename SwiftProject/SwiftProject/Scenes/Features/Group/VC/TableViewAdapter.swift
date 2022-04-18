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

/** TableViewAdapter的设计：分担VC的工作（tableView相关）
 1. 实现tableView相关协议
 2. 实现刷新table
 3. loadmore 触发器
*/

final class TableViewAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {
    private weak var tableView: UITableView?
    private let viewDataState: ViewDataState
    private let actionHandler: ActionHandler
    private let disposeBag: DisposeBag

    init(table: UITableView,
         viewDataState: ViewDataState,
         actionHandler: ActionHandler) {
        self.tableView = table
        self.viewDataState = viewDataState
        self.actionHandler = actionHandler
        self.disposeBag = DisposeBag()
        super.init()
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewDataState.sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let parent = viewDataState.getParentEntity(section: section) else { return 0 }
        guard viewDataState.getExpandState(id: parent.id) ?? false else { return 0 }
        return viewDataState.count(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let child = viewDataState.getChildEntity(indexPath: indexPath),
           let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? GroupCell else {
               return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        }
        cell.setContent(indexPath: indexPath, entity: child)
        cell.setActionHandler(actionHandler)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? GroupHeader else {
            return nil
        }
        guard let parent = viewDataState.getParentEntity(section: section) else {
            return nil
        }
        header.setContent(section: section, entity: parent)
        header.setActionHandler(actionHandler)
        return header
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
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

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let parent = viewDataState.getParentEntity(section: section) else {
            return
        }
        self.viewDataState.loadChild(sectionId: parent.id, index: section)
    }
}

extension TableViewAdapter {

    private func setup() {
        tableView?.register(GroupCell.self, forCellReuseIdentifier: "cell")
        tableView?.register(GroupHeader.self, forHeaderFooterViewReuseIdentifier: "header")

        viewDataState.renderObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] extraInfo in
                self?.render(extraInfo.render)
                self?.viewDataState.renderFinish(dataFrom: extraInfo.dataFrom)
        }).disposed(by: disposeBag)
    }

    private func render(_ render: ViewDataState.Render) {
        switch render {
        case .none:
            break
        case .fullReload:
            fullReload()
        case .reloadSection(let section):
            reloadSection(section)
        }
    }

    private func reloadSection(_ section: Int) {
        guard let tableView = self.tableView else { return }
        guard section < tableView.numberOfSections else {
            fullReload()
            return
        }
        let task = {
            tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        }
        tableView.performBatchUpdates(task, completion: nil)
    }

    private func fullReload() {
        tableView?.reloadData()
    }
}
