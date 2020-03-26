//
//  UserProfileFactory.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import Foundation

class UserProfileViewModelFactory {

    static var threePointsViewModels: [UserProfileThreePointsItemViewModelProtocol.Type] = []
    static var ctaViewModels: [UserProfileCTAItemViewModelProtocol.Type] = []
    static var ctaViews: [UserProfileCTAItemViewProtocol.Type] = []
    static var tableViewSessionViewModel: [UserProfileSessionViewModelProtocol.Type] = []

    //MARKL:注册
    static func registerThreePointsViewModel(viewModel: UserProfileThreePointsItemViewModelProtocol.Type) {
        if !UserProfileViewModelFactory.threePointsViewModels.contains(where: { $0 == viewModel }) {
            UserProfileViewModelFactory.threePointsViewModels.append(viewModel)
        }
    }

    static func registerCTAViewModel(viewModel: UserProfileCTAItemViewModelProtocol.Type) {
        if !UserProfileViewModelFactory.ctaViewModels.contains(where: { $0 == viewModel }) {
            UserProfileViewModelFactory.ctaViewModels.append(viewModel)
        }
    }

    static func registerCtaView(view: UserProfileCTAItemViewProtocol.Type) {
        if !UserProfileViewModelFactory.ctaViews.contains(where: { $0 == view }) {
            UserProfileViewModelFactory.ctaViews.append(view)
        }
    }

    static func registerTableViewSessionViewModel(viewModel: UserProfileSessionViewModelProtocol.Type) {
        if !UserProfileViewModelFactory.tableViewSessionViewModel.contains(where: { $0 == viewModel }) {
            UserProfileViewModelFactory.tableViewSessionViewModel.append(viewModel)
        }
    }

    //MARKL:创建
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

    static func viewWithType(type: String) -> UserProfileCTAItemViewProtocol? {
        guard let ctaItemViewClass =  getCTAViewClass(type: type) else {
            return nil
        }
        let view = ctaItemViewClass.init()
        return view
    }

    static func getCTAViewClass(type: String) -> UserProfileCTAItemViewProtocol.Type? {
        for tClass in UserProfileViewModelFactory.ctaViews {
            if tClass.canHandle(type: type) {
                return tClass
            }
        }
        return nil
    }

    static func createCTAViewModel(data: [String: Any]) -> [UserProfileCTAItemViewModelProtocol] {
        var list:[UserProfileCTAItemViewModelProtocol] = []

        guard let ctaInfo = data["ctaInfo"] as? [String: Any], let ctas = ctaInfo["ctas"] as? [Any] else {
            return list
        }

        for item in ctas {

            guard let item = item as? [String: Any] else {
                continue
            }

            guard let type = item["type"] as? Int else {
                continue
            }

            guard let tclass = getCTAClass(type: type) else {
                continue
            }
            let ctaViewModel = tclass.init(ctaItem: item)
            list.append(ctaViewModel)
        }
        return list
    }

    static func getCTAClass(type: Int) -> UserProfileCTAItemViewModelProtocol.Type? {
        for tClass in UserProfileViewModelFactory.ctaViewModels {
            if tClass.canHandle(type: type) {
                return tClass
            }
        }
        return nil
    }

    static func createSessionViewModel(data: [String: Any]) -> [UserProfileSessionViewModelProtocol] {
        var list:[UserProfileSessionViewModelProtocol] = []
        guard let profileInfo = data["profileInfo"] as? [String: Any], let profiles = profileInfo["profiles"] as? [Any] else {
            return list
        }

        for item in profiles {

            guard let item = item as? [String: Any] else {
                continue
            }

            guard let type = item["type"] as? Int else {
                continue
            }

            guard let tclass = getClass(type: type) else {
                continue
            }
            let sessionViewModel = tclass.init(profileItem: item)
            list.append(sessionViewModel)
        }
        return list
    }


    static func getClass(type: Int) -> UserProfileSessionViewModelProtocol.Type? {
        for tClass in UserProfileViewModelFactory.tableViewSessionViewModel {
            if tClass.canHandle(type: type) {
                return tClass
            }
        }
        return nil
    }
}
