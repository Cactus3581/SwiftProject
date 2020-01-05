//
//  ProfileModel.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/2.
//  Copyright © 2020 cactus. All rights reserved.
//

import Foundation
import HandyJSON

class ProfileModel: HandyJSON {
    var fullName: String?
    var pictureUrl: String?
    var email: String?
    var about: AboutModel?
    var list: Array<Any>?
    required init() {}
}

class AboutModel: NSObject, HandyJSON {
    required override init() {}
    var type: Int?
    var about: String?
    @objc dynamic var count: String?
}

class FriendModel: HandyJSON {
    required init() {}
    var type: Int?
    var list: Array<FriendItemModel>?
}

class FriendItemModel: HandyJSON {
    required init() {}
    var name: String?
    var pictureUrl: String?
}

class AttributeModel: HandyJSON {
    required init() {}
    var type: Int?
    var list: Array<AttributeItemModel>?
}
class AttributeItemModel: HandyJSON {
    required init() {}
    var key: String?
    var value: String?
}
