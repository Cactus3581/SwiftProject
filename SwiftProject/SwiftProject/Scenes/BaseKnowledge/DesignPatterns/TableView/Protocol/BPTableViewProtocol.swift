//
//  BPTableViewProtocol.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/1/15.
//  Copyright © 2020 cactus. All rights reserved.
//

import Foundation
import UIKit

// MARK: viewModel 协议
protocol BPSessionViewModelProtocol {

    // 定义构造函数
    init(data: ProfileModel)

    var array: [BPCellViewModelProtocol]? { get }

    // cellVM的通用方法
    var rowCount: Int { get }
}

extension BPSessionViewModelProtocol {

    var array: [BPCellViewModelProtocol]? { return nil }

    init(data: Any) {
        self.init(data: data)
    }

    var rowCount: Int { return 0 }
}

protocol BPCellViewModelProtocol {

    // 定义构造函数
    init(data: BPModel)
    static func canHandle(type: String) -> Bool

    // cellVM的通用方法
    var res: String { get }
    var cellHeight: CGFloat { get }
}

extension BPCellViewModelProtocol {
    init(data: BPModel) {
        self.init(data: data)
    }
    static func canHandle(type: String) -> Bool {
        return false
    }

    var cellHeight: CGFloat { return 0 }
    var res: String { return "" }
}

// MARK: viewModel 协议
protocol BPTableCellProtocol {
    // 定义传值函数

    func setData(data:BPCellViewModelProtocol)
}

extension BPTableCellProtocol {

    func setData(data:BPCellViewModelProtocol) {

    }
}
