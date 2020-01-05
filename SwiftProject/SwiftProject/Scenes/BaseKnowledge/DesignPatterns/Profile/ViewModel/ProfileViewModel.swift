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

/*
 * cell: cellVM 工厂方法/注册 -> viewModel创建cell，合理性？
 * cellVM 和 Cell 有问题，是否应该加SectionViewModel，还可能涉及CellVM事件问题
 * 加入事件，并引入RxSwift/路由
 * 加入Swinject

 可以优化的：
 枚举带model
 工厂方法问题
 注册到底是怎么回事
 多个view如何处理


 1.看文章，特别是sessionViewModel的事件问题
 2.RxSwift使用
 3.改名字
 */

enum ProfileViewModelItemType: Int{
    case nameAndPicture = 0
    case email
    case about
    case friend
    case attribute
}

protocol ProfileCellViewModelProtocol {
    var cellHeight: Double { get } //cell高度
    var rowCount: Int { get } // tableViewDataSource
    func setupCell(tableView: UITableView,indexPath:IndexPath,item:ProfileCellViewModelProtocol) -> UITableViewCell//获取cell
    func tableView(tableView: UITableView, didSelectRowAt indexPath: IndexPath)//cell 点击
    func jumpDetail()
    func sutractAction()
    func addAction()
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
    
    func jumpDetail() {

    }

    func sutractAction() {

    }

    func addAction() {
        
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

        let nameAndPictureItem = ProfileNamePictureViewModel(model: model)
        items.append(nameAndPictureItem)

        let dobItem = ProfileEmailCellViewModel(model: model)
        items.append(dobItem)

        let serverList: Array! = model.list
        for dic in serverList {
            let tResult = dic as![String:Any]
            let type1 = tResult["type"]
            let type:Int = type1 as! Int
            switch type {
            case 2:
                if let model = AboutModel.deserialize(from: tResult) {
                    let aboutItem = ProfileAboutCellViewModel(model: model)
                    items.append(aboutItem)
                }
            case 3:
                if let model = AttributeModel.deserialize(from: tResult) {
                    let friendsItem = ProfileAttributeCellViewModel(attributes: model.list ?? [] as! [AttributeItemModel])
                    items.append(friendsItem)
                }
            case 4:
                if let model = FriendModel.deserialize(from: tResult) {
                    let friendsItem = ProfileFriendsCellViewModel(friends: model.list ?? [])
                    items.append(friendsItem)
                }
            default:
                print("1")
            }
        }
    }

    private func dataFromFile(_ filename: String) -> Data? {
        @objc class TestClass: NSObject { }
        let bundle = Bundle(for: TestClass.self)
        if let path = bundle.path(forResource: filename, ofType: "json") {
            return (try? Data(contentsOf: URL(fileURLWithPath: path)))
        }
        return nil
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

class ProfileAboutCellViewModel:NSObject, ProfileCellViewModelProtocol {

    @objc dynamic let model: AboutModel
    var about: String
    @objc dynamic var count: String {
        didSet {
            print("\(count)")
        }
    }

    init(model: AboutModel) {
        self.model = model
        self.about = model.about ?? ""
        self.count = model.count ?? ""
    }

    func setupCell(tableView: UITableView,indexPath:IndexPath,item:ProfileCellViewModelProtocol) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: AboutCell.identifier, for: indexPath) as? AboutCell {
            cell.item = item
            return cell
        }else {
            return UITableViewCell()
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

class ProfileEmailCellViewModel: ProfileCellViewModelProtocol {

    let model: ProfileModel
    var email: String

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

class ProfileAttributeCellViewModel: ProfileCellViewModelProtocol {

    var attributes: [AttributeItemModel]

    var rowCount: Int {
        return attributes.count
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
