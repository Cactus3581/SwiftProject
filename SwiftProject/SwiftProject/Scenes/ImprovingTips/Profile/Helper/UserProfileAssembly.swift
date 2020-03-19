//
//  UserProfileAssembly.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfileAssembly: NSObject {
    static func register() {
        UserProfileFactory.register(viewModel: UserProfileTextListeningSectionViewModel.self)
        UserProfileFactory.register(viewModel: UserProfileTextAdsSectionViewModel.self)
        UserProfileFactory.register(viewModel: UserProfileTextSpeakSessionViewModel.self)
    }
}
