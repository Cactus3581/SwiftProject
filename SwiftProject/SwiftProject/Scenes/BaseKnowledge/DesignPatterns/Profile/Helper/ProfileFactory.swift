//
//  ProfileFactory.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/1/5.
//  Copyright © 2020 cactus. All rights reserved.
//

import Foundation
import HandyJSON

class ProfileFactory {

    static var viewModels: [ProfileCellViewModelProtocol.Type] = []
    static func register(vm: ProfileCellViewModelProtocol.Type) {
        if !ProfileFactory.viewModels.contains(where: { $0 == vm }) {
            ProfileFactory.viewModels.append(vm)
        }
    }

    static func createWithContent(data: ProfileModel) -> [ProfileCellViewModelProtocol]? { //返回了一个vm数组

        var array:[ProfileCellViewModelProtocol.Type] = []
        
        for type in data.order ?? [] {
            for tClass in ProfileFactory.viewModels {
                if tClass.canHandle(type: type) {
                    array.append(tClass)
                }
            }
        }

        return array.map { (type) -> ProfileCellViewModelProtocol in
            type.init(data: data)
        }
    }
}
