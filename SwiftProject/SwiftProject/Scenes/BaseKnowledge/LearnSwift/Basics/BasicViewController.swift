//
//  BasicViewController.swift
//  SwiftProject
//
//  Created by ryan on 2019/12/24.
//  Copyright © 2019 cactus. All rights reserved.
//

import UIKit

class BasicViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func test() {
        // MARK: 常量和变量
        // 如果存储的值不会改变，请用 let 关键字将之声明为一个常量。只有储存会改变的值时才使用变量。
        let maximumNumberOfLoginAttempts = 10
        var currentLoginAttempt = 0

        //类型标注：如果在定义一个常量或者变量的时候就给他设定一个初始值，那么 Swift 可以推断出这个常量或变量的类型。如果没有提供初始值，可以使用类型标注来明确它的类型而不是通过初始值的类型推断出来的。
        var welcomeMessage: String
        welcomeMessage = "Hello"

        //输出常量和变量
        print("The current value of friendlyWelcome is \(welcomeMessage)")

        // 注释

        // 单行注释

        /* 多行注释 */

        /* 内嵌多行注释
        /* 内嵌多行注释 */
        内嵌多行注释*/

        // MARK:整数和浮点数

        //整数可以是有符号（正，零或者负），或者无符号（正数或零）。前者使用Int，后者适应 UInt。只在的确需要存储一个和当前平台原生字长度相同的无符号整数的时候才使用 UInt 。其他情况下，推荐使用 Int。即使我们知道代码中的整数变量和常量是非负的，我们也会使用 Int 类型。

        // 浮点数：浮点数是有小数的数字，比如 3.14 和 -273.15 。浮点类型相比整数类型来说能表示更大范围的值，可以存储比 Int 类型更大或者更小的数字。Swift 提供了两种有符号的浮点数类型。Double代表 64 位的浮点数，Float 代表 32 位的浮点数。推荐使用 Double 类型。

        // MARK:类型安全和类型推断

        //类型安全：在编译代码的时候会进行类型检查，如果某个变量/常量的类型和值不匹配则会编译错误
        //类型推断：通过检查给变量赋的值，能够在编译阶段自动的推断出值的类型。
        // 字面量其实就是一种语法糖，为了使表达式更简单

        //MARK:数值型字面量

        /*数型字面量可以写作：
        一个十进制数，没有前缀
        一个二进制数，前缀是 0b
        一个八进制数，前缀是 0o
        一个十六进制数，前缀是 0x*/
        let decimalInteger = 17
        let binaryInteger = 0b10001 // 17 in binary notation
        let octalInteger = 0o21 // 17 in octal notation
        let hexadecimalInteger = 0x11 // 17 in hexadecimal notation

        //整数和浮点数转换
        //整数和浮点数类型的转换必须显式地指定类型：
        let three = 3
        let pointOneFourOneFiveNine = 0.14159
        let pi = Double(three) + pointOneFourOneFiveNine
        let integerPi = Int(pi)

        //MARK:类型别名
        //类型别名可以为已经存在的类型定义了一个新的可选名字。用 typealias 关键字定义类型别名。
        typealias AudioSample = UInt16
        var maxAmplitudeFound = AudioSample.min//调用 AudioSample.min 其实就是在调用 Int16.min

        //MARK:布尔值
        //true 和 false ,在swift中，1 不能代表true
        let orangesAreOrange = true
        let turnipsAreDelicious = false
        if turnipsAreDelicious {
            print("Mmm, tasty turnips!")
        } else {
            print("Eww, turnips are horrible.")
        }

        //MARK:元组
        //元组把多个值合并成单一的复合型的值。元组内的值可以是任何类型，而且可以不必是同一类型。通常作为函数返回值

        //可以被描述为“一个类型为 (Int, String)  的元组”
        let http404Error = (404, "Not Found")
        let (statusCode, statusMessage) = http404Error

        //可以将一个元组的内容分解成单独的常量或变量
        print("The status code is \(statusCode)")
        print("The status message is \(statusMessage)")

        // 当分解元组的时候，如果只需要使用其中的一部分数据，不需要的数据可以用下滑线（ _ ）代替：
        let (justTheStatusCode, _) = http404Error
        print("The status code is \(justTheStatusCode)")

        //也可以使用从零开始的索引数字访问元组中的单独元素
        print("The status code is \(http404Error.0)")
        print("The status message is \(http404Error.1)")

        //在定义元组的时候给其中的单个元素命名，在命名之后，可以通过访问名字来获取元素的值
        let http200Status = (statusCode: 200, description: "OK")
        print("The status code is \(http200Status.statusCode)")
        print("The status message is \(http200Status.description)")
    }
}
