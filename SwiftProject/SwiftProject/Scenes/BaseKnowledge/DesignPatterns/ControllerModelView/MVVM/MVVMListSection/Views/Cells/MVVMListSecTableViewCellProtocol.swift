//
//  MVVMListSecBaseTableViewCell.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

protocol MVVMListSecTableViewCellProtocol {
    static var identifier: String { get }
    var cellViewModel: MVVMListSecCellViewModelProtocol? { set get }
}

extension MVVMListSecTableViewCellProtocol {
    var cellViewModel: MVVMListSecCellViewModelProtocol? { set{} get{return nil} }
    static var identifier: String { return "" }
}
