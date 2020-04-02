//
//  UserProfileViewModel.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/12.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

//MARK:该协议服务于sessionViewModel，为sessionView提供数据和事件。协议的作用就是解决通用性问题，替代继承用的
protocol UserProfileSessionViewModelProtocol {
    static func canHandle(type: Int) -> Bool
    init(profileItem: [String: Any])
    var headerIdentifier: String? { get }
    var footerIdentifier: String? { get }
    var identifier: String { get }
    var list: Array<Any>? { set get }
    func didSelectCellViewModel(cellViewModel: Any, indexPath: IndexPath)

    var headerHeight: CGFloat? { get }
    var footerHeight: CGFloat? { get }
    var headerText: String? { get }
}

extension UserProfileSessionViewModelProtocol {
    static func canHandle(type: Int) -> Bool {return false}
    init(profileItem: [String: Any]) {self.init(profileItem: profileItem)}
    var headerIdentifier: String? {return nil}
    var footerIdentifier: String? {return nil}
    var list: Array<Any>? { set{} get{return nil} }

    var headerHeight: CGFloat? { return CGFloat.leastNormalMagnitude }
    var footerHeight: CGFloat? { return CGFloat.leastNormalMagnitude }
    var headerText: String? {return nil}
    func didSelectCellViewModel(cellViewModel: Any, indexPath: IndexPath){}
}

class UserProfileTextSessionViewModel: NSObject, UserProfileSessionViewModelProtocol {
    
    var list: Array<Any>?
    var headerText: String?
    var profileItem: TextItem?
    var headerHeight: CGFloat?
    var footerHeight: CGFloat?

    static func canHandle(type: Int) -> Bool {
        if type == 1 {
            return true
        }
        return false
    }
    
    required init(profileItem: [String: Any]) {
        super.init()
        self.profileItem = TextItem.deserialize(from: profileItem)
        self.headerText = self.profileItem?.key

        let cellViewModel = UserProfileTextCellViewModel()
        cellViewModel.model = self.profileItem
        self.list = [cellViewModel]
    }

    var footerIdentifier: String? {
        guard let list = self.list, list.count > 0 else {
            return nil
        }
        self.footerHeight = 1/UIScreen.main.scale
        return UserProfileLineSectionFooterView.identifier
    }

    var identifier: String {
        return UserProfileTextTableViewCell.identifier
    }
}

class UserProfileLinkSessionViewModel: NSObject, UserProfileSessionViewModelProtocol {

    var list: Array<Any>?
    var headerText: String?
    var profileItem: LinkItem?
    var headerHeight: CGFloat?
    var footerHeight: CGFloat?

    static func canHandle(type: Int) -> Bool {
        if type == 2 {
            return true
        }
        return false
    }

    required init(profileItem: [String: Any]) {
        super.init()
        self.profileItem = LinkItem.deserialize(from: profileItem)
        self.headerText = self.profileItem?.key
        let cellViewModel = UserProfileLinkCellViewModel()
        cellViewModel.model = self.profileItem
        self.list = [cellViewModel]
    }

    var footerIdentifier: String? {
        guard let list = self.list, list.count > 0 else {
            return nil
        }
        self.footerHeight = 1/UIScreen.main.scale
        return UserProfileLineSectionFooterView.identifier
    }

    var identifier: String {
        return UserProfileLinkTableViewCell.identifier
    }

    func didSelectCellViewModel(cellViewModel: Any, indexPath: IndexPath) {
        let cellViewModel = cellViewModel as? UserProfileLinkCellViewModel
        print("点击链接")
    }
}

class UserProfileDepartmentSessionViewModel: NSObject, UserProfileSessionViewModelProtocol {
    
    @objc dynamic var list: Array<Any>?
    var headerText: String?
    var footerText: String?
    var isExpand: Bool = false
    var allList: Array<Any> = [Any]()
    var section: Int?
    var profileItem: DepartmentsItem?
    var maxCount = 5
    var headerHeight: CGFloat?
    var footerHeight: CGFloat?
    var obList: PublishSubject<Int>?

    static func canHandle(type: Int) -> Bool {
        if type == 3 {
            return true
        }
        return false
    }
    
    required init(profileItem: [String: Any]) {
        super.init()
        self.profileItem = DepartmentsItem.deserialize(from: profileItem)
        if let departments = self.profileItem?.departments {
            for (index, department) in departments.enumerated() {
                guard let departments = department.departments else {
                    continue
                }
                let cellViewModel = UserProfileDepartmentCellViewModel()
                var path: String = ""
                for meta in departments {
                    guard let name = meta.name else {
                        continue
                    }
                    if path.count <= 0 {
                        path = name
                    } else {
                        path =  path + " - " + name
                    }
                }
                if index == 0 {
                    cellViewModel.topic = self.profileItem?.key
                }
                cellViewModel.path = path
                cellViewModel.model = department
                allList.append(cellViewModel)
            }
        }

        obList = PublishSubject.init()

        if allList.count > maxCount {
            self.list = [] + allList.prefix(maxCount)
            if let list = self.list, list.count > 1 {
                for (index, cellViewModel) in list.enumerated() {
                    let cellViewModel = cellViewModel as? UserProfileDepartmentCellViewModel
                    cellViewModel?.isFirstOffset = false
                    cellViewModel?.isLastOffset = false
                    if index == 0 {
                        cellViewModel?.isFirstOffset = true
                    } else if index == list.count - 1 {
                        cellViewModel?.isLastOffset = true
                    }
                }
            }
        } else {
            self.list = allList
            if let list = self.list {
                for (index, cellViewModel) in list.enumerated() {
                  let cellViewModel = cellViewModel as? UserProfileDepartmentCellViewModel
                  cellViewModel?.isFirstOffset = false
                  cellViewModel?.isLastOffset = false
                  if index == 0 {
                      cellViewModel?.isFirstOffset = true
                  } else if index == list.count - 1 {
                      cellViewModel?.isLastOffset = true
                  }
                }
            }
        }

        self.headerText = self.profileItem?.key
        isExpand = false
        if isMoreFive() {
            self.footerText = "展开更多部门"
        }
    }

    var footerIdentifier: String? {
        if isMoreFive() {
            self.footerHeight = 40
            return UserProfileDeparmentSectionFooterView.identifier
        }

        guard let list = self.list, list.count > 0 else {
            return nil
        }
        self.footerHeight = 1/UIScreen.main.scale
        return UserProfileLineSectionFooterView.identifier
    }

    var identifier: String {
        if isMuilt() {
            return UserProfileMultiDepartmentTableViewCell.identifier
        }
        return UserProfileDepartmentTableViewCell.identifier
    }
    
    func reloadData (section: Int) {
        isExpand = !isExpand
        self.section = section
        if isExpand {
            self.footerText = "收起"
            let list = allList
            if list.count > 1 {
                for (index, cellViewModel) in list.enumerated() {
                    let cellViewModel = cellViewModel as? UserProfileDepartmentCellViewModel
                    cellViewModel?.isFirstOffset = false
                    cellViewModel?.isLastOffset = false
                    if index == 0 {
                        cellViewModel?.isFirstOffset = true
                    } else if index == list.count - 1 {
                        cellViewModel?.isLastOffset = true
                    }
                }
            }
            self.list = list
            obList?.onNext(self.section ?? 0)
        } else {
            self.footerText = "展开更多部门"
            let list = [] + allList.prefix(5)
            if list.count > 1 {
                for (index, cellViewModel) in list.enumerated() {
                    let cellViewModel = cellViewModel as? UserProfileDepartmentCellViewModel
                    cellViewModel?.isFirstOffset = false
                    cellViewModel?.isLastOffset = false
                    if index == 0 {
                        cellViewModel?.isFirstOffset = true
                    } else if index == list.count - 1 {
                        cellViewModel?.isLastOffset = true
                    }
                }
            }
            self.list = list
            obList?.onNext(self.section ?? 0)
        }
    }
    
    func isMuilt() -> Bool {
        if allList.count > 1 {
            return true
        }
        return false
    }
    
    func isMoreFive() -> Bool {
        if isMuilt() {
            if allList.count > maxCount {
                return true
            }
        }
        return false
    }
}


class UserProfilePhoneSessionViewModel: NSObject, UserProfileSessionViewModelProtocol {

    var list: Array<Any>?
    var headerText: String?
    var profileItem: PhoneItem?
    var headerHeight: CGFloat?
    var footerHeight: CGFloat?

    static func canHandle(type: Int) -> Bool {
        if type == 4 {
            return true
        }
        return false
    }

    required init(profileItem: [String: Any]) {
        super.init()
        self.profileItem = PhoneItem.deserialize(from: profileItem)
        let cellViewModel = UserProfilePhoneCellViewModel()
        cellViewModel.model = self.profileItem
        self.list = [cellViewModel]
        self.headerText = self.profileItem?.key
    }

    var footerIdentifier: String? {
        guard let list = self.list, list.count > 0 else {
            return nil
        }
        self.footerHeight = 1/UIScreen.main.scale
        return UserProfileLineSectionFooterView.identifier
    }

    var identifier: String {
        return UserProfilePhoneTableViewCell.identifier
    }

    func didSelectCellViewModel(cellViewModel: Any, indexPath: IndexPath) {
        let cellViewModel = cellViewModel as? UserProfilePhoneCellViewModel
        print("点击手机号")
    }
}

class UserProfileUserStatusSessionViewModel: NSObject, UserProfileSessionViewModelProtocol {

    var list: Array<Any>?
    var headerText: String?
    var profileItem: UserStatusItem?
    var headerHeight: CGFloat?
    var footerHeight: CGFloat?

    static func canHandle(type: Int) -> Bool {
        if type == 5 {
            return true
        }
        return false
    }

    required init(profileItem: [String: Any]) {
        super.init()
        self.profileItem = UserStatusItem.deserialize(from: profileItem)
        let cellViewModel = UserProfileUserStatusCellViewModel()
        cellViewModel.model = self.profileItem
        self.list = [cellViewModel]
        self.headerText = self.profileItem?.key
    }

    func didSelectCellViewModel(cellViewModel: Any, indexPath: IndexPath) {
        let cellViewModel = cellViewModel as? UserProfileUserStatusCellViewModel
        print("点击描述")
    }



    var footerIdentifier: String? {
        guard let list = self.list, list.count > 0 else {
            return nil
        }
        self.footerHeight = 1/UIScreen.main.scale
        return UserProfileLineSectionFooterView.identifier
    }

    var identifier: String {
        return UserProfileUserStatusTableViewCell.identifier
    }
}

class UserProfileAliasSessionViewModel: NSObject, UserProfileSessionViewModelProtocol {

    var list: Array<Any>?
    var headerText: String?
    var profileItem: AliasItem?
    var headerHeight: CGFloat?
    var footerHeight: CGFloat?

    static func canHandle(type: Int) -> Bool {
        if type == 6 {
            return true
        }
        return false
    }

    required init(profileItem: [String: Any]) {
        super.init()
        self.profileItem = AliasItem.deserialize(from: profileItem)
        let cellViewModel = UserProfileAliasCellViewModel()
        cellViewModel.model = self.profileItem
        self.list = [cellViewModel]
        self.headerText = self.profileItem?.key
    }

    func didSelectCellViewModel(cellViewModel: Any, indexPath: IndexPath) {
        let cellViewModel = cellViewModel as? UserProfileAliasCellViewModel
        print("点击备注")
    }



    var footerIdentifier: String? {
        guard let list = self.list, list.count > 0 else {
            return nil
        }
        self.footerHeight = 1/UIScreen.main.scale
        return UserProfileLineSectionFooterView.identifier
    }

    var identifier: String {
        return UserProfileAliasTableViewCell.identifier
    }
}
