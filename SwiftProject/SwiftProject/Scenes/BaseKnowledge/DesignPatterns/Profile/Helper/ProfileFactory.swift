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

    public func createWithContent(dict: NSDictionary) -> ProfileCellViewModelProtocol? { //返回了一个vm
//        guard let providerType = ProfileFactory.viewModels.first(where: { (type:ProfileCellViewModelProtocol) -> Bool in
//                type.canHandle(viewModel:vm)
//        }) else {
//            return nil
//        }
//
//        let result = dict["about"]
//        let about = result as![String:Any]
//        if let model = AboutModel.deserialize(from: about) {
//            let aboutVM = ProfileAboutCellViewModel(model: model)
//            return aboutVM
//        }
        return nil
    }
}
