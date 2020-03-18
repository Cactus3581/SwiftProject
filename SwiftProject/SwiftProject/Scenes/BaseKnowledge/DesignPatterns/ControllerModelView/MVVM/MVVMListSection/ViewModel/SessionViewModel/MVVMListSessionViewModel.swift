//
//  MVVMListSectionViewModel.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/3/12.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

//协议的作用就是解决通用性问题，替代继承用的
//MARK:服务于sessionViewModel，为sessionView提供数据，接收事件
protocol MVVMListSectionViewModelProtocol {
    //  以下的定义没有问题
    static func canHandle(type: String) -> Bool
    init(data: MVVMListSecModel)

    var headerIdentifier: String { get }
    var footerIdentifier: String { get }
    var identifier: String { get }

    var list: Array<Any>? { set get }
}

extension MVVMListSectionViewModelProtocol {
    static func canHandle(type: String) -> Bool {return false}
    init(data: MVVMListSecModel) {self.init(data: data)}

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
    // 针对多对1的方案
    /*  以下的定义，因为涉及一个view对应多个sessionViewModel/model的问题，所以：
     1. 需要将数据单独抽出来
     2. 事件也单独列出来

     除非不复用view，那不可能不复用
     复用的情况：
     1. view和model一对一:是非常完美的情况:
     2. 多个view使用一个vm：首先UI样式不一样，但是数据或者说model/vm是一样的，这种情况很少，但是跟第一种情况差不多，也很好处理；
     3. 多个vm使用一个view:现在的情况就是，多个sessionViewModel使用了同一个sectionHeaderView
     */
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

//MARK:四种组合
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

    required init(data: MVVMListSecModel) {

        self.headerText = "Text Listening Header"
        self.footerText = "Text Listening Footer"

        let cellViewModel = MVVMListListeningCellViewModel()
        let model = data as? MVVMListSecModel
        cellViewModel.model = model?.listening
        list = [cellViewModel] as? Array<Any>
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
        // 具体事件具体分析
        print("Text Footer点击")
    }
}

class MVVMListTextListeningSameSectionViewModel: MVVMListSectionTextViewModelProtocol {

    var list: Array<Any>?

    var headerText: String?
    var footerText: String?

    static func canHandle(type: String) -> Bool {
        if type == "listeningSame" {
            return true
        }
        return false
    }

    required init(data: MVVMListSecModel) {

        self.headerText = "Text ListeningSame Header"
        self.footerText = "Text ListeningSame Footer"

        let cellViewModel = MVVMListListeningCellViewModel()
        let model = data as? MVVMListSecModel
        cellViewModel.model = model?.listeningSame
        list = [cellViewModel] as? Array<Any>
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
        // 具体事件具体分析
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

    required init(data: MVVMListSecModel) {
        self.headerImageUrl = "Image Circle Header"
        self.footerImageUrl = "Image Circle Footer"
        let cellViewModel = MVVMListListeningCellViewModel()
        let model = data as? MVVMListSecModel
        cellViewModel.model = model?.circle
        list = [cellViewModel] as? Array<Any>
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

    required init(data: MVVMListSecModel) {
        self.headerText = "Text Speak Header"
        self.footerText = "Text Speak Header"
        var list = [Any]()
        for str in data.speak?.list ?? Array() {
            let model = MVVMListSpeakCellViewModel.init(itemData: str)
            list.append(model)
        }
        self.list = list as? Array<Any>
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
        // 通过路由
        print("Header 事件：跳转")
    }

    func footerClick() {
        // 具体事件具体分析
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

    required init(data: MVVMListSecModel) {
        self.headerImageUrl = "Image Course Header"
        self.footerImageUrl = "Image Course Footer"
        var list = [Any]()
        for courseModel in data.course?.list ?? Array() {
            let courseCellViewModel = MVVMListCourseCellViewModel.init(itemData: courseModel)
            list.append(courseCellViewModel)
        }
        self.list = list as? Array<Any>
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
