//
//  UserProfileThreePointsItemViewModel.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/3/24.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

protocol UserProfileThreePointsItemViewModelProtocol {
    static func canHandle(type: String) -> Bool
    init(title: String)
    var title: String? {set get}
    func didClickSheet()
}

extension UserProfileThreePointsItemViewModelProtocol {
    static func canHandle(type: String) -> Bool {return false}
    init(title: String){self.init(title: title)}
    var title: String? { set{} get{return nil} }
    func didClickSheet(){}
}

class UserProfileReportItemViewModel: NSObject, UserProfileThreePointsItemViewModelProtocol {

    var title: String?

    static func canHandle(type: String) -> Bool {
        if type == "report" {
            return true
        }
        return false
    }
    
    required init(title: String) {
        self.title = title
        super.init()
    }

    func didClickSheet() {
        print("点击了举报")
    }
}

class UserProfileSuggessItemViewModel: NSObject, UserProfileThreePointsItemViewModelProtocol {

    var title: String?

    static func canHandle(type: String) -> Bool {
        if type == "suggest" {
            return true
        }
        return false
    }

    required init(title: String) {
        self.title = title
        super.init()
    }

    func didClickSheet() {
        print("点击了建议")
    }
}
