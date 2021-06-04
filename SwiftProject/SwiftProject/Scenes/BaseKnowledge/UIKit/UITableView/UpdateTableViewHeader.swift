//
//  UpdateTableViewHeader.swift
//  SwiftProject
//
//  Created by Ryan on 2021/1/28.
//  Copyright © 2021 cactus. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class UpdateTableViewHeaderController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView(frame: CGRect.zero, style: .plain)
    let headerView = UIView()
    let label = UILabel()

    var expanded = false
    var transform = true

    var array = ["aaaaaaaaaaaaaaaaaaaaa",
                 "bbbbbbbbbbbbbbbbbbbbbb",
                 "ccccccccccccccccccc",
                 "ddddddddddddddddddd",
                 "eeeeeeeeeeeeeeeeee",
                 "ffffffffffffffffff",
                 "gggggggggggggggggg",
                 "hhhhhhhhhhhhhhhhhh",
                 "iiiiiiiiiiiiiiiiii"]

    private let headerHeight: CGFloat = 0
    private let pullHeight: CGFloat = 60 // 下拉到60就展开
    private let headerHeightForExpand: CGFloat = 400

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

        headerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: headerHeight)
        headerView.backgroundColor = .green
        label.frame = CGRect(x: 0, y: headerHeight-30, width: 100, height: 30)
        label.text = "label"
        headerView.addSubview(label)
        tableView.tableHeaderView = headerView

        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        self.tableView.reloadData()
        let naviHeight: CGFloat = 188
        //tableView.contentInset = UIEdgeInsets(top: naviHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -naviHeight)
        //tableView.scrollIndicatorInsets = UIEdgeInsets(top: naviHeight, left: 0, bottom: 0, right: 0)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = .white
        cell.textLabel?.text = array[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sda()
        sda()
//        if transform {
//            updateHeaderHeight(300)
//        } else {
//            updateHeaderHeight(100)
//        }
//        transform = !transform
    }

    func sda() {
        var frame = headerView.bounds
        frame.size.height = 300
        self.tableView.beginUpdates()
        self.headerView.frame = frame
        self.tableView.endUpdates()
    }
}

extension UpdateTableViewHeaderController {
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

extension UpdateTableViewHeaderController {

    // 结束拖拽
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 下拉松手展开
//        let offsetY = scrollView.contentOffset.y + 88
//        print("scrollViewDidEndDragging: \(offsetY)")
//        expand(offsetY)
    }

    // 吸顶 -> 展开 -> 上滑真收起（干掉上滑动假收起）
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("offsetY: \(scrollView.contentOffset.y)")
//        let offsetY = scrollView.contentOffset.y + 88
//        label.text = "\(offsetY)"
//        print("scrollViewDidScroll: \(offsetY)")
//        collapse(offsetY)
    }

    // 展开
    func expand(_ offsetY: CGFloat) {
        if !self.expanded && offsetY < 0 && abs(offsetY) >= pullHeight {
            print("即将展开: \(offsetY)")
            label.text = "即将展开:  \(offsetY)"
            expanded = true
            var frame = headerView.bounds
            frame.size.height = headerHeightForExpand
            self.tableView.beginUpdates()
            self.headerView.frame = frame
            self.tableView.endUpdates()
        }
    }

    // 收起
    func collapse(_ offsetY: CGFloat) {
        if expanded && offsetY >= headerHeightForExpand {
            print("即将收起: \(offsetY)")
            label.text = "即将收起:  \(offsetY)"
            expanded = false
            var scrollBounds = tableView.bounds
            scrollBounds.origin.y = (headerHeight) - 88
            tableView.bounds = scrollBounds

            var frame = headerView.bounds
            frame.size.height = headerHeight

            UIView.performWithoutAnimation {
                self.tableView.beginUpdates()
                self.headerView.frame = frame
                self.tableView.endUpdates()
            }
        }
    }
}
