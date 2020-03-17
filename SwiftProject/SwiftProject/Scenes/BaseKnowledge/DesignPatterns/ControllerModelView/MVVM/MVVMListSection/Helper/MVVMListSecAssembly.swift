//
//  MVVMListSecAssembly.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class MVVMListSecAssembly: NSObject {
    static func register() {
        MVVMListSecFactory.register(viewModel: MVVMListButtonSectionViewModel.self)
        MVVMListSecFactory.register(viewModel: MVVMListGroupSessionViewModel.self)
    }
}
