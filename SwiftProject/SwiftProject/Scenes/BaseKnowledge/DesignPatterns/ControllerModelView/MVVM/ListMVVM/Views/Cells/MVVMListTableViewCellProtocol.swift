//
//  MVVMListBaseTableViewCell.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

protocol MVVMListTableViewCellProtocol {
    var cellViewModel: MVVMListCellViewModelProtocol? { set get }
    static var identifier: String { get }
}

extension MVVMListTableViewCellProtocol {
    var cellViewModel: MVVMListCellViewModelProtocol? {set{} get{return nil} }
}
