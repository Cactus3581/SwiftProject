//
//  SubListVC22.swift
//  UDCCatalog
//
//  Created by 夏汝震 on 2021/7/21.
//  Copyright © 2021 姚启灏. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SubListVC2: UIViewController, UITableViewDelegate, UITableViewDataSource, FeedTeamHeaderDelegate {

    let tableView = FeedTableView(frame: CGRect.zero, style: .plain)
    var isExpanded = true

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setupViews() {
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
        tableView.register(FeedTeamHeader.self, forHeaderFooterViewReuseIdentifier: FeedTeamHeader.identifier)

        tableView.contentInsetAdjustmentBehavior = .never
        wrapperScrollView.contentInsetAdjustmentBehavior = .never
        
//        tableView.bounces = false
//        tableView.bounces = false
//        tableView.alwaysBounceVertical = false
//        wrapperScrollView.alwaysBounceVertical = false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let firstVisibleCell = tableView.cellForRow(at: indexPath)
        if let cell = firstVisibleCell {
            let y = cell.convert(CGPoint.zero, to: view).y
            print("yyyyyy: cellY: \(cell.frame.origin.y), y: \(y)")
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isExpanded {
            return 30
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell.textLabel?.text = "\(key): \(indexPath.row)"
            print(indexPath.row)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        100
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FeedTeamHeader.identifier) as? FeedTeamHeader else {
//            return UITableViewHeaderFooterView(frame: .zero)
//        }
////        header.set(isExpanded, section)
//        header.delegate = self
//        return header
//    }

    func expandAction(_ section: Int) {
        self.isExpanded = !isExpanded
        let task = {
            // ❌：top right bottom middle none
            // ✅：fade、automatic
            self.tableView.reloadSections(IndexSet(integer: section), with: .fade)
        }
        self.tableView.performBatchUpdates(task, completion: nil)
    }
}
