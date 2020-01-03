//
//  ProfileViewModel.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/1/2.
//  Copyright © 2020 cactus. All rights reserved.
//

import Foundation
import UIKit
import HandyJSON

enum ProfileViewModelItemType {
    case nameAndPicture
    case about
    case email
    case friend
    case attribute
}

protocol ProfileViewModelItemProtocol {
    var type: ProfileViewModelItemType { get } // case
    var rowCount: Int { get } // tableViewDataSource
}

class ProfileViewModel: NSObject {

    var items = [ProfileViewModelItemProtocol]()
    
    override init() {
        super.init()

        guard let data = dataFromFile("ServerData"), let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let body = json["data"] as? [String: Any] else  {
            return
        }

        guard let model = ProfileModel.deserialize(from: body) else {
              return
         }

        let nameAndPictureItem = ProfileNamePictureViewModel(model: model)
        items.append(nameAndPictureItem)

        let aboutItem = ProfileAboutCellViewModel(model: model)
        items.append(aboutItem)

        let dobItem = ProfileEmailCellViewModel(model: model)
        items.append(dobItem)

        let attributesItem = ProfileAttributeCellViewModel(attributes: model.profileAttributes)
        items.append(attributesItem)

        let friendsItem = ProfileFriendsCellViewModel(friends: model.friends)
        items.append(friendsItem)
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
        let item = items[indexPath.section]
        switch item.type {
        case .nameAndPicture:
            if let cell = tableView.dequeueReusableCell(withIdentifier: NamePictureCell.identifier, for: indexPath) as? NamePictureCell {
                cell.item = item
                return cell
            }
        case .about:
            if let cell = tableView.dequeueReusableCell(withIdentifier: AboutCell.identifier, for: indexPath) as? AboutCell {
                cell.item = item
                return cell
            }
        case .email:
            if let cell = tableView.dequeueReusableCell(withIdentifier: EmailCell.identifier, for: indexPath) as? EmailCell {
                cell.item = item
                return cell
            }
        case .friend:
            if let item = item as? ProfileFriendsCellViewModel, let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.identifier, for: indexPath) as? FriendCell {
                let friend = item.friends[indexPath.row]
                cell.item = friend
                return cell
            }
        case .attribute:
            if let item = item as? ProfileAttributeCellViewModel, let cell = tableView.dequeueReusableCell(withIdentifier: AttributeCell.identifier, for: indexPath) as? AttributeCell {
                cell.item = item.attributes[indexPath.row]
                return cell
            }
        }
        return UITableViewCell()
    }
}


class ProfileNamePictureViewModel: ProfileViewModelItemProtocol {

    var type: ProfileViewModelItemType {
        return .nameAndPicture
    }
    
    var rowCount: Int {
        return 1
    }

    let model: ProfileModel
    var name: String
    var pictureUrl: String
    init(model: ProfileModel) {
        self.model = model
        self.name = model.fullName ?? ""
        self.pictureUrl = model.pictureUrl ?? ""
    }
}

class ProfileAboutCellViewModel: ProfileViewModelItemProtocol {
    var type: ProfileViewModelItemType {
        return .about
    }
    
    var rowCount: Int {
        return 1
    }

    let model: ProfileModel
    var about: String
    init(model: ProfileModel) {
        self.model = model
        self.about = model.about ?? ""
    }
}

class ProfileEmailCellViewModel: ProfileViewModelItemProtocol {
    var type: ProfileViewModelItemType {
        return .email
    }
    
    var rowCount: Int {
        return 1
    }

    let model: ProfileModel
    var email: String
    init(model: ProfileModel) {
        self.model = model
        self.email = model.email ?? ""
    }
}

class ProfileAttributeCellViewModel: ProfileViewModelItemProtocol {
    var type: ProfileViewModelItemType {
        return .attribute
    }
    
    var rowCount: Int {
        return attributes.count
    }
    
    var attributes: [AttributeModel]
    init(attributes: [AttributeModel]) {
        self.attributes = attributes
    }
}

class ProfileFriendsCellViewModel: ProfileViewModelItemProtocol {
    var type: ProfileViewModelItemType {
        return .friend
    }
    
    var rowCount: Int {
        return friends.count
    }
    
    var friends: [FriendModel]
    
    init(friends: [FriendModel]) {
        self.friends = friends
    }
}
