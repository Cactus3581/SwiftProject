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

        UserProfileViewModelFactory.registerThreePointsViewModel(viewModel: UserProfileReportItemViewModel.self)
        UserProfileViewModelFactory.registerThreePointsViewModel(viewModel: UserProfileSuggessItemViewModel.self)

        UserProfileViewModelFactory.registerCTAViewModel(viewModel: UserProfileCTAChatViewModel.self)
        UserProfileViewModelFactory.registerCTAViewModel(viewModel: UserProfileCTAPhoneViewModel.self)
        UserProfileViewModelFactory.registerCTAViewModel(viewModel: UserProfileCTAIVideoViewModel.self)
        UserProfileViewModelFactory.registerCTAViewModel(viewModel: UserProfileCTAISecretChatViewModel.self)
        UserProfileViewModelFactory.registerCTAViewModel(viewModel: UserProfileCTALinkViewModel.self)

        UserProfileViewModelFactory.registerCtaView(view: UserProfileCTAItemView.self)

        UserProfileViewModelFactory.registerTableViewSessionViewModel(viewModel: UserProfileTextSessionViewModel.self)
        UserProfileViewModelFactory.registerTableViewSessionViewModel(viewModel: UserProfileLinkSessionViewModel.self)
        UserProfileViewModelFactory.registerTableViewSessionViewModel(viewModel: UserProfilePhoneSessionViewModel.self)
        UserProfileViewModelFactory.registerTableViewSessionViewModel(viewModel: UserProfileDepartmentSessionViewModel.self)
        UserProfileViewModelFactory.registerTableViewSessionViewModel(viewModel: UserProfileUserStatusSessionViewModel.self)
        UserProfileViewModelFactory.registerTableViewSessionViewModel(viewModel: UserProfileAliasSessionViewModel.self)

    }
}
