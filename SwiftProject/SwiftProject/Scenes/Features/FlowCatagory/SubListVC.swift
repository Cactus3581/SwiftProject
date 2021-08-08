//
//  SubListVC.swift
//  UDCCatalog
//
//  Created by Ryan on 2021/7/5.
//  Copyright © 2021 Ryan. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SubListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = FeedTableView(frame: CGRect.zero, style: .plain)

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
        tableView.backgroundColor = .green
        tableView.snp.makeConstraints { (make) in
            make.size.edges.equalToSuperview()
        }
        tableView.indicatorStyle = .black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 150
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
}
