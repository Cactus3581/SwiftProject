//
//  ProfileModel.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/1/2.
//  Copyright © 2020 cactus. All rights reserved.
//

import Foundation
import HandyJSON

class ProfileModel: HandyJSON {
    var fullName: String?
    var pictureUrl: String?
    var email: String?
    var about: String?
    var friends = [FriendModel]()
    var profileAttributes = [AttributeModel]()
    required init() {}
}

class FriendModel: HandyJSON {
    required init() {}
    var name: String?
    var pictureUrl: String?
}

class AttributeModel: HandyJSON {
    required init() {}
    var key: String?
    var value: String?
}
