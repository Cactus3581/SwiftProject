//
//  MVVMListSectionViewModel.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/3/12.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

protocol MVVMListSectionViewModelProtocol {

    //  以下的定义没有问题
    static func canHandle(type: String) -> Bool
    init(data: MVVMListSecModel)

    var list: Array<MVVMListSecCellViewModelProtocol>? { set get }
    
    var headerIdentifier: String { get }
    var footerIdentifier: String { get }
    var identifier: String { get }


    /*  以下的定义，因为涉及一个view对应多个sessionViewModel/model的问题，所以：
     1. 需要将数据单独抽出来
     2. 事件也单独列出来

     除非不复用view，那不可能不复用
     复用的情况：
     1. view和model一对一:是非常完美的情况:
     2. 多个view使用一个vm：首先UI样式不一样，但是数据或者说model/vm是一样的，这种情况很少，但是跟第一种情况差不多，也很好处理；
     3. 多个vm使用一个view:现在的情况就是，多个sessionViewModel使用了同一个sectionHeaderView
     */
    var headerTitle: String { get }
    var footerTitle: String { get }

    func jump()
    func click()
}

extension MVVMListSectionViewModelProtocol {

    static func canHandle(type: String) -> Bool {
        return false
    }

    init(data: MVVMListSecModel) {
        self.init(data: data)
    }

    var headerIdentifier: String {
       return ""
    }

    var footerIdentifier: String {
       return ""
    }

    var identifier: String {
       return ""
    }

    var headerTitle: String {
       return ""
    }

    var footerTitle: String {
       return ""
    }

    func jump() {

    }

    func click() {

    }
}

class MVVMListButtonSectionViewModel: MVVMListSectionViewModelProtocol {

    var list: Array<MVVMListSecCellViewModelProtocol>?

    var headerTitle: String
    var footerTitle: String

    static func canHandle(type: String) -> Bool {
        if type == "button" {
            return true
        }
        return false
    }

    required init(data: MVVMListSecModel) {
        self.headerTitle = "button Header"
        self.footerTitle = "button Footer"
        let cellViewModel = MVVMListSecButtonCellViewModel.init(data: data)
        list = [cellViewModel] as? Array<MVVMListSecCellViewModelProtocol>
    }

    var headerIdentifier: String {
       return "MVVMListSectionHeaderView"
    }

    var footerIdentifier: String {
       return "MVVMListSecFooterView"
    }

    var identifier: String {
       return "MVVMListSecButtonTableViewCell"
    }

    func jump() {
        // 通过路由
        print("事件：跳转")
    }

    func click() {
        // 具体事件具体分析
        print("事件：点击")
    }

    func updateData(result: ((MVVMListButtonSectionViewModel) -> ())) {
        // 数据更新
        result(self)
    }
}

class MVVMListGroupSessionViewModel: MVVMListSectionViewModelProtocol {

    var list: Array<MVVMListSecCellViewModelProtocol>? = [MVVMListSecCellViewModelProtocol]()
    var headerTitle: String
    var footerTitle: String

    static func canHandle(type: String) -> Bool {
        if type == "sec" {
            return true
        }
        return false
    }

    required init(data: MVVMListSecModel) {
        self.headerTitle = "Header"
        self.footerTitle = "Footer"
        var list = [Any]()
        for str in data.sec?.list ?? Array() {
            let model = MVVMListSecGroupCellViewModel.init(data: str)
            list.append(model)
        }

        self.list = list as? Array<MVVMListSecCellViewModelProtocol>
    }

    var headerIdentifier: String {
       return "MVVMListSectionHeaderView"
    }

    var footerIdentifier: String {
       return "MVVMListSecFooterView"
    }

    var identifier: String {
       return "MVVMListSecGroupTableViewCell"
    }
}
