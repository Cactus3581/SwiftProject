//
//  UserProfileSectionHeaderViewProtocol.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/17.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

protocol UserProfileSectionViewProtocol {
    var sessionViewModel: UserProfileSessionViewModelProtocol? { set get } // 提供赋值方式
    var section: Int? { set get }
    static var identifier: String { get } // 注册的时候用
}

extension UserProfileSectionViewProtocol {
    var sessionViewModel: UserProfileSessionViewModelProtocol? { set{} get{return nil} }
    var section: Int? { set{} get{return 0} }
    static var identifier: String { return "" }
}
