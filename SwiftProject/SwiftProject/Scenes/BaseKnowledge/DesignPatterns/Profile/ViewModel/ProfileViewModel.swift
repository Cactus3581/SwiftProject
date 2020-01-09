//
//  ProfileViewModel.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/2.
//  Copyright © 2020 cactus. All rights reserved.
//

import Foundation
import UIKit
import HandyJSON
import RxSwift
import RxCocoa


enum ProfileViewModelItemType: Int{
    case nameAndPicture = 0
    case email
    case about
    case attribute
    case friend
}

protocol ProfileCellViewModelProtocol {

    // 生成cellVM的方法
    static func canHandle(type: Int) -> Bool
    // 定义构造函数
    init(data: ProfileModel)
    init(dict: Any)

    // cellVM的通用方法
    var cellHeight: Double { get } //cell高度
    var rowCount: Int { get } // tableViewDataSource
    func setupCell(tableView: UITableView,indexPath:IndexPath,item:ProfileCellViewModelProtocol) -> UITableViewCell//获取cell
    func tableView(tableView: UITableView, didSelectRowAt indexPath: IndexPath)//cell 点击

    // 不同的cellVM使用不同的方法
    func jumpDetail()
    func sutractAction()
    func addAction()

    /// 头像预览
    func presentPreviewAvatarController(_ controller: PersonalCardController, avatarKey: String, hideUpdateButton: Bool)
    /// 跳转个人名片页
    func pushPersonCard(_ controller: PersonalCardController, chatterId: String)
    /// 打开链接
    func openLink(_ controller: PersonalCardController, url: URL, userInfo: [String: Any])
    /// 拨打电话
    func openTel(_ controller: PersonalCardController, number: String)
    /// 进入聊天界面
    func pushChatController(_ controller: PersonalCardController, feedId: String, chatterId: String, isCrypto: Bool)
    /// 进入我的二维码界面
    func pushShareCard(_ controller: PersonalCardController)
    /// 进入添加好友界面
    func pushAddFriendsVC(_ controller: PersonalCardController, chatId: String, contactToken: String, applyBlock: (() -> Void)?)
    /// 进入设置别名界面，目前暂不支持设置同一个群对方的别名
    func pushSetAliasVC(_ controller: PersonalCardController,
                        currentAlias: String,
                        setBlock: ((_ alias: String) -> Void)?)
    /// 跳转日程
    func pushCalendar(_ controller: PersonalCardController, chatterId: String)
    /// 视频聊天
    func didSelectVideo(_ controller: PersonalCardController, chatterId: String, channelType: ChannelType)
    func presentSetQueryNumberController(_ controller: PersonalCardController, chatterId: String)
}

extension ProfileCellViewModelProtocol {

    var cellHeight: Double {
       return 100
    }

    var rowCount: Int {
       return 1
    }

    func setupCell(tableView: UITableView,indexPath:IndexPath,item:ProfileCellViewModelProtocol) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func jumpDetail() {}

    func sutractAction() {}

    func addAction() {}

    static func canHandle(type: Int) -> Bool {
        return false
    }

    init(data: ProfileModel) {
        self.init(data: data)
    }

    /// 头像预览
    func presentPreviewAvatarController(_ controller: PersonalCardController, avatarKey: String, hideUpdateButton: Bool) {

    }

    /// 跳转个人名片页
    func pushPersonCard(_ controller: PersonalCardController, chatterId: String) {

    }

    /// 打开链接
    func openLink(_ controller: PersonalCardController, url: URL, userInfo: [String: Any]) {

    }
    /// 拨打电话
    func openTel(_ controller: PersonalCardController, number: String) {

    }
    /// 进入聊天界面
    func pushChatController(_ controller: PersonalCardController, feedId: String, chatterId: String, isCrypto: Bool) {

    }
    /// 进入我的二维码界面
    func pushShareCard(_ controller: PersonalCardController) {

    }
    /// 进入添加好友界面
    func pushAddFriendsVC(_ controller: PersonalCardController, chatId: String, contactToken: String, applyBlock: (() -> Void)?) {

    }
    /// 进入设置别名界面，目前暂不支持设置同一个群对方的别名
    func pushSetAliasVC(_ controller: PersonalCardController,
                        currentAlias: String,
                        setBlock: ((_ alias: String) -> Void)?) {

    }
    /// 跳转日程
    func pushCalendar(_ controller: PersonalCardController, chatterId: String) {

    }
    /// 视频聊天
    func didSelectVideo(_ controller: PersonalCardController, chatterId: String, channelType: ChannelType) {

    }
    
    func presentSetQueryNumberController(_ controller: PersonalCardController, chatterId: String) {

    }
}

class ProfileViewModel: NSObject {

    var items = [ProfileCellViewModelProtocol]()

    override init() {
        super.init()
        parseData()
    }

    private func parseData()  {

        guard let data = dataFromFile("ServerData"), let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let body = json["data"] as? [String: Any] else  {
            return
        }

        guard let model = ProfileModel.deserialize(from: body) else {
            return
        }

        // 最本质的原因，需要看当时制定方案的思路，或者看看json结构，了解主要字段的用途。

        /*
         方案1:要求
         1. json只提供数据
         2. 需要额外的字段来做顺序排序
         3. 生成cellViewModel的方法在各自cellViewModel类里，还要再加上额外的注册类方法
         4. 当遇到同一种样式类型，不同事件的时候，也就是同样的cell、model、cellViewModel，需要加入额外的eventType来区分
         */
        items = handleDataByOrder(model)

        /*
         方案2:要求
         1. 只根据json结构顺序平铺
         2. 处理数据聚集在以下方法，无法抛出
         3. 当遇到同一种样式类型，不同事件的时候，也就是同样的cell、model、cellViewModel，需要加入额外的eventType来区分
         */
//        items = handleDataByJson(model)

                /*
                 方案2:要求
                 1. 只根据json结构顺序平铺
                 2. 处理数据聚集在以下方法，无法抛出
                 3. 当遇到同一种样式类型，不同事件的时候，也就是同样的cell、model、cellViewModel，需要加入额外的eventType来区分
                 */
        //        items = handleDataByJson(model)
    }

    private func handleDataByOrder(_ model: ProfileModel) -> [ProfileCellViewModelProtocol] {
        return ProfileFactory.createWithContent1(data: model) ?? []
    }

    private func handleDataByJson(_ model: ProfileModel) -> [ProfileCellViewModelProtocol] {

        var array = [ProfileCellViewModelProtocol]()

        let nameAndPictureItem = ProfileNamePictureViewModel(model: model)
        array.append(nameAndPictureItem)

        let dobItem = ProfileEmailCellViewModel(model: model)
        array.append(dobItem)

        let serverList: Array! = model.list
        for dic in serverList {
            let tResult = dic as![String:Any]
            let type = tResult["type"] as! Int
            switch type {
            case ProfileViewModelItemType.about.rawValue:
                if let model = AboutModel.deserialize(from: tResult) {
                    let aboutItem = ProfileAboutCellViewModel(model: model)
                    array.append(aboutItem)
                }
            case ProfileViewModelItemType.attribute.rawValue:
                if let model = AttributeModel.deserialize(from: tResult) {
                    let friendsItem = ProfileAttributeCellViewModel(attributes: model.list ?? [] as! [AttributeItemModel])
                    array.append(friendsItem)
                }
            case ProfileViewModelItemType.friend.rawValue:
                if let model = FriendModel.deserialize(from: tResult) {
                    let friendsItem = ProfileFriendsCellViewModel(friends: model.list ?? [])
                    array.append(friendsItem)
                }
            default:
                print("1")
            }
        }
        return array
    }

    private func dataFromFile(_ filename: String) -> Data? {
        @objc class TestClass: NSObject { }
        let bundle = Bundle(for: TestClass.self)
        if let path = bundle.path(forResource: filename, ofType: "json") {
            return (try? Data(contentsOf: URL(fileURLWithPath: path)))
        }
        return nil
    }

    // 获取指定的cellVM
    func getCellViewModel(indexPath:NSIndexPath) -> ProfileCellViewModelProtocol {
        return items[indexPath.section]
    }
}

extension ProfileViewModel: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item:ProfileCellViewModelProtocol = items[indexPath.section]
        return item.setupCell(tableView: tableView, indexPath: indexPath, item:item)
    }
}

class ProfileNamePictureViewModel: ProfileCellViewModelProtocol {

    let model: ProfileModel
    var name: String
    var pictureUrl: String

    static func canHandle(type: Int) -> Bool {
        if type == ProfileViewModelItemType.nameAndPicture.rawValue {
            return true
        }
        return false
    }

    required init(data: ProfileModel) {
        self.model = data
        self.name = model.fullName ?? ""
        self.pictureUrl = model.pictureUrl ?? ""
    }

    required init(dict: Any) {
        self.model = dict as? ProfileModel ?? ProfileModel()
        self.name = model.fullName ?? ""
        self.pictureUrl = model.pictureUrl ?? ""
    }



    init(model: ProfileModel) {
        self.model = model
        self.name = model.fullName ?? ""
        self.pictureUrl = model.pictureUrl ?? ""
    }

    func setupCell(tableView: UITableView,indexPath:IndexPath,item:ProfileCellViewModelProtocol) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: NamePictureCell.identifier, for: indexPath) as? NamePictureCell {
            cell.item = item
            return cell
        }else {
            return UITableViewCell()
        }
    }
}

class ProfileEmailCellViewModel: ProfileCellViewModelProtocol {

    let model: ProfileModel
    var email: String

    static func canHandle(type: Int) -> Bool {
        if type == ProfileViewModelItemType.email.rawValue {
            return true
        }
        return false
    }

    required init(data: ProfileModel) {
        self.model = data
        self.email = data.email ?? ""
    }

    required init(dict: Any) {
        let model: ProfileModel = dict as? ProfileModel ?? ProfileModel()
        self.model = model
        self.email = model.email ?? ""
    }

    init(model: ProfileModel) {
        self.model = model
        self.email = model.email ?? ""
    }

    func setupCell(tableView: UITableView,indexPath:IndexPath,item:ProfileCellViewModelProtocol) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: EmailCell.identifier, for: indexPath) as? EmailCell {
            cell.item = item
            return cell
        }else {
            return UITableViewCell()
        }
    }
}

class ProfileAboutCellViewModel:NSObject, ProfileCellViewModelProtocol {

    @objc dynamic let model: AboutModel
    var about: String
    var eventType: Int

    @objc dynamic var count: String {
        didSet {
            print("\(count)")
        }
    }

    static func canHandle(type: Int) -> Bool {
        if type == ProfileViewModelItemType.about.rawValue {
            return true
        }
        return false
    }

    required init(data: ProfileModel) {
        var result:[String:Any]?
        let serverList: Array! = data.list
        for dic in serverList {
            let tResult = dic as![String:Any]
            let type = tResult["type"] as! Int
            if type == ProfileViewModelItemType.about.rawValue {
                result = tResult;
                break
            }
        }

        let tResult1 = result ?? ["":""]
        let model1 = AboutModel.deserialize(from: tResult1)
        self.model = model1 ?? AboutModel.init()
        self.about = model.about ?? ""
        self.count = model.count ?? ""
        self.eventType = model.eventType ?? -1
    }

    required init(dict: Any) {
        let tResult1: Dictionary = dict as? [String:Any] ?? ["":""]
        let model1 = AboutModel.deserialize(from: tResult1)
        self.model = model1 ?? AboutModel.init()
        self.about = model.about ?? ""
        self.count = model.count ?? ""
        self.eventType = model.eventType ?? -1
    }

    init(model: AboutModel) {
        self.model = model
        self.about = model.about ?? ""
        self.count = model.count ?? ""
        self.eventType = model.eventType ?? -1
    }

    func setupCell(tableView: UITableView,indexPath:IndexPath,item:ProfileCellViewModelProtocol) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: AboutCell.identifier, for: indexPath) as? AboutCell {
            cell.item = item
            return cell
        }else {
            return UITableViewCell()
        }
    }

    func callAction() {

    }

    func messageAction() {

    }

    func unSureAction() {

        switch eventType {
        case 1:
            // 打电话
            callAction()
        case 2:
            //发短信
            messageAction()
        default:
            print("")
        }
    }

    func addAction() {
        if let value = model.count, let value1 = Int(value) {
            model.count = String(value1+1)
            count = String(value1+1)
        }
    }

    func sutractAction() {
        if let value = model.count, let value1 = Int(value) {
            model.count = String(value1-1)
            count = String(value1-1)
            about = String(value1-1)
        }
    }
}

class ProfileAttributeCellViewModel: ProfileCellViewModelProtocol {

    var attributes: [AttributeItemModel]

    var rowCount: Int {
        return attributes.count
    }

    static func canHandle(type: Int) -> Bool {
        if type == ProfileViewModelItemType.attribute.rawValue {
            return true
        }
        return false
    }

    required init(data: ProfileModel) {
        var result:[String:Any]?
        let serverList: Array! = data.list
        for dic in serverList {
            let tResult = dic as![String:Any]
            let type = tResult["type"] as! Int
            if type == ProfileViewModelItemType.attribute.rawValue {
                result = tResult;
                break
            }
        }

        if let model = AttributeModel.deserialize(from: result!) {
            self.attributes = model.list ?? []
        } else {
            self.attributes = []
        }
    }

    required init(dict: Any) {
        let result: Dictionary = dict as? [String:Any] ?? ["":""]
        if let model = AttributeModel.deserialize(from: result) {
            self.attributes = model.list ?? []
        } else {
            self.attributes = []
        }
    }

    init(attributes: [AttributeItemModel]) {
        self.attributes = attributes
    }

    func setupCell(tableView: UITableView,indexPath:IndexPath,item:ProfileCellViewModelProtocol) -> UITableViewCell {
        if let item = item as? ProfileAttributeCellViewModel, let cell = tableView.dequeueReusableCell(withIdentifier: AttributeCell.identifier, for: indexPath) as? AttributeCell {
            cell.item = item.attributes[indexPath.row]
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

class ProfileFriendsCellViewModel: ProfileCellViewModelProtocol {

    var friends: [FriendItemModel]

    var rowCount: Int {
        return friends.count
    }

    static func canHandle(type: Int) -> Bool {
        if type == ProfileViewModelItemType.friend.rawValue {
            return true
        }
        return false
    }

    required init(data: ProfileModel) {
        var result:[String:Any]?
        let serverList: Array! = data.list
        for dic in serverList {
            let tResult = dic as![String:Any]
            let type = tResult["type"] as! Int
            if type == ProfileViewModelItemType.friend.rawValue {
                result = tResult;
                break
            }
        }

        if let model = FriendModel.deserialize(from: result) {
            self.friends = model.list ?? []
        } else {
            self.friends = []
        }
    }

    required init(dict: Any) {
        let result: Dictionary = dict as? [String:Any] ?? ["":""]
        if let model = FriendModel.deserialize(from: result) {
            self.friends = model.list ?? []
        } else {
            self.friends = []
        }
    }

    init(friends: [FriendItemModel]) {
        self.friends = friends
    }

    func setupCell(tableView: UITableView,indexPath:IndexPath,item:ProfileCellViewModelProtocol) -> UITableViewCell {
        if let item = item as? ProfileFriendsCellViewModel, let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.identifier, for: indexPath) as? FriendCell {
            let friend = item.friends[indexPath.row]
            cell.item = friend
            return cell
        }else {
            return UITableViewCell()
        }
    }

    func jumpDetail() {

    }
}
