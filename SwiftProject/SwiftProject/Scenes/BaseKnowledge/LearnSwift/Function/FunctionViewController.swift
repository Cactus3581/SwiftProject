//
//  FunctionViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/2.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class FunctionViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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

        // MARK:输入输出参数
        func swapTwoInts(_ a: inout Int, _ b: inout Int) {
            let temporaryA = a
            a = b
            b = temporaryA
        }
        var a = 1;
        var b = 2;
        swapTwoInts(&a, &b)
        print("\(a),\(b)")

        //MARK:函数作为普通类型赋值
        func addTwoInts(_ a: Int, _ b: Int) -> Int {
            return a + b
        }
        let mathFunction: (Int, Int) -> Int = addTwoInts
        print("Result: \(mathFunction(2, 3))")

        //MARK:函数作为参数
        func printMathResult(_ mathFunction: (Int, Int) -> Int, _ a: Int, _ b: Int) {
            print("Result: \(mathFunction(a, b))")
        }
        printMathResult(addTwoInts, 3, 5)

        //MARK:函数作为返回值
        func stepForward(_ input: Int) -> Int {
            return input + 1
        }
        func stepBackward(_ input: Int) -> Int {
            return input - 1
        }
        func chooseStepFunction(backwards: Bool) -> (Int) -> Int {
            return backwards ? stepBackward : stepForward
        }
        var currentValue = 3
        var moveNearerToZero = chooseStepFunction(backwards: currentValue > 0)
        while currentValue != 0 {
            currentValue = moveNearerToZero(currentValue)
        }

        //MARK:内嵌函数
        func chooseStepFunction1(backward: Bool) -> (Int) -> Int {
            func stepForward(input: Int) -> Int {
                return input + 1
            }
            func stepBackward(input: Int) -> Int {
                return input - 1
            }
            return backward ? stepBackward : stepForward
        }
        moveNearerToZero = chooseStepFunction1(backward: currentValue > 0)
        currentValue = moveNearerToZero(currentValue)
        print("\(currentValue)")
    }
}
