//
//  BPListAssembly.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/15.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class BPListAssembly: NSObject {
    static func profileRegister() {
        BPListFactory.register(viewModel: BPLabelViewModel.self)
        BPListFactory.register(viewModel: BPImageViewModel.self)
        BPListFactory.register(viewModel: BPButtonViewModel.self)
    }
}
