//
//  TableViewViewController.swift
//  SwiftProject
//
//  Created by Ryan on 2020/8/23.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import SnapKit

class TableViewViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView(frame: CGRect.zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func initializeUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.indicatorStyle = .black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .singleLine

        //warning: 注意不能是CGFLOAT_MIN
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0

        tableView.tableFooterView = UIView()
        tableView.register(TableViewHeightCell.self, forCellReuseIdentifier: "cell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableViewHeightCell {
            cell.label.text = "\(indexPath.row)"
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 设置某项变为未选中
//        self.tableView.deselectRow(at: indexPath, animated: false)
    }
}
