//
//  TableViewViewController.swift
//  SwiftProject
//
//  Created by Ryan on 2020/8/23.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import SnapKit

class TestTableView: UITableView, UIGestureRecognizerDelegate {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap))
        tap.delegate = self
        self.addGestureRecognizer(tap)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan))
        pan.delegate = self
        self.addGestureRecognizer(pan)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func tap() {
        print("event-1-tap")
    }

    @objc
    func pan() {
        print("event-1-pan")
    }

    // 查找
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 判断下view能否接收事件, 点在不在view上
        guard isUserInteractionEnabled, !isHidden, alpha > 0.01, self.point(inside: point, with: event) else { return nil }
        return self
    }

    // UIResponder：触摸事件的处理方法,继承重写
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("event-1-touchesBegan")
//        super.touchesBegan(touches, with: event)
    }

    // 手势：手势事件的处理方法
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer.view == self else {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        guard panGestureRecognizer == gestureRecognizer else {
            return false
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
}

class TableViewViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    private let tableView = TestTableView(frame: CGRect.zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let selectIndexPath = self.tableView.indexPathForSelectedRow {
//            self.tableView.deselectRow(at: selectIndexPath, animated: false)
        }
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
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.red
        self.navigationController?.pushViewController(vc, animated: true)
        // 设置某项变为未选中
//        self.tableView.deselectRow(at: indexPath, animated: false)
    }
}
