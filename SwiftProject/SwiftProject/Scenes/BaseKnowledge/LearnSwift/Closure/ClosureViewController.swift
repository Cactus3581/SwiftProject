//
//  ClosureViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/2.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class ClosureViewController: BaseViewController {

    var block1: ((Int, Int) -> Int)?
    var a = 10

    override func viewDidLoad() {
        super.viewDidLoad()


        //MARK:闭包表达式语法

        var closure = { (s1: String, s2: String) -> Bool in
            return s1 > s2
        }

        //  演化
        closure = { s1, s2 in
            return s1 > s2
        }

        closure = {
            s1, s2 in
            s1 > s2
        }

        closure = {
            $0 > $1
        }

        let c =  closure("a","b")
        print(c)


        //MARK:sorted - 排序
        let names = ["Chris","Alex","Ewa","Barry","Daniella"]

        // 方式1:作为函数传进去
        func backward(_ s1: String, _ s2: String) -> Bool {
            return s1 > s2
        }
        var reversedNames = names.sorted(by: backward)
        print(reversedNames)

        // 方式2:作为闭包传进去
        reversedNames = names.sorted(by: closure)
        print("\(reversedNames)")

        // 方式3:直接写闭包
        reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
            return s1 > s2 }
        )

        //简化后
        reversedNames = names.sorted(by: { s1, s2 in
            s1 > s2
        })

        reversedNames = names.sorted(by: {
            $0 > $1
        })

        //MARK:尾随闭包
        // 闭包作为函数最后一个实际参数传递给函数。尾随闭包是一个被书写在函数形式参数的括号外面（后面）的闭包表达式
        reversedNames = names.sorted() { $0 > $1 }

        //如果闭包表达式作为函数的唯一实际参数传入，而又使用了尾随闭包的语法，那你就不需要在函数名后边写圆括号了：
        reversedNames = names.sorted { $0 > $1 }


        //MARK:逃逸闭包：在函数体外可以使用的闭包，一旦不在函数体内，需要使用@escaping修饰
        let block = { (a: Int, b: Int) -> Int in
            return a+b
        }

        func loadData(finished: @escaping (Int,Int) -> Int) {
            // 记录闭包
            self.block1 = finished
        }

        //MARK:自动闭包
        // 直接使用闭包变量，而不是把闭包作为参数传递到某个函数中，然后再调用该函数，函数内再调用闭包
        //滥用自动闭包会导致代码难以读懂

        // 自动闭包一
        var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
        customersInLine.remove(at: 0)
        print(customersInLine.count)
        // Prints "5"

        let customerProvider = { customersInLine.remove(at: 0) }
        print(customersInLine.count)
        // Prints "5"

        print("Now serving \(customerProvider())!")
        // Prints "Now serving Chris!"
        print(customersInLine.count)
        // Prints "4"


        // 自动闭包二
        // 正常的：作为自动闭包二的对比
        // customersInLine is ["Alex", "Ewa", "Barry", "Daniella"]
        func serve(customer customerProvider: () -> String) {
            print("Now serving \(customerProvider())!")
        }
        // 参数为明确的一个闭包，因为使用了{}
        serve(customer: { customersInLine.remove(at: 0) } )
        // Prints "Now serving Alex!"

        // 参数为不明确的一个闭包。不使用明确的闭包而是通过 @autoclosure 标志标记它的形式参数使用了自动闭包。现在你可以调用函数就像它接收了一个 String 实际参数而不是闭包。实际参数自动地转换为闭包，因为 customerProvider 形式参数的类型被标记为 @autoclosure 标记
        // customersInLine is ["Ewa", "Barry", "Daniella"]
        func serve1(customer customerProvider: @autoclosure () -> String) {
            print("Now serving \(customerProvider())!")
        }
        serve1(customer: customersInLine.remove(at: 0))
        // Prints "Now serving Ewa!"


        // 解决方式一: weak
        weak var weakSelf = self
        //解决方式二:  在swift中 有特殊的写法 ,跟OC __weak 相似  [weak self]
        loadData { [weak self] (a, b) -> Int in
            let c = a+b
            //以后在闭包中中 使用self 都是若引用的
            print("\(c) \(self?.a)")
            print("\(c) \(weakSelf?.a)")
            return a+b
        }

        // MARK:高阶函数，基本上都是获取一个闭包表达式作为其唯一参数
        // MARK:map映射，数组中的每一个元素调用一次该闭包函数，并返回闭包计算后的数组
        let values = [2.0,4.0,5.0,7.0]
        var squares = values.map({
          (value: Double) -> Double in
          return value * value
        })
        print(squares)
        squares = values.map { $0 * $0 }
        print(squares)

        // 将公里转化为英里
        let milesToPoint = ["point1":120.0,"point2":50.0,"point3":70.0]
        let kmToPoint = milesToPoint.map { name,miles in miles * 1.6093 }
        print(kmToPoint)

        //MARK:Filter - 过滤 筛选
        let digits = [1, 4, 5, 10, 15]
        var even = digits.filter { (number) -> Bool in
            return number % 2 == 0
        }
        print(even)// [4, 10]
        even = digits.filter { $0 % 2 == 0 }
        print(even)// [4, 10]

        //MARK:Reduce - 组合

        // Reduce函数接收两个参数，一个初始值和一个组合闭包(combine closure)，例如，将一个数组中的各个元素与一个初始值10相加，可以使用reduce函数
        let items = [2.0, 4.0, 5.0, 7.0]
        let total = items.reduce(10, +)
        // 28.0

        //MARK:flatMap
        // flatMap-1:将多维数组‘拍扁’成一个一维数组
        let array1 = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
        let arr3 = array1.map{ $0 }   // [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
        let arr4 = array1.flatMap{ $0 } // [1, 2, 3, 4, 5, 6, 7, 8, 9]

        // flatMap-2:同 map 方法比较类似，只不过它返回后的数组中不存在 nil（自动把 nil 给剔除掉）；同时它会把 Optional 解包。
        let array = ["Apple", "Orange", "Grape", ""]

        let arr1 = array.map { a -> Int? in
            let length = a.count
            guard length > 0 else { return nil }
            return length
        }
        print("arr1:\(arr1)")

        let arr2 = array.flatMap { a-> Int? in
            let length = a.count
            guard length > 0 else { return nil }
            return length
        }
        print("arr2:\(arr2)")

        //MARK:CompactMap
        // 可以把一个集合中的空值去除，并且返回一个去除nil值得数组。 把flatMap的filter过滤nil值的作用单独拿出来，就叫做CompactMap
        let numbers = ["1", "2", "three", nil, "5"]
        let compactMapResult = numbers.compactMap { (number) -> Int? in
            return Int(number)
        }
        print(compactMapResult)



        //MARK:forEach
        let array5 = ["1", "2", "3", "4", "5"]
        array5.forEach { (element) in
            if element == "3" {
                return //跳过本次判断继续执行，类似于continue，但是不能使用 break、continue关键字。for in 使用范围比 forEach更广
            }
            print(element)
        }

        //MARK:zip
        // 将两个序列的元素，一一对应合并生成一个新序列。该函数一般不会单独使用，而是会和其它的方法配合使用。

        //将两个数组合并成一个新的元组数组,使用 zip 结合 map 来合并生成新数组。注意：zip 函数生成的新序列个数为原始序列的最小值。
        let a = [1, 2, 3, 4, 5]
        let b = ["a", "b", "c", "d"]
        let d = zip(a, b).map { $0 }
        print(d)


        let titles = ["按钮1", "按钮2", "按钮3"]
        let buttons = zip(0..., titles).map { (i, title) -> UIButton in
            let button = UIButton(type: .system)
            button.setTitle(title, for:.normal)
            button.tag = i
            return button
        }



    }
}
