//
//  MVVMListSecFactory.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import Foundation

class MVVMListSecFactory {

    static var viewModels: [MVVMListSectionViewModelProtocol.Type] = []

    static func register(viewModel: MVVMListSectionViewModelProtocol.Type) {
        if !MVVMListSecFactory.viewModels.contains(where: { $0 == viewModel }) {
            MVVMListSecFactory.viewModels.append(viewModel)
        }
    }

    static func createWithContent(data: MVVMListSecModel) -> [MVVMListSectionViewModelProtocol]? {

        guard let types = data.order else { return nil } // 已排好序的列表
        var clses:[MVVMListSectionViewModelProtocol.Type] = []// 即将排好序的vm类的列表

        // 根据types数组，找到对应的类，并装入排序好的类的数组中
        for type in types {
            for tClass in MVVMListSecFactory.viewModels {
                if tClass.canHandle(type: type) {
                    clses.append(tClass)
                    break
                }
            }
        }

        // 创建vm对象
        return clses.map { (type) -> MVVMListSectionViewModelProtocol in
            type.init(data: data)
        }
    }
}
