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
        UserProfileViewModelFactory.registerTableViewSessionViewModel(viewModel: UserProfileTextSessionViewModel.self)
        UserProfileViewModelFactory.registerTableViewSessionViewModel(viewModel: UserProfilePhoneSessionViewModel.self)
        UserProfileViewModelFactory.registerTableViewSessionViewModel(viewModel: UserProfileDepartmentSessionViewModel.self)

        UserProfileViewModelFactory.registerCTAViewModel(viewModel: UserProfileCTAIChatViewModel.self)
        UserProfileViewModelFactory.registerCTAViewModel(viewModel: UserProfileCTAIVideoViewModel.self)
        UserProfileViewModelFactory.registerCTAViewModel(viewModel: UserProfileCTAISecretChatViewModel.self)
        UserProfileViewModelFactory.registerCTAViewModel(viewModel: UserProfileCTAPhoneViewModel.self)
        UserProfileViewModelFactory.registerCTAViewModel(viewModel: UserProfileCTALinkViewModel.self)
        UserProfileViewModelFactory.registerCTAViewModel(viewModel: UserProfileCTAIVoiceViewModel.self)



        UserProfileViewModelFactory.registerThreePointsViewModel(viewModel: UserProfileReportItemViewModel.self)
        UserProfileViewModelFactory.registerThreePointsViewModel(viewModel: UserProfileSuggessItemViewModel.self)

        UserProfileCTAViewFactory.registerCtaView(view: UserProfileCTAItemView.self)

    }
}
