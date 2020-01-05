//
//  ProfileAssembly.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/1/5.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class ProfileAssembly {

    private func profileRegister() {
        ProfileFactory.register(vm: ProfileAboutCellViewModel.self)
        ProfileFactory.register(vm: ProfileNamePictureViewModel.self)
    }
    
}
