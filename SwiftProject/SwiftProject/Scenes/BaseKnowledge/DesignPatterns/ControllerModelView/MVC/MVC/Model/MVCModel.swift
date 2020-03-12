//
//  MVCModel.swift
//  SwiftProject
//
//  Created by ryan on 2019/12/29.
//  Copyright © 2019 cactus. All rights reserved.
//

import UIKit

class MVCModel: NSObject {

    var name: String
    var imageUrl: String

    init(name: String, imageUrl: String) {
        self.name = name
        self.imageUrl = imageUrl
    }
}
