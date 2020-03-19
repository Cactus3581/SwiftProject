//
//  UserProfileSectionHeaderViewProtocol.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/3/17.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

protocol UserProfileSectionViewProtocol {
    var sessionViewModel: UserProfileViewModelProtocol? { set get } // 提供赋值方式
    static var identifier: String { get } // 注册的时候用
}

extension UserProfileSectionViewProtocol {
    var sessionViewModel: UserProfileViewModelProtocol? { set{} get{return nil} }
    static var identifier: String { return "" }
}
