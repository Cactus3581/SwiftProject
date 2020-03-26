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
    static func canHandle(type: String) -> Bool
    init(dictData: UserProfileModel)
    var headerIdentifier: String? { get }
    var footerIdentifier: String? { get }
    var identifier: String { get }
    var list: Array<Any>? { set get }
    func didSelectCellViewModel(cellViewModel: Any, indexPath: IndexPath)

    var viewHeight: CGFloat? { get } // 高度
    var headerText: String? { get }
}

extension UserProfileSessionViewModelProtocol {
    static func canHandle(type: String) -> Bool {return false}
    init(dictData: UserProfileModel) {self.init(dictData: dictData)}
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
    static let types: Set<String> = ["job","personalStatus"]
    static var type: String = ""
    
    static func canHandle(type: String) -> Bool {
        if types.contains(type) {
            self.type = type
            return true
        }
        return false
    }
    
    required init(dictData: UserProfileModel) {
        super.init()
        let cellViewModel = UserProfileTextCellViewModel()
        
//        if UserProfileCommonSessionViewModel.type == "job" {
//            self.headerText = "职位"
//            cellViewModel.model = dictData.job
//        } else if UserProfileCommonSessionViewModel.type == "personalStatus" {
//            self.headerText = "状态"
//            cellViewModel.model = dictData.personalStatus
//        }
        
        self.list = [cellViewModel]
    }
    
    var headerIdentifier: String? {
        return UserProfileSectionHeaderView.identifier
    }
    
    var identifier: String {
        return UserProfileTextTableViewCell.identifier
    }
}


class UserProfilePhoneSessionViewModel: NSObject, UserProfileSessionViewModelProtocol {
    
    var list: Array<Any>?
    var headerText: String?
    
    static func canHandle(type: String) -> Bool {
        if type == "phone" {
            return true
        }
        return false
    }
    
    required init(dictData: UserProfileModel) {
        super.init()
        let cellViewModel = UserProfilePhoneCellViewModel()
        cellViewModel.model = dictData.profileInfo?.phone
        self.list = [cellViewModel]
        self.headerText = dictData.profileInfo?.phone?.key
    }
    
    var headerIdentifier: String? {
        return UserProfileSectionHeaderView.identifier
    }
    
    var identifier: String {
        return UserProfilePhoneTableViewCell.identifier
    }
}

class UserProfileDepartmentSessionViewModel: NSObject, UserProfileSessionViewModelProtocol {
    
    @objc dynamic var list: Array<Any>?
    var headerText: String?
    var footerText: String?
    var isExpand: Bool = false
    var allList: Array<Any> = [Any]()
    var section: Int?

    static func canHandle(type: String) -> Bool {
        if type == "departments" {
            return true
        }
        return false
    }
    
    required init(dictData: UserProfileModel) {
        super.init()
        for department in dictData.profileInfo?.departments?.departments ?? Array() {
            let cellViewModel = UserProfileDepartmentCellViewModel()
            var name: String = ""
            for meta in department.departments ?? [] {
                if name.count > 0 {
                    if let name1  = meta.name {
                        name =  name + " - " +  name1
                    }
                } else {
                    if let name1  = meta.name {
                        name = name1
                    }
                }
            }

            department.path = name
            cellViewModel.model = department
            allList.append(cellViewModel)
        }
        
        if allList.count > 5 {
            self.list = [] + allList.prefix(5)
        } else {
            self.list = allList
        }
        
        self.headerText = "部门"
        
        if isMoreFive() {
            self.footerText = "展开"
        }
        isExpand = false
    }
    
    var headerIdentifier: String? {
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
            if allList.count > 5 {
                return true
            }
        }
        return false
    }
}

