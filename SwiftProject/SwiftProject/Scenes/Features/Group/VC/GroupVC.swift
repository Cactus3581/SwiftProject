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
    let disposeBag: DisposeBag

    let vm: GroupVM
    let tableView: UITableView
    let tableAdapter: TableViewAdapter
    let actionHandler: ActionHandler
    var context: Context?

    init() {
        self.disposeBag = DisposeBag()
        self.vm = GroupVM()
        let tableView = UITableView(frame: .zero, style: .plain)
        self.tableView = tableView
        let actionHandler = ActionHandler(vm: vm)
        self.actionHandler = actionHandler
        self.tableAdapter = TableViewAdapter(vm: vm, table: tableView, actionHandler: actionHandler)
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

    func setup() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
}
