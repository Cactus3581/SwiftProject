//
//  UserProfileViewModel.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/12.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

//MARK:该协议服务于sessionViewModel，为sessionView提供数据和事件。协议的作用就是解决通用性问题，替代继承用的
protocol UserProfileSessionViewModelProtocol {
    static func canHandle(type: Int) -> Bool
    init(profileItem: [String: Any])
    var headerIdentifier: String? { get }
    var footerIdentifier: String? { get }
    var identifier: String { get }
    var list: Array<Any>? { set get }
    func didSelectCellViewModel(cellViewModel: Any, indexPath: IndexPath)

    var viewHeight: CGFloat? { get } // 高度
    var headerText: String? { get }
}

extension UserProfileSessionViewModelProtocol {
    static func canHandle(type: Int) -> Bool {return false}
    init(profileItem: [String: Any]) {self.init(profileItem: profileItem)}
    var headerIdentifier: String? {return nil}
    var footerIdentifier: String? {return nil}
    var list: Array<Any>? { set{} get{return nil} }

    var viewHeight: CGFloat? { return 60 }
    var headerText: String? {return nil}
    func didSelectCellViewModel(cellViewModel: Any, indexPath: IndexPath){}
}

class UserProfileTextSessionViewModel: NSObject, UserProfileSessionViewModelProtocol {
    
    var list: Array<Any>?
    var headerText: String?
    var profileItem: TextItem?

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

    var headerIdentifier: String? {
        guard let _ = self.profileItem?.key, let list = self.list, list.count > 0 else {
            return nil
        }
        return UserProfileSectionHeaderView.identifier
    }

    var identifier: String {
        return UserProfileTextTableViewCell.identifier
    }
}

class UserProfileLinkSessionViewModel: NSObject, UserProfileSessionViewModelProtocol {

    var list: Array<Any>?
    var headerText: String?
    var profileItem: LinkItem?

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

    var headerIdentifier: String? {
        guard let _ = self.profileItem?.key, let list = self.list, list.count > 0, let linkTitle = self.profileItem?.linkTitle, !linkTitle.isEmpty else {
            return nil
        }
        return UserProfileSectionHeaderView.identifier
    }

    var identifier: String {
        return UserProfileLinkTableViewCell.identifier
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
            for department in departments {
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
                cellViewModel.path = path
                cellViewModel.model = department
                allList.append(cellViewModel)
            }
        }
        
        if allList.count > maxCount {
            self.list = [] + allList.prefix(maxCount)
        } else {
            self.list = allList
        }

        self.headerText = self.profileItem?.key
        isExpand = false
        if isMoreFive() {
            self.footerText = "展开"
        }
    }

    var headerIdentifier: String? {
        guard let _ = self.profileItem?.key, let list = self.list, list.count > 0 else {
            return nil
        }
        return UserProfileSectionHeaderView.identifier
    }


    var footerIdentifier: String? {
        if isMoreFive() {
            return UserProfileSectionFooterView.identifier
        }
        return nil
    }
    
    var identifier: String {
        if isMuilt() {
            return UserProfileMultiDepartmentTableViewCell.identifier
        }
        return UserProfileTextTableViewCell.identifier
    }
    
    func reloadData (section: Int) {
        isExpand = !isExpand
        self.section = section
        if isExpand {
            self.footerText = "收起"
            self.list = allList
        } else {
            self.footerText = "展开"
            self.list = [] + allList.prefix(5)
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

    var headerIdentifier: String? {
        guard let _ = self.profileItem?.key, let list = self.list, list.count > 0 else {
            return nil
        }
        return UserProfileSectionHeaderView.identifier
    }

    var identifier: String {
        return UserProfilePhoneTableViewCell.identifier
    }
}

class UserProfileUserStatusSessionViewModel: NSObject, UserProfileSessionViewModelProtocol {

    var list: Array<Any>?
    var headerText: String?
    var profileItem: UserStatusItem?

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

    var headerIdentifier: String? {
        guard let _ = self.profileItem?.key, let list = self.list, list.count > 0 else {
            return nil
        }
        return UserProfileSectionHeaderView.identifier
    }

    var identifier: String {
        return UserProfileUserStatusTableViewCell.identifier
    }
}

class UserProfileAliasSessionViewModel: NSObject, UserProfileSessionViewModelProtocol {

    var list: Array<Any>?
    var headerText: String?
    var profileItem: AliasItem?

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

    var headerIdentifier: String? {
        guard let _ = self.profileItem?.key, let list = self.list, list.count > 0 else {
            return nil
        }
        return UserProfileSectionHeaderView.identifier
    }

    var identifier: String {
        return UserProfileAliasTableViewCell.identifier
    }
}
