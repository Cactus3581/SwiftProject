//
//  GenericsViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/3.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class GenericsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK:定义和使用泛型
        /*
        泛型 Element 泛指任意类型,可保证参数item的类型的随意性；
        T，U等任意字母或者Element等单词都可以，没有具体的限制
        */

        struct Stack<Element> {
            var items = [Element]()
            mutating func push(_ item: Element) {
                items.append(item)
            }
            mutating func pop() -> Element {
                return items.removeLast()
            }
        }

        var stackOfStrings = Stack<String>()
        stackOfStrings.push("uno")
        stackOfStrings.push("dos")
        stackOfStrings.push("tres")
        stackOfStrings.push("cuatro")

        /* 此处最大的不同是，singleGenericFunc中的参数x的类型与方法的返回类型是一致的。而singleAnyFunc中却没有这个特性。x与方法的返回类型都可以是任意值，不一定相同。
        这是由于泛型的类型检查由编译器负责，而Any修饰则避开了类型系统。
        综合比较而言，应该尽量多使用泛型，少使用Any，以尽量转换类型时发生的类型错误。
        */

        //泛型修饰
        func singleGenericFunc<T>(x: T ,y: Int)-> T {
            return x
        }
        singleGenericFunc(x: 2, y: 1)

        //Any修饰
        /*
         AnyObject只能用于任何类（class）的实例，不能用于值类型
         */
        func singleAnyFunc(x: Any,y:Int) -> Any {
            return x
        }

        singleAnyFunc(x: 2, y: 1)


        //MARK:泛型的类型约束
        //类型约束：可以是某个父类，某个协议，以<T: Equatable>的形式，表示”任何遵循该协议的类型 T “，”任何继承自 someClass 类的类型 T “
        func findIndex<T: Equatable>(of valueToFind: T, in array:[T]) -> Int? {
            for (index, value) in array.enumerated() {
                if value == valueToFind {
                    return index
                }
            }
            return nil
        }


        if let doubleIndex = findIndex(of: 9.3, in: [3.14159, 0.1, 0.25]) {

        }
        if let stringIndex = findIndex(of: "Andrea", in: ["Mike", "Malcolm", "Andrea"]) {

        }


    }

}
