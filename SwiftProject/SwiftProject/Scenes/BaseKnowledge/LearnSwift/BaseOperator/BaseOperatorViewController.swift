//
//  BaseOperatorViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/3.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class BaseOperatorViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK:合并空值运算符 ??
        // 如果可选项 a  有值则展开，如果没有值，是 nil  ，则返回默认值 b 。表达式 a 必须是一个可选类型。表达式 b  必须与 a  的储存类型相同。

        let a: String? = "a"
        let b = "b"
        let c = a ?? b
        print(c)

        // MARK:区间运算符

        // 闭区间运算符:(a...b ）包含 a  和 b, a但是a的值不能大于 b

        for index in 1...5 {
            print("\(index)")
        }

        //半开区间运算符:(a..<b）定义了从 a 到 b 但不包括 b  的区间，只包含起始值但并不包含结束值
        for index in 1..<5 {
            print("\(index)")
        }

        //单侧区间: 指定索引开始/结束
        let names = ["Anna", "Alex", "Brian", "Jack"]

        for name in names[2...] {
            print(name)//  Brian Jack
        }

        for name in names[...2] {
            print(name)// Anna  Alex Brian
        }

        for name in names[..<2] {
            print(name)
        }

        //单侧区间也可以在其他上下文中使用，不仅仅是下标
        let range = ...5
        range.contains(7)   // false
        range.contains(4)   // true
        range.contains(-1)  // true
    }
}
