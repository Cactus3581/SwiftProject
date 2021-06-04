//
//  TableViewHeightController.swift
//  SwiftProject
//
//  Created by Ryan on 2020/10/15.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import SnapKit

class TableViewHeightController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView(frame: CGRect.zero, style: .plain)
    let headerView = UIView()

    var array = ["aaaaaaaaaaaaaaaaaaaaa",
                 "bbbbbbbbbbbbbbbbbbbbbb",
                 "ccccccccccccccccccc",
                 "ddddddddddddddddddd",
                 "eeeeeeeeeeeeeeeeee",
                 "ffffffffffffffffff",
                 "gggggggggggggggggg",
                 "hhhhhhhhhhhhhhhhhh",
                 "iiiiiiiiiiiiiiiiii"]


    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        self.tableView.reloadData()
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
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 66
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = 0

        tableView.tableFooterView = UIView()
        tableView.register(TableViewHeightCell.self, forCellReuseIdentifier: "cell")

        self.tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableViewHeightCell {
            cell.label.text = array[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
    }


    func sda() {
        var frame = headerView.bounds
        frame.size.height = 300
        self.tableView.beginUpdates()
        self.headerView.frame = frame
        self.tableView.endUpdates()
    }
}

extension TableViewHeightController {
    // 更改header高度
    // 方法1: 直接改frame，不生效，或者会覆盖掉列表
    // 方法2: 使用beginUpdates，list也会不自然的动画

    // 方法3:加入UIView.animate:貌似cell里的控件会发生变化
    // 方法4:加入performWithoutAnimation：感觉header高度变化时，没有渐变的动画
    // 方法5:tableView.tableHeaderView = nil


    /*
     1. 更新高度是使用begin，还是 = nil
     2. 是否使用 UIView动画
     3. 套performWithoutAnimation
    */
    func updateHeaderHeight(_ height: CGFloat) {
        print("更新高度: \(height)")
        var frame = headerView.bounds
        frame.size.height = height

        UIView.animate(withDuration: 0.25) {
            self.headerView.frame = frame
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }

    func updateHeaderHeight1(_ frame: CGRect, _ type: Int) {

        if type == 1 {
            // 高度不渐变，tableview 有动画而且自然
            self.tableView.beginUpdates()
            self.headerView.frame = frame
            self.tableView.endUpdates()
        } else if type == 2 {
            // 高度渐变，tableview 有动画但是不自然
            UIView.animate(withDuration: 0.25, animations: {
//                self.tableView.beginUpdates()
                self.headerView.frame = frame
                self.tableView.tableHeaderView = self.headerView
//                self.tableView.endUpdates()
            }, completion: { _ in

            })
        }
    }

    func updateHeaderHeight2(_ frame: CGRect, _ type: Int) {
        if type == 1 {
            // header/list两者都没有动画
            self.tableView.tableHeaderView = nil
            self.headerView.frame = frame
            self.tableView.tableHeaderView = self.headerView
        } else if type == 2 {
            // 高度渐变，tableview 有动画但是极其不自然
            UIView.animate(withDuration: 0.25) {
                self.tableView.tableHeaderView = nil
                self.headerView.frame = frame
                self.tableView.tableHeaderView = self.headerView
            }
        }
    }

    func updateHeaderHeight3(_ frame: CGRect, _ type: Int) {
        if type == 1 {
            // 高度不要渐变，tableview 有动画但是不自然
            self.tableView.beginUpdates()
            self.tableView.tableHeaderView = nil
            self.headerView.frame = frame
            self.tableView.tableHeaderView = self.headerView
            self.tableView.endUpdates()
        } else if type == 2 {
            // 高度渐变，tableview 有动画但是不自然
            UIView.animate(withDuration: 0.25) {
                self.tableView.beginUpdates()
                self.tableView.tableHeaderView = nil
                self.headerView.frame = frame
                self.tableView.tableHeaderView = self.headerView
                self.tableView.endUpdates()
            }
        }
    }
}
