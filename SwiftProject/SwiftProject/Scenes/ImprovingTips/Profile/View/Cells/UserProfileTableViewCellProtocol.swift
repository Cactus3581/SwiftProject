//
//  UserProfileBaseTableViewCell.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

protocol UserProfileTableViewCellProtocol {
    var cellViewModel: Any? { set get }// 提供赋值方式
    var indexPath: IndexPath? { set get }
    static var identifier: String { get }// 注册的时候用
}

extension UserProfileTableViewCellProtocol {
    var cellViewModel: Any? { set{} get{return nil} }
    var indexPath: IndexPath? { set{} get{return nil} }
    static var identifier: String { return "" }
}
