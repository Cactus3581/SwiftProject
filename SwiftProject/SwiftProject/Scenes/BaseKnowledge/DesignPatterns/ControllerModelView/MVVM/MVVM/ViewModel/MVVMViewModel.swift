//
//  MVVMViewModel.swift
//  SwiftProject
//
//  Created by ryan on 2019/12/29.
//  Copyright © 2019 cactus. All rights reserved.
//

import UIKit

class MVVMViewModel: NSObject {

    var model: MVVMModel
    var name: String
    var imageUrl: String

    override init() {
        self.model = MVVMModel(name: "ryan", imageUrl: "navi_back")
        name = self.model.name
        imageUrl = self.model.imageUrl
    }

    func updateData(result: ((MVVMViewModel) -> ())) {
        model.name = "cactus"
        self.name = model.name
        result(self)
    }
}
