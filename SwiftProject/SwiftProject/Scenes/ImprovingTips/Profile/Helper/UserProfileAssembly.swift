//
//  UserProfileAssembly.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfileAssembly: NSObject {
    static func register() {
        UserProfileFactory.register(viewModel: UserProfileCommonSessionViewModel.self)
        UserProfileFactory.register(viewModel: UserProfilePhoneSessionViewModel.self)
        UserProfileFactory.register(viewModel: UserProfileDepartmentSessionViewModel.self)
        
    }
}
