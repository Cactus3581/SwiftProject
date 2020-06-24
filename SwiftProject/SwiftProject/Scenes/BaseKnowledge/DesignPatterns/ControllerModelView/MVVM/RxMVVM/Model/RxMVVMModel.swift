//
//  RxMVVMModel.swift
//  SwiftProject
//
//  Created by Ryan on 2020/4/7.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class RxMVVMModel: NSObject {

    func update(model: RxMVVMModel) {
    }
}


enum  RxMVVMModelEnum {

    case w
    case s(RxMVVMModel)

    mutating func update(_ data: RxMVVMModel) {
        switch self {
        case .w:
            self = .s(data)
        case .s:
            self = .s(data)
        }
    }
}
