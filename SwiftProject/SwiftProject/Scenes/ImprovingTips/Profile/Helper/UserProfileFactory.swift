//
//  UserProfileFactory.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import Foundation

class UserProfileFactory {

    static var viewModels: [UserProfileSessionViewModelProtocol.Type] = []

    static func register(viewModel: UserProfileSessionViewModelProtocol.Type) {
        if !UserProfileFactory.viewModels.contains(where: { $0 == viewModel }) {
            UserProfileFactory.viewModels.append(viewModel)
        }
    }

    static func createSessionViewModelByDict(data: UserProfileModel) -> [UserProfileSessionViewModelProtocol]? {
        var list:[UserProfileSessionViewModelProtocol] = []
        for type in data.order ?? [] {
            let tclass = getClass(type: type)
            if let tclass1 = tclass {
                list.append(tclass1.init(dictData: data))
            }
        }
        return list
    }


    static func getClass(type: String) -> UserProfileSessionViewModelProtocol.Type? {
        for tClass in UserProfileFactory.viewModels {
            if tClass.canHandle(type: type) {
               return tClass
            }
        }
        return nil
    }
}
