//
//  MVCModel.swift
//  SwiftProject
//
//  Created by ryan on 2019/12/29.
//  Copyright © 2019 cactus. All rights reserved.
//

import UIKit

class MVCModel: NSObject {

    var firstName: String
    var lastName: String
    var birthday: Date

    init(firstName: String, lastName: String, birthday: Date) {
        self.firstName = firstName
        self.lastName = lastName
        self.birthday = birthday
    }
}
