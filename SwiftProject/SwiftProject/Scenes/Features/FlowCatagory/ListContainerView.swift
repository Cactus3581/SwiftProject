//
//  ListContainerView.swift
//  UDCCatalog
//
//  Created by Ryan on 2021/7/5.
//  Copyright © 2021 Ryan. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

// 类似于collectionView
class ListContainerView: UIView {

    var currentScrollView: FeedTableView? {
        return currentListVC?.tableView
    }
    
    private var currentListVC: SubListVC2?
    
    var map = [String: SubListVC2]()
    weak var parentViewController: UIViewController?

    init() {
        super.init(frame: .zero)
        backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func change(key: String) {
        guard let parentViewController = self.parentViewController else { return }
        
        let willShowListVC: SubListVC2
        if let listView = map[key] {
            willShowListVC = listView
        } else {
            willShowListVC = SubListVC2(key: key)
            map[key] = willShowListVC
            parentViewController.addChildController(willShowListVC, parentView: self)
        }
        self.bringSubviewToFront(willShowListVC.view)
        currentListVC = willShowListVC
    }
    
    func remove(key: String) {
        self.map.removeValue(forKey: key)
        currentListVC?.removeSelf()
    }
}

extension UIViewController {

    func addChildController(_ child: UIViewController, parentView: UIView) {
        self.addChild(child)
        parentView.addSubview(child.view)
        child.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        child.didMove(toParent: self)// 通知子视图控制器已经被加入到父视图控制器中
    }

    func removeSelf() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)// 通知子视图控制器将要从父视图控制器中移除
        view.removeFromSuperview()
        self.removeFromParent()
    }
}
