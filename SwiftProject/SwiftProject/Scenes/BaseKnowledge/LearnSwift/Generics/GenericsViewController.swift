//
//  GenericsViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/3.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

/*
泛型解决的是数据的通用性问题，包容性更强。类似于定义z一种类型，比如String
Swift 的 Array 和 Dictionary 类型都是泛型集合

 1. 定义泛型，熟悉泛型的使用场景
 2. 关联类型
 3. 类型约束
 4. where分句
 5. 使用扩展帮助泛型
 */
class GenericsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        swapTwo()

        func pushItemOneToTwo<C1: Sequence, C2: Sequence>( stackOne: inout C1, stackTwo: inout C2)
            where C1.Element == C2.Element {
                
        }

    }


    //MARK:泛型函数
    func swapTwo() {
        /*
         1. 使用占位符类型名（这里叫做 T ），而不是一个实际的类型名（比如 Int 、 String 或 Double ）；
         2. 占位符类型名没有声明 T 具体是什么类型，但是它指定了后面的函数参数a 和 b 必须都属于同一种类型 T；
         3. 替代 T 实际使用的类型将在每次调用 swapTwoValues(_:_:) 函数时决定。
         4. 命名类型形式参数，一般按惯例用单个字母命名，比如 T 、 U 、 V，以指明它们是一个类型的占位符，不是一个值。


         使用时：
         1. 在函数名后面，先定义一个类型： <Name>,name可以随便定
         2. 只关心函数参数的类型是否一致，不会在意具体类型；
         3. 调用函数时，实际类型会替换类型参数T。比如用 Int 替换了 T
        */

        func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
            let temporaryA = a
            a = b
            b = temporaryA
        }
    }

    func sada11() {
        //因为它是泛型，所以可以以 Array 和 Dictionary 的方式来使用，创建了元素为任意类型的栈
        //通过在尖括号中写出存储在栈里的类型，来创建一个新的 Stack 实例；
        var stackOfStrings = Stack<String>()
        stackOfStrings.push("uno")
        stackOfStrings.pop()

        if let topItem = stackOfStrings.topItem {
            print("The top item on the stack is \(topItem).")
        }
    }

    //MARK:类型约束
    //表示任何遵循 Equatable 协议的类型T
    func findIndex<T: Equatable>(of valueToFind: T, in array:[T]) -> Int? {
        for (index, value) in array.enumerated() {
            if value == valueToFind {
                return index
            }
        }
        return nil
    }



}

//MARK:自定义泛型类型，可以用于任意类型的自定义类、结构体、枚举，和 Array 、 Dictionary 方式类似。
 //定义一个泛型 Stack
/*
 1. 用一个叫做 Element 的类型形式参数代替了实际的 Int 类型。Element叫做占位符
 2. 这个类型形式参数写在一对尖括号 <> 里；
 3. 紧跟在结构体名字后面
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

//MARK:扩展一个泛型类型
//不需要在扩展的定义中提供类型形式参数，因为 Stack 已有该类型形式参数
extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

//MARK:协议的关联类型
//在协议里使用associatedtype声明关联类型，处理逻辑相同而数据类型不同的情况
//associatedtype让开发者在遵守协议时根据需求去定义返回值的类型，而不是在协议中写死
protocol Container1 {
    associatedtype ItemType
    mutating func append(_ item: ItemType)
    var count: Int { get }
    subscript(i: Int) -> ItemType { get }
}

struct IntStack: Container1 {

    var items = [Int]()
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }

    // 遵守该协议的类型中使用typealias规定具体的类型。编译器通过查看 append(_:) 方法的item参数，可以推断出合适的 ItemType是Int类型，所以有时候可以省略。
    typealias ItemType = Int
    mutating func append(_ item: Int) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Int {
        return items[i]
    }
}

//MARK:类型约束
//给协议的关联类型添加约束
protocol Container2 {
    associatedtype Item: Equatable //必须遵循 Equatable 协议
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

//使用where分句给协议的关联类型添加约束
protocol SuffixableContainer: Container2 {
    //Suffix 是一个关联类型，拥有两个约束：必须遵循 SuffixableContainer 协议（当前定义的协议），以及它的 Item 类型必须是和Container2里的 Item 类型相同。
    associatedtype Suffix: SuffixableContainer where Suffix.Item == Item

    func suffix(_ size: Int) -> Suffix
}


//MARK:类型约束2：通过定义一个泛型Where分句来实现
extension Stack where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}
