//
//  HigherOrderFunctionsViewController.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/4/2.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class HigherOrderFunctionsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        map()
        filter()
        reduce()
        flatMap()
    }
    
    //MARK:Map 映射
    func map() {
        //集合类型都可以使用
        let array = [2, 4, 6, 8]
        let array1 = array.map { String($0) }
        print(array1)
    }

    //MARK:Filter - 过滤 筛选
    func filter() {
        let array = [2, 4, 6, 8]
        let array1 = array.filter { $0 > 4 }
        print(array1)
    }

    //MARK:Reduce - 组合
    func reduce() {
        //将一个数组中的各个元素与一个初始值10相加，
        let array = [2, 4, 6, 8]
        let array1 = array.reduce(1, +)
        print(array1)
    }

    //MARK:FlatMap - 将多个集合对象扁平化为一个数组
    func flatMap() {
        let array = [[3, 2, 1], [4, 5], [8, 7, 9]]
        let array1 = array.flatMap { $0 }
        print(array1)
    }
}
