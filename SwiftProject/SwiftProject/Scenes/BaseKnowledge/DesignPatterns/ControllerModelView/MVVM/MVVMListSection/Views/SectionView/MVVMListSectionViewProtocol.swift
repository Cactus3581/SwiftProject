//
//  MVVMListSectionTextHeaderViewProtocol.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/17.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

protocol MVVMListSectionViewProtocol {
    var sessionViewModel: MVVMListSectionViewModelProtocol? { set get } // 提供赋值方式
    static var identifier: String { get } // 注册的时候用
}

extension MVVMListSectionViewProtocol {
    var sessionViewModel: MVVMListSectionViewModelProtocol? { set{} get{return nil} }
    static var identifier: String { return "" }
}
