//
//  UserProfileFactory.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import Foundation

class UserProfileFactory {

    static var viewModels: [UserProfileViewModelProtocol.Type] = []

    static func register(viewModel: UserProfileViewModelProtocol.Type) {
        if !UserProfileFactory.viewModels.contains(where: { $0 == viewModel }) {
            UserProfileFactory.viewModels.append(viewModel)
        }
    }

    static func createSessionViewModelByDict(data: UserProfileModel) -> [UserProfileViewModelProtocol]? {
        var list:[UserProfileViewModelProtocol] = []
        for type in data.order ?? [] {
            let tclass = getClass(type: type)
            if let tclass1 = tclass {
                list.append(tclass1.init(dictData: data))
            }
        }
        return list
    }

    static func createSessionViewModelByArray(data: UserProfileModel) -> [UserProfileViewModelProtocol]? {
        var list:[UserProfileViewModelProtocol] = []
        for sessionModel in data.list ?? [] {
            let tclass = getClass(type: sessionModel.type ?? "")
            if let tclass1 = tclass {
                list.append(tclass1.init(arrayData: sessionModel))
            }
        }
        return list
    }

    static func getClass(type: String) -> UserProfileViewModelProtocol.Type? {
        for tClass in UserProfileFactory.viewModels {
            if tClass.canHandle(type: type) {
               return tClass
            }
        }
        return nil
    }

    static func createSessionViewModelByArray1(data: UserProfileModel) -> [UserProfileViewModelProtocol]? {
        var list:[UserProfileViewModelProtocol] = []
        for sessionModel in data.list ?? [] {
            let tclass = getClass(type: sessionModel.type ?? "")
            if let tclass1 = tclass {
                list.append(tclass1.init(arrayData: sessionModel))
            }
        }
        return list
    }

}
