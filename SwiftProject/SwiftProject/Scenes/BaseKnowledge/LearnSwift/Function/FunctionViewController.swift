//
//  FunctionViewController.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/1/2.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class FunctionViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK:
        /*
        1 定义和调用函数
        2 函数的形式参数和返回值
        2.1 无形式参数的函数
        2.2 多形式参数的函数
        2.3 无返回值的函数
        2.4 多返回值的函数
        2.5 可选元组返回类型
        2.6 隐式返回的函数
        3 函数实际参数标签和形式参数名
        3.1 指定实际参数标签
        3.2 省略实际参数标签
        3.3 默认形式参数值
        3.4 可变形式参数
        3.5 输入输出形式参数
        4 函数类型
        4.1 使用函数类型
        4.2 函数类型作为形式参数类型
        4.3 函数类型作为返回类型
        5 内嵌函数
 */

        //MARK:函数的形式参数和返回值

       //函数可以作为一个函数的形式参数、返回值。函数也可以内嵌（定义在函数内部）
        // 调用传入参数时，该参数叫做实际参数；函数定义或者函数内部的参数叫做形式参数，形式参数也叫做标签
        // 没有返回值的函数，实际上会返回一个特殊的类型 Void。它其实是一个空的元组，作用相当于没有元素的元组，可以写作 ()
        //当函数被调用时，函数的返回值可以被忽略，或者直接不写
        func printAndCount(string: String) -> Int {
            return string.count
        }
        let _ = printAndCount(string: "string")

        //MARK:多返回值的函数
        // 元组：多个值作为一个复合值，返回类型使用元组可以让函数返回多个值

        func minMax(array: [Int]) -> (min: Int, max: Int) {
            var currentMin = array[0]
            var currentMax = array[0]
            for value in array[1..<array.count] {
                if value < currentMin {
                    currentMin = value
                } else if value > currentMax {
                    currentMax = value
                }
            }
            return (currentMin, currentMax)
        }
        let bounds = minMax(array: [8, -6, 2, 109, 3, 71])

        //可以通过名字访问
        let min = bounds.min
        let max = bounds.max

        print("min is \(min) and max is \(max)")
        // Prints "min is -6 and max is 109"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
