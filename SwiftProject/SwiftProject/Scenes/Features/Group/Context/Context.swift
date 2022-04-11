//
//  Context.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2022/4/12.
//  Copyright © 2022 cactus. All rights reserved.
//

import Foundation

class Context {

    weak var vc: GroupVC?

    init(vc: GroupVC) {
        self.vc = vc
    }
}
