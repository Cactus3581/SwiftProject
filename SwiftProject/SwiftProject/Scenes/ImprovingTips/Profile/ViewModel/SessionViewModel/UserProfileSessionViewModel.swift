//
//  UserProfileViewModel.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/3/12.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

//MARK:该协议服务于sessionViewModel，为sessionView提供数据和事件。协议的作用就是解决通用性问题，替代继承用的
protocol UserProfileViewModelProtocol {
    static func canHandle(type: String) -> Bool
    init(dictData: UserProfileModel)
    init(arrayData: UserProfileSessionModel)
    var headerIdentifier: String { get }
    var identifier: String { get } //现在默认sessionViewm只有一种cell类型，所以可以放到sessionViewModelProtocol协议里，如果以后需要支持sessionView存在多种cell类型，需要放到CellViewModelProtocol里
    var list: Array<Any>? { set get }
}

extension UserProfileViewModelProtocol {
    static func canHandle(type: String) -> Bool {return false}
    init(dictData: UserProfileModel) {self.init(dictData: dictData)}
    var headerIdentifier: String {return ""}
    var identifier: String {return ""}
}

//MARK:针对多对1问题提供的方案
protocol UserProfileTextViewModelProtocol: UserProfileViewModelProtocol {
    var headerText: String? { get }
}

extension UserProfileTextViewModelProtocol {
    var headerText: String? {return ""}
}

//MARK:五种组合
class UserProfileTextListeningSectionViewModel: UserProfileTextViewModelProtocol {

    var list: Array<Any>?

    var headerText: String?

    static func canHandle(type: String) -> Bool {
        if type == "listening" {
            return true
        }
        return false
    }

    required init(dictData: UserProfileModel) {

        self.headerText = "Text Listening Header"

        let cellViewModel = UserProfileListeningCellViewModel()
        let model = dictData as UserProfileModel
        cellViewModel.model = model.listening
        list = [cellViewModel] as Array<Any>
    }

    required init(arrayData: UserProfileSessionModel) {
        var list = [Any]()
        self.headerText = arrayData.header?.title
        for dict in arrayData.list ?? [] {
            if let itemModel = UserProfileListeningModel.deserialize(from: dict as? [String:Any]) {
                let cellViewModel = UserProfileListeningCellViewModel()
                cellViewModel.model = itemModel
                list.append(cellViewModel)
            }
        }
        self.list = list as Array<Any>
    }

    var headerIdentifier: String {
        return UserProfileSectionHeaderView.identifier
    }

    var identifier: String {
        return UserProfileListeningTableViewCell.identifier
    }


    func headerJump() {
        // 通过路由
        print("Text Header跳转")
    }
}

class UserProfileTextAdsSectionViewModel: UserProfileTextViewModelProtocol {

    var list: Array<Any>?

    var headerText: String?

    static func canHandle(type: String) -> Bool {
        if type == "ads" {
            return true
        }
        return false
    }

    required init(dictData: UserProfileModel) {

        self.headerText = "Text Ads Header"

        let cellViewModel = UserProfileListeningCellViewModel()
        let model = dictData as UserProfileModel
        cellViewModel.model = model.ads
        list = [cellViewModel] as Array<Any>
    }

    required init(arrayData: UserProfileSessionModel) {
        var list = [Any]()
        self.headerText = arrayData.header?.title
        for dict in arrayData.list ?? [] {
            if let itemModel = UserProfileListeningModel.deserialize(from: dict as? [String:Any]) {
                let cellViewModel = UserProfileListeningCellViewModel()
                cellViewModel.model = itemModel
                list.append(cellViewModel)
            }
        }
        self.list = list as Array<Any>
    }

    var headerIdentifier: String {
        return UserProfileSectionHeaderView.identifier
    }

    var identifier: String {
        return UserProfileListeningTableViewCell.identifier
    }

    func headerJump() {
        print("Text Header跳转")
    }


}

class UserProfileTextSpeakSessionViewModel: UserProfileTextViewModelProtocol {

    var list: Array<Any>?

    var headerText: String?

    static func canHandle(type: String) -> Bool {
        if type == "speak" {
            return true
        }
        return false
    }

    required init(dictData: UserProfileModel) {
        self.headerText = "Text Speak Header"
        var list = [Any]()
        for speakItemModel in dictData.speak?.list ?? Array() {
            let cellViewModel = UserProfileSpeakCellViewModel()
            cellViewModel.model = speakItemModel
            list.append(cellViewModel)
        }
        self.list = list as Array<Any>
    }

    required init(arrayData: UserProfileSessionModel) {
        var list = [Any]()
        self.headerText = arrayData.header?.title
        for dict in arrayData.list ?? [] {
            if let itemModel = UserProfileSpeakItemModel.deserialize(from: dict as? [String:Any]) {
                let cellViewModel = UserProfileSpeakCellViewModel()
                cellViewModel.model = itemModel
                list.append(cellViewModel)
            }
        }
        self.list = list as Array<Any>
    }

    var headerIdentifier: String {
        return UserProfileSectionHeaderView.identifier
    }

    var identifier: String {
        return UserProfileCourseTableViewCell.identifier
    }

    func headerJump() {
        print("Header 事件：跳转")
    }
}

