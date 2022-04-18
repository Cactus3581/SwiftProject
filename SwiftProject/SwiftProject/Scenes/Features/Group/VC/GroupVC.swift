//
//  GroupVC.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2022/4/2.
//  Copyright © 2022 cactus. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class GroupVC: BaseViewController {
    private let disposeBag: DisposeBag

    let vm: GroupVM
    private let tableView: UITableView
    private let tableAdapter: TableViewAdapter
    let actionHandler: ActionHandler
    var context: Context?

    init() {
        self.disposeBag = DisposeBag()
        self.vm = GroupVM()
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        #if swift(>=5.5)
        if #available(iOS 15.0, *) {
            tableView.fillerRowHeight = 0
            tableView.sectionHeaderTopPadding = .zero
        }
        #endif
        self.tableView = tableView
        let actionHandler = ActionHandler(vm: vm)
        self.actionHandler = actionHandler
        self.tableAdapter = TableViewAdapter(table: tableView, viewDataState: vm.viewDataState, actionHandler: actionHandler)
        super.init(nibName: nil, bundle: nil)
        tableView.delegate = tableAdapter
        tableView.dataSource = tableAdapter
        self.context = Context(vc: self)
    }

    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })

        vm.viewDataState.stateObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                self?.handleState(state)
        }).disposed(by: disposeBag)
    }

    private func handleState(_ state: ViewDataState.State) {
        switch state {
        case .loading:
            break

        case .loaded:
            break

        case .empty:
            break
        }
    }
}
