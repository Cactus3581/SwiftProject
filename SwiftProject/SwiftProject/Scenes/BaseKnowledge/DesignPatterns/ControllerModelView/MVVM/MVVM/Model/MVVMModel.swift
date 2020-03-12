//
//  MVVMModel.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class MVVMModel: NSObject {
    
    var name: String
    var imageUrl: String

    init(name: String, imageUrl: String) {
        self.name = name
        self.imageUrl = imageUrl
    }

}
