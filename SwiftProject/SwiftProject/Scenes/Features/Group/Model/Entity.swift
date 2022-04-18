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
    let item: EntityItem
}

struct ChildEntity {
    let id: Int
    let item: EntityItem
}

struct EntityItem {
    let id: Int
    let parentId: Int
    let position: Int
}
