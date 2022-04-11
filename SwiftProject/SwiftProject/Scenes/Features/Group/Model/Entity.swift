//
//  Entity.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2022/4/2.
//  Copyright © 2022 cactus. All rights reserved.
//

import Foundation

struct ParentEntity {
    let id: Int
    let position: Int
}

struct ChildEntity {
    let parentItems: [Int:ParentItem]
    let id: Int
}

struct ParentItem {
    let parentId: Int
    let position: Int
}
