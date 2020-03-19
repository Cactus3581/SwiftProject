//
//  MVVMListAssembly.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class MVVMListAssembly: NSObject {
    static func register() {
        MVVMListFactory.register(viewModel: MVVMListLabelTableViewCellViewModel.self)
        MVVMListFactory.register(viewModel: MVVMListImageTableViewCellViewModel.self)
        MVVMListFactory.register(viewModel: MVVMListButtonTableViewCellViewModel.self)
    }
}
