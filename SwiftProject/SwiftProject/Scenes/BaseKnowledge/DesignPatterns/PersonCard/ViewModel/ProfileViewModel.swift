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


        var muArray: [AnyHashable] = []

//        guard let data = dataFromFile("ServerData"), let profile = ProfileModel(data: data) else {
//            return
//        }

        guard let data = dataFromFile("ServerData"), let model = ProfileModel.deserialize(from: data as! Dictionary) else {
             return
         }
        

//        if let name = profile.fullName, let pictureUrl = profile.pictureUrl {
//            let nameAndPictureItem = ProfileViewModelNamePictureViewModel(name: name, pictureUrl: pictureUrl)
//            items.append(nameAndPictureItem)
//        }
//
//        if let about = profile.about {
//            let aboutItem = ProfileViewModelAboutCellViewModel(about: about)
//            items.append(aboutItem)
//        }
//
//        if let email = profile.email {
//            let dobItem = ProfileViewModelEmailCellViewModel(email: email)
//            items.append(dobItem)
//        }
//
//        let attributes = profile.profileAttributes
//        if !attributes.isEmpty {
//            let attributesItem = ProfileViewModeAttributeCellViewModel(attributes: attributes)
//            items.append(attributesItem)
//        }
//
//        let friends = profile.friends
//        if !profile.friends.isEmpty {
//            let friendsItem = ProfileViewModeFriendsCellViewModel(friends: friends)
//            items.append(friendsItem)
//        }
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
            if let item = item as? ProfileViewModeFriendsCellViewModel, let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.identifier, for: indexPath) as? FriendCell {
                let friend = item.friends[indexPath.row]
                cell.item = friend
                return cell
            }
        case .attribute:
            if let item = item as? ProfileViewModeAttributeCellViewModel, let cell = tableView.dequeueReusableCell(withIdentifier: AttributeCell.identifier, for: indexPath) as? AttributeCell {
                cell.item = item.attributes[indexPath.row]
                return cell
            }
        }
        return UITableViewCell()
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return items[section].sectionTitle
//    }
}


class ProfileViewModelNamePictureViewModel: ProfileViewModelItemProtocol {

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

class ProfileViewModelAboutCellViewModel: ProfileViewModelItemProtocol {
    var type: ProfileViewModelItemType {
        return .about
    }
    
    var rowCount: Int {
        return 1
    }
    
    var about: String
    
    init(about: String) {
        self.about = about
    }
}

class ProfileViewModelEmailCellViewModel: ProfileViewModelItemProtocol {
    var type: ProfileViewModelItemType {
        return .email
    }
    
    var rowCount: Int {
        return 1
    }
    
    var email: String
    
    init(email: String) {
        self.email = email
    }
}

class ProfileViewModeAttributeCellViewModel: ProfileViewModelItemProtocol {
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

class ProfileViewModeFriendsCellViewModel: ProfileViewModelItemProtocol {
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
