//
//  MVVMListSecFactory.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
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

    static func createSessionViewModelByDict(data: MVVMListSecModel) -> [MVVMListSectionViewModelProtocol]? {
        var list:[MVVMListSectionViewModelProtocol] = []
        for type in data.order ?? [] {
            let tclass = getClass(type: type)
            if let tclass1 = tclass {
                list.append(tclass1.init(dictData: data))
            }
        }
        return list
    }

    static func createSessionViewModelByArray(data: MVVMListSecModel) -> [MVVMListSectionViewModelProtocol]? {
        var list:[MVVMListSectionViewModelProtocol] = []
        for sessionModel in data.list ?? [] {
            let tclass = getClass(type: sessionModel.type ?? "")
            if let tclass1 = tclass {
                list.append(tclass1.init(arrayData: sessionModel))
            }
        }
        return list
    }

    static func getClass(type: String) -> MVVMListSectionViewModelProtocol.Type? {
        for tClass in MVVMListSecFactory.viewModels {
            if tClass.canHandle(type: type) {
               return tClass
            }
        }
        return nil
    }
}
