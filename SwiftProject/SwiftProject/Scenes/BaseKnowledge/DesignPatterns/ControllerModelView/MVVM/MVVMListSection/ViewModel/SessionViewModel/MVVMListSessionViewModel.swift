//
//  MVVMListSectionViewModel.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/12.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

//MARK:该协议服务于sessionViewModel，为sessionView提供数据和事件。协议的作用就是解决通用性问题，替代继承用的
protocol MVVMListSectionViewModelProtocol {
    static func canHandle(type: String) -> Bool
    init(dictData: MVVMListSecModel)
    init(arrayData: MVVMListSessionModel)

    var headerIdentifier: String { get }
    var footerIdentifier: String { get }

    var identifier: String { get } //现在默认sessionViewm只有一种cell类型，所以可以放到sessionViewModelProtocol协议里，如果以后需要支持sessionView存在多种cell类型，需要放到CellViewModelProtocol里

    var list: Array<Any>? { set get }
}

extension MVVMListSectionViewModelProtocol {
    static func canHandle(type: String) -> Bool {return false}
    init(dictData: MVVMListSecModel) {self.init(dictData: dictData)}

    var headerIdentifier: String {return ""}
    var footerIdentifier: String {return ""}
    var identifier: String {return ""}
}

//MARK:针对多对1问题提供的方案
protocol MVVMListSectionTextViewModelProtocol: MVVMListSectionViewModelProtocol {
    var headerText: String? { get }
    var footerText: String? { get }
    func headerJump()
    func footerClick()
}

extension MVVMListSectionTextViewModelProtocol {
    var headerText: String? {return ""}
    var footerText: String? {return ""}

    func headerJump() {}
    func footerClick() {}
}

protocol MVVMListSectionImageViewModelProtocol: MVVMListSectionViewModelProtocol {
    var headerImageUrl: String? { get }
    var footerImageUrl: String? { get }

    func headerShowToast()
    func footerShowAlert()
}

extension MVVMListSectionImageViewModelProtocol {
    var headerImageUrl: String? {return ""}
    var footerImageUrl: String? {return ""}
    func headerShowToast(){}
    func footerShowAlert(){}
}

//MARK:五种组合
class MVVMListTextListeningSectionViewModel: MVVMListSectionTextViewModelProtocol {

    var list: Array<Any>?

    var headerText: String?
    var footerText: String?

    static func canHandle(type: String) -> Bool {
        if type == "listening" {
            return true
        }
        return false
    }

    required init(dictData: MVVMListSecModel) {

        self.headerText = "Text Listening Header"
        self.footerText = "Text Listening Footer"

        let cellViewModel = MVVMListListeningCellViewModel()
        let model = dictData as MVVMListSecModel
        cellViewModel.model = model.listening
        list = [cellViewModel] as Array<Any>
    }

    required init(arrayData: MVVMListSessionModel) {
        var list = [Any]()
        self.headerText = arrayData.header?.title
        self.footerText = arrayData.header?.title
        for dict in arrayData.list ?? [] {
            if let itemModel = MVVMListListeningModel.deserialize(from: dict as? [String:Any]) {
                let cellViewModel = MVVMListListeningCellViewModel()
                cellViewModel.model = itemModel
                list.append(cellViewModel)
            }
        }
        self.list = list as Array<Any>
    }

    var headerIdentifier: String {
        return MVVMListSectionTextHeaderView.identifier
    }

    var footerIdentifier: String {
        return MVVMListSectionTextFooterView.identifier
    }

    var identifier: String {
        return MVVMListListeningTableViewCell.identifier
    }


    func headerJump() {
        // 通过路由
        print("Text Header跳转")
    }

    func footerClick() {
        print("Text Footer点击")
    }
}

class MVVMListTextAdsSectionViewModel: MVVMListSectionTextViewModelProtocol {

    var list: Array<Any>?

    var headerText: String?
    var footerText: String?

    static func canHandle(type: String) -> Bool {
        if type == "ads" {
            return true
        }
        return false
    }

    required init(dictData: MVVMListSecModel) {

        self.headerText = "Text Ads Header"
        self.footerText = "Text Ads Footer"

        let cellViewModel = MVVMListListeningCellViewModel()
        let model = dictData as MVVMListSecModel
        cellViewModel.model = model.ads
        list = [cellViewModel] as Array<Any>
    }

    required init(arrayData: MVVMListSessionModel) {
        var list = [Any]()
        self.headerText = arrayData.header?.title
        self.footerText = arrayData.header?.title
        for dict in arrayData.list ?? [] {
            if let itemModel = MVVMListListeningModel.deserialize(from: dict as? [String:Any]) {
                let cellViewModel = MVVMListListeningCellViewModel()
                cellViewModel.model = itemModel
                list.append(cellViewModel)
            }
        }
        self.list = list as Array<Any>
    }

    var headerIdentifier: String {
        return MVVMListSectionTextHeaderView.identifier
    }

    var footerIdentifier: String {
        return MVVMListSectionTextFooterView.identifier
    }

    var identifier: String {
        return MVVMListListeningTableViewCell.identifier
    }

    func headerJump() {
        print("Text Header跳转")
    }

    func footerClick() {
        print("Text Footer点击")
    }
}

class MVVMListImageCircleSectionViewModel: MVVMListSectionImageViewModelProtocol {

    var list: Array<Any>?

    var headerImageUrl: String?
    var footerImageUrl: String?

    static func canHandle(type: String) -> Bool {
        if type == "circle" {
            return true
        }
        return false
    }

    required init(dictData: MVVMListSecModel) {
        self.headerImageUrl = "Image Circle Header"
        self.footerImageUrl = "Image Circle Footer"
        let cellViewModel = MVVMListListeningCellViewModel()
        let model = dictData as MVVMListSecModel
        cellViewModel.model = model.circle
        list = [cellViewModel] as Array<Any>
    }

    required init(arrayData: MVVMListSessionModel) {
        var list = [Any]()
        self.headerImageUrl = arrayData.header?.title
        self.footerImageUrl = arrayData.header?.title
        for dict in arrayData.list ?? [] {
            if let itemModel = MVVMListListeningModel.deserialize(from: dict as? [String:Any]) {
                let cellViewModel = MVVMListListeningCellViewModel()
                cellViewModel.model = itemModel
                list.append(cellViewModel)
            }
        }
        self.list = list as Array<Any>
    }

    var headerIdentifier: String {
        return MVVMListSectionImageHeaderView.identifier
    }

    var footerIdentifier: String {
        return MVVMListSectionImageFooterView.identifier
    }

    var identifier: String {
        return MVVMListListeningTableViewCell.identifier
    }

    func downLoad() {
        print("Footer 事件：downLoad")
    }

    func headerShowToast() {
        print("Image Header 弹toast")
    }

    func footerShowAlert () {
        print("Image Footer 弹窗")
    }
}

class MVVMListTextSpeakSessionViewModel: MVVMListSectionTextViewModelProtocol {

    var list: Array<Any>?

    var headerText: String?
    var footerText: String?

    static func canHandle(type: String) -> Bool {
        if type == "speak" {
            return true
        }
        return false
    }

    required init(dictData: MVVMListSecModel) {
        self.headerText = "Text Speak Header"
        self.footerText = "Text Speak Header"
        var list = [Any]()
        for speakItemModel in dictData.speak?.list ?? Array() {
            let cellViewModel = MVVMListSpeakCellViewModel()
            cellViewModel.model = speakItemModel
            list.append(cellViewModel)
        }
        self.list = list as Array<Any>
    }

    required init(arrayData: MVVMListSessionModel) {
        var list = [Any]()
        self.headerText = arrayData.header?.title
        self.footerText = arrayData.header?.title
        for dict in arrayData.list ?? [] {
            if let itemModel = MVVMListSpeakItemModel.deserialize(from: dict as? [String:Any]) {
                let cellViewModel = MVVMListSpeakCellViewModel()
                cellViewModel.model = itemModel
                list.append(cellViewModel)
            }
        }
        self.list = list as Array<Any>
    }

    var headerIdentifier: String {
        return MVVMListSectionTextHeaderView.identifier
    }

    var footerIdentifier: String {
        return MVVMListSectionTextFooterView.identifier
    }

    var identifier: String {
        return MVVMListCourseTableViewCell.identifier
    }

    func headerJump() {
        print("Header 事件：跳转")
    }

    func footerClick() {
        print("Header 事件：点击")
    }
}
      
class MVVMListImageCourseSectionViewModel: MVVMListSectionImageViewModelProtocol {

    var list: Array<Any>?

    var headerImageUrl: String?
    var footerImageUrl: String?

    static func canHandle(type: String) -> Bool {
        if type == "course" {
            return true
        }
        return false
    }

    required init(dictData: MVVMListSecModel) {
        self.headerImageUrl = "Image Course Header"
        self.footerImageUrl = "Image Course Footer"
        var list = [Any]()
        for courseModel in dictData.course?.list ?? Array() {
            // 因为默认一个session只有一种cell，所以这里可以明确类型
            let cellViewModel = MVVMListCourseCellViewModel()
            cellViewModel.model = courseModel
            list.append(cellViewModel)
        }
        self.list = list as Array<Any>
    }

    required init(arrayData: MVVMListSessionModel) {
        var list = [Any]()
        self.headerImageUrl = arrayData.header?.title
        self.footerImageUrl = arrayData.header?.title
        for dict in arrayData.list ?? [] {
            if let itemModel = MVVMListCourseItemModel.deserialize(from: dict as? [String:Any]) {
                let cellViewModel = MVVMListCourseCellViewModel()
                cellViewModel.model = itemModel
                list.append(cellViewModel)
            }
        }
        self.list = list as Array<Any>
    }

    var headerIdentifier: String {
        return MVVMListSectionImageHeaderView.identifier
    }

    var footerIdentifier: String {
        return MVVMListSectionImageFooterView.identifier
    }

    var identifier: String {
        return MVVMListCourseTableViewCell.identifier
    }

    func downLoad() {
        print("Footer 事件：downLoad")
    }

    func headerShowToast() {
        print("Image Header 弹toast")
    }

    func footerShowAlert () {
        print("Image Footer 弹窗")
    }
}
