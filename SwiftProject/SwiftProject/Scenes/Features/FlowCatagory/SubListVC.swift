//
//  SubListVC.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2021/7/21.
//  Copyright © 2021 Ryan. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SubListVCModel {
    var isExpanded = true
    var row = 3
}

class SubListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FeedSectionHeaderDelegate {

    let tableView = FeedTableView(frame: CGRect.zero, style: .plain)
    var list = [SubListVCModel]()
    let key: String
    init(key: String) {
        self.key = key
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func setupViews() {
        let a1 = SubListVCModel()
        let a2 = SubListVCModel()
        let a3 = SubListVCModel()
        let a4 = SubListVCModel()
        let a5 = SubListVCModel()
        let a6 = SubListVCModel()
        list = [a1, a2, a3, a4, a5, a6]
        
        let wrapperScrollView = UIScrollView()
        self.view.addSubview(wrapperScrollView)
        wrapperScrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        wrapperScrollView.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.snp.makeConstraints { (make) in
            make.size.edges.equalToSuperview()
        }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.indicatorStyle = .black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        tableView.register(FeedSectionHeader.self, forHeaderFooterViewReuseIdentifier: FeedSectionHeader.identifier)

        tableView.contentInsetAdjustmentBehavior = .never
        wrapperScrollView.contentInsetAdjustmentBehavior = .never
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let firstVisibleCell = tableView.cellForRow(at: indexPath)
        if let cell = firstVisibleCell {
            let y = cell.convert(CGPoint.zero, to: view).y
            print("yyyyyy: cellY: \(cell.frame.origin.y), y: \(y)")
        }
        self.dismiss(animated: true, completion: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        self.list.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = self.list[section]
        if model.isExpanded {
            return model.row
        }
        return model.row
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell.textLabel?.text = "\(indexPath.row)"
            cell.clipsToBounds = true
            cell.contentView.clipsToBounds = true
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.list[indexPath.section]
        if model.isExpanded {
            return 30
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FeedSectionHeader.identifier) as? FeedSectionHeader else {
            return UITableViewHeaderFooterView(frame: .zero)
        }
        let model = self.list[section]
        header.set(model, section)
        header.delegate = self
        header.clipsToBounds = true
        header.contentView.clipsToBounds = true
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func expandAction(_ section: Int) {
        let model = self.list[section]
        model.isExpanded = !model.isExpanded
        let task = {
            // ❌：top right bottom middle none
            // ✅：fade、automatic
            self.tableView.reloadSections(IndexSet(integer: section), with: .fade)
        }
        self.tableView.performBatchUpdates(task, completion: nil)
    }
}
