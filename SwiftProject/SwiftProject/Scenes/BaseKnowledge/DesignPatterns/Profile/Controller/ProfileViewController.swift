//
//  ProfileViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/2.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: BaseViewController {

    fileprivate let viewModel = ProfileViewModel()
    var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        local_bindViewModel()
    }

    func setupViews() {
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        view.addSubview(tableView!)
        tableView?.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView?.backgroundColor = UIColor.white
        tableView?.separatorStyle = .singleLine
        tableView?.tableHeaderView = UIView()
        tableView?.tableFooterView = UIView()
        tableView?.estimatedRowHeight = 100
        tableView?.estimatedSectionHeaderHeight = 0
        tableView?.estimatedSectionFooterHeight = 0
        tableView?.dataSource = viewModel
        tableView?.register(AboutCell.nib, forCellReuseIdentifier: AboutCell.identifier)
        tableView?.register(NamePictureCell.nib, forCellReuseIdentifier: NamePictureCell.identifier)
        tableView?.register(FriendCell.nib, forCellReuseIdentifier: FriendCell.identifier)
        tableView?.register(AttributeCell.nib, forCellReuseIdentifier: AttributeCell.identifier)
        tableView?.register(EmailCell.nib, forCellReuseIdentifier: EmailCell.identifier)
    }
    
    func local_bindViewModel() {
        for cellVM in viewModel.items {
            if let item = cellVM as? ProfileAboutCellViewModel {
                item.addObserver(self, forKeyPath: "count", options: [.new, .old], context: nil)
            }
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "count" {
            let cellVM = object as? ProfileAboutCellViewModel
            guard let index = viewModel.items.firstIndex(where: { $0 as? ProfileAboutCellViewModel === cellVM }) else { return }
            let indexPath = NSIndexPath.init(item: 0, section: index)
            if let cell = tableView?.cellForRow(at: indexPath as IndexPath) as? AboutCell {
                cell.contentLabel.text = change![NSKeyValueChangeKey.newKey]! as! String
            }
        }
    }

    deinit {
        for cellVM in viewModel.items {
            if let item = cellVM as? ProfileAboutCellViewModel {
                item.removeObserver(self, forKeyPath: "count")
            }
        }
    }
}
