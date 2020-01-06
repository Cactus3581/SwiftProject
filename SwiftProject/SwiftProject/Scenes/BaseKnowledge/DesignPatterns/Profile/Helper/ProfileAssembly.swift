//
//  ProfileAssembly.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/1/5.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class ProfileAssembly {

    static func profileRegister() {
        ProfileFactory.register(vm: ProfileAboutCellViewModel.self)
        ProfileFactory.register(vm: ProfileAttributeCellViewModel.self)
        ProfileFactory.register(vm: ProfileFriendsCellViewModel.self)
        ProfileFactory.register(vm: ProfileEmailCellViewModel.self)
        ProfileFactory.register(vm: ProfileNamePictureViewModel.self)

    }
}
