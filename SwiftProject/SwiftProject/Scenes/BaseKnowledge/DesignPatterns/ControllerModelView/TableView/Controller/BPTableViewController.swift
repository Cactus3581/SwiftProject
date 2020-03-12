//
//  BPTableViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/15.
//  Copyright © 2020 cactus. All rights reserved.
//


import UIKit

class BPTableViewController: BaseViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    fileprivate let viewModel = BPViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func setupViews() {
        tableView?.backgroundColor = UIColor.white
        tableView?.separatorStyle = .singleLine
        tableView?.tableHeaderView = UIView()
        tableView?.tableFooterView = UIView()
        tableView?.estimatedRowHeight = 100
        tableView?.estimatedSectionHeaderHeight = 0
        tableView?.estimatedSectionFooterHeight = 0

        if let array1 = viewModel.array {
            for i in 0..<array1.count {
                let cellViewModel = array1[i]
                tableView?.register(UINib(nibName: cellViewModel.res, bundle: nil), forCellReuseIdentifier: cellViewModel.res)
            }
        }
        tableView?.dataSource = viewModel
    }
}
