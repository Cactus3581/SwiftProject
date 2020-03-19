//
//  UserProfileCTAItemViewModel.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/3/19.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class UserProfileCTAItemViewModel: NSObject, UserProfileCTAItemViewModelProtocol {
    var model: UserProfileCTAItemModel?
    func jump() {
        print(self.model?.title)
    }
}

//MARK:如果需要使用工厂的方式创建
protocol UserProfileCTAItemViewModelProtocol {
    var identifier: String { get }
    var model: UserProfileCTAItemModel? { set get }
    func jump()
}

extension UserProfileCTAItemViewModelProtocol {
    func jump(){}
    var model: UserProfileCTAItemModel? { set{} get{return nil} }
    var identifier: String { return "" }
}

class UserProfileCTAIPhoneViewModel: NSObject, UserProfileCTAItemViewModelProtocol {
    var model: UserProfileCTAItemModel?
    func jump() {
        print(self.model?.title)
    }
}
