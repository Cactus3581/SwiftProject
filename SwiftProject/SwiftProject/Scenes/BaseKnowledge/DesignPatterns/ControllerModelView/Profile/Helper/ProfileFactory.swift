//
//  ProfileFactory.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/5.
//  Copyright © 2020 cactus. All rights reserved.
//

import Foundation
import HandyJSON

class ProfileFactory {

    static var viewModels: [ProfileCellViewModelProtocol.Type] = []

    static func register(viewModel: ProfileCellViewModelProtocol.Type) {
        if !ProfileFactory.viewModels.contains(where: { $0 == viewModel }) {
            ProfileFactory.viewModels.append(viewModel)
        }
    }

    static func createWithContent(data: ProfileModel) -> [ProfileCellViewModelProtocol]? { //返回了一个vm数组

        var classes:[ProfileCellViewModelProtocol.Type] = []

        guard let order = data.order else {
            return nil
        }

        for type in order {
            for tClass in ProfileFactory.viewModels {
                if tClass.canHandle(type: type) {
                    classes.append(tClass)
                    break
                }
            }
        }

        return classes.map { (type) -> ProfileCellViewModelProtocol in
            type.init(data: data)
        }
//        return createWithContent2(data: data, types: data.order ?? [])
    }

    static func createWithContent1(data: ProfileModel) -> [ProfileCellViewModelProtocol]? { //返回了一个vm数组
        var types:[Int] = []
        let serverList: Array! = data.list
        // 获取 type 未数组
        for dic in serverList {
            let tResult = dic as![String:Any]
            let type = tResult["type"] as! Int
            types.append(type)
        }
        return createWithContent2(data: data, types: types)
    }

    static func createWithContent2(data: ProfileModel, types:[Int]) -> [ProfileCellViewModelProtocol]? { //返回了一个vm数组

        var clses:[ProfileCellViewModelProtocol.Type] = []
        var vms:[ProfileCellViewModelProtocol] = []

        let serverList: Array! = data.list

        // 根据type数组，找到对应的类，并装入排序好的类数组
        for type in types {
            for tClass in ProfileFactory.viewModels {
                if tClass.canHandle(type: type) {
                    clses.append(tClass)
                    break
                }
            }
        }

        // 获取类创建对象的数据
        for (index, dic) in serverList.enumerated() {
            let tResult = dic as![String:Any]
            let cls:ProfileCellViewModelProtocol.Type = clses[index];
            // 使用type创建vm对象，参数为dict；
            let obj:ProfileCellViewModelProtocol = cls.init(dict:tResult)
            vms.append(obj)
        }

        return vms as? [ProfileCellViewModelProtocol]
    }
}
