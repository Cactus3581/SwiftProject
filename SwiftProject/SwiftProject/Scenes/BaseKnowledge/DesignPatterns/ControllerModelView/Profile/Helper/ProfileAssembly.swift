//
//  ProfileAssembly.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/5.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class ProfileAssembly {

    static func profileRegister() {
        ProfileFactory.register(viewModel: ProfileAboutCellViewModel.self)
        ProfileFactory.register(viewModel: ProfileAttributeCellViewModel.self)
        ProfileFactory.register(viewModel: ProfileFriendsCellViewModel.self)
//        ProfileFactory.register(viewModel: ProfileEmailCellViewModel.self)
//        ProfileFactory.register(viewModel: ProfileNamePictureViewModel.self)
    }
}
