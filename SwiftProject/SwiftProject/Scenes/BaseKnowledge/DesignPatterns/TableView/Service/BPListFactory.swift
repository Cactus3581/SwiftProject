//
//  BPListFactory.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/1/15.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import Foundation
import HandyJSON

class BPListFactory {

    static var viewModels: [BPCellViewModelProtocol.Type] = []

    static func register(viewModel: BPCellViewModelProtocol.Type) {
        if !BPListFactory.viewModels.contains(where: { $0 == viewModel }) {
            BPListFactory.viewModels.append(viewModel)
        }
    }

    static func createWithContent(data: BPModel) -> [BPCellViewModelProtocol]? { //返回了一个vm数组

        var classes:[BPCellViewModelProtocol.Type] = []

        guard let order = data.order else {
            return nil
        }

        for type in order {
            for tClass in BPListFactory.viewModels {
                if tClass.canHandle(type: type) {
                    classes.append(tClass)
                }
            }
        }

        return classes.map { (type) -> BPCellViewModelProtocol in
            type.init(data: data)
        }
    }
}
