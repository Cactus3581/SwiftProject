//
//  SubListVC3.swift
//  UDCCatalog
//
//  Created by 夏汝震 on 2021/7/21.
//  Copyright © 2021 姚启灏. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SubListVC3Model {
    var isExpanded = true
    var row = 3
}

class SubListVC3: UIViewController, UITableViewDelegate, UITableViewDataSource, FeedTeamHeaderDelegate {

    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    var list = [SubListVC3Model]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    
    func setupViews() {
        
        let a1 = SubListVC3Model()
        let a2 = SubListVC3Model()
        let a3 = SubListVC3Model()
        let a4 = SubListVC3Model()
        let a5 = SubListVC3Model()
        let a6 = SubListVC3Model()
        list = [a1, a2, a3, a4, a5, a6]

        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp_topMargin)
            make.leading.trailing.bottom.equalToSuperview()
        }
        tableView.backgroundColor = .white
        tableView.indicatorStyle = .black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let header = UIView()
        header.frame = CGRect(x: 0, y: 0, width: 1, height: CGFloat.leastNormalMagnitude)
        tableView.tableFooterView = header
        let footer = UIView()
        footer.frame = CGRect(x: 0, y: 0, width: 1, height: CGFloat.leastNormalMagnitude)
        tableView.tableHeaderView = footer
        tableView.register(FeedTeamHeader.self, forHeaderFooterViewReuseIdentifier: FeedTeamHeader.identifier)

        tableView.contentInsetAdjustmentBehavior = .never
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
            print(indexPath.row)
            cell.clipsToBounds = true
            cell.contentView.clipsToBounds = true
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.list[indexPath.section]
        if model.isExpanded {
            return 40
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FeedTeamHeader.identifier) as? FeedTeamHeader else {
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
//        self.tableView.beginUpdates()
        self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
//        self.tableView.endUpdates()
//        self.tableView.performBatchUpdates(task, completion: nil)
    }
}
