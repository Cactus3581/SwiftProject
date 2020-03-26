//
//  UserProfileFactory.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import Foundation

class UserProfileViewModelFactory {

    static var ctaViewModels: [UserProfileCTAItemViewModelProtocol.Type] = []
    static var tableViewSessionViewModel: [UserProfileSessionViewModelProtocol.Type] = []
    static var threePointsViewModels: [UserProfileThreePointsItemViewModelProtocol.Type] = []

    static func registerCTAViewModel(viewModel: UserProfileCTAItemViewModelProtocol.Type) {
        if !UserProfileViewModelFactory.ctaViewModels.contains(where: { $0 == viewModel }) {
            UserProfileViewModelFactory.ctaViewModels.append(viewModel)
        }
    }

    static func registerTableViewSessionViewModel(viewModel: UserProfileSessionViewModelProtocol.Type) {
        if !UserProfileViewModelFactory.tableViewSessionViewModel.contains(where: { $0 == viewModel }) {
            UserProfileViewModelFactory.tableViewSessionViewModel.append(viewModel)
        }
    }

    static func registerThreePointsViewModel(viewModel: UserProfileThreePointsItemViewModelProtocol.Type) {
        if !UserProfileViewModelFactory.threePointsViewModels.contains(where: { $0 == viewModel }) {
            UserProfileViewModelFactory.threePointsViewModels.append(viewModel)
        }
    }

    static func createSessionViewModel(data: UserProfileModel) -> [UserProfileSessionViewModelProtocol] {
        var list:[UserProfileSessionViewModelProtocol] = []
        guard let profileInfo = data.profileInfo, let orders = profileInfo.orders else {
            return list
        }
        for type in orders {
            let tclass = getClass(type: type)
            if let tclass = tclass {
                list.append(tclass.init(dictData: data))
            }
        }
        return list
    }


    static func getClass(type: String) -> UserProfileSessionViewModelProtocol.Type? {
        for tClass in UserProfileViewModelFactory.tableViewSessionViewModel {
            if tClass.canHandle(type: type) {
                return tClass
            }
        }
        return nil
    }

    static func createCTAViewModel(data: UserProfileModel) -> [UserProfileCTAItemViewModelProtocol] {
        var list:[UserProfileCTAItemViewModelProtocol] = []
        guard let ctaInfo = data.ctaInfo, let orders = ctaInfo.orders else {
            return list
        }

        for type in orders {
            let tclass = getCTAClass(type: type)
            if let tclass = tclass {
                let ctaModel = tclass.init(ctaInfo: ctaInfo)
                list.append(ctaModel)
            }
        }
        return list
    }

    static func getCTAClass(type: String) -> UserProfileCTAItemViewModelProtocol.Type? {
        for tClass in UserProfileViewModelFactory.ctaViewModels {
            if tClass.canHandle(type: type) {
                return tClass
            }
        }
        return nil
    }

    static func createThreePointsViewModel(list: [ProfileThreePointsInfo]) -> [UserProfileThreePointsItemViewModelProtocol] {
        var list1:[UserProfileThreePointsItemViewModelProtocol] = []


        for item in list {
            guard let type = item.type else {
                continue
            }

            guard let title = item.title else {
                continue
            }

            let tclass = getThreePointsClass(type: type)
            if let tclass = tclass {
                let cTAModel = tclass.init(title: title)
                list1.append(cTAModel)
            }
        }
        return list1
    }

    static func getThreePointsClass(type: String) -> UserProfileThreePointsItemViewModelProtocol.Type? {
        for tClass in UserProfileViewModelFactory.threePointsViewModels {
            if tClass.canHandle(type: type) {
                return tClass
            }
        }
        return nil
    }
}
