//
//  Context.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2022/4/12.
//  Copyright © 2022 cactus. All rights reserved.
//

import Foundation

/** Context的设计：提供全局视角的数据，并可以被传递到任何地方
1. 提供全局视角的关键数据：vc和vm
2. 提供方便获取的方式
*/

class Context {

    weak var vc: GroupVC?

    init(vc: GroupVC) {
        self.vc = vc
    }
}
