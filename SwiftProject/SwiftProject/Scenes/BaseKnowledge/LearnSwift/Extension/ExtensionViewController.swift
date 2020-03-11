//
//  ExtensionViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/2.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

//扩展和 Objective-C 中的分类类似。但是 Swift 的扩展没有名字

/*
 添加计算实例属性和计算类型属性；
 定义实例方法和类型方法，但是不能重写已有的方法。
 提供新初始化器；
 定义下标；
 定义和使用新内嵌类型；
 使现有的类型遵循某协议
 扩展一个协议，以提供其要求的实现或添加符合类型的附加功能
 */
class ExtensionViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    func s()  {
        let oneInch = 25.km
        print(oneInch)

        var someInt = 3
        someInt.square()
        print(someInt)

        746381295[0]

        let number = 3
        switch number.kind {
        case .negative:
          print("- ", terminator: "")
        case .zero:
          print("0 ", terminator: "")
        case .positive:
          print("+ ", terminator: "")
        }
    }

    func s1()  {
        let centerRect = Rect(center: Point(x: 4.0, y: 4.0),
        size: Size(width: 3.0, height: 3.0))

        //额外：因为 Rect 结构体为其所有属性提供了默认值，会自动生成一个默认的初始化器和一个成员初始化器
        let defaultRect = Rect()
        let memberwiseRect = Rect(origin: Point(x: 2.0, y: 2.0),
                                  size: Size(width: 5.0, height: 5.0))
    }

}

//MARK:添加属性、方法、下标
extension Int {
      //添加计算属性，不能添加存储属性，也不能向已有的属性添加属性观察者。（为了简洁没有使用 get 关键字）
    var km: Int { return self * 1_000}

    //添加（异变）实例方法，mutating关键字表明可以修改
    mutating func square() {
        self = self * self
    }

    //添加下标
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }

    //添加新的内嵌枚举类型
    enum Kind {
        case negative, zero, positive
    }

    //添加了新的计算属性 kind
    var kind: Kind {
       switch self {
       case 0:
           return .zero
       case let x where x > 0:
           return .positive
       default:
           return .negative
       }
    }
  }

//MARK:对值类型新增初始化方法，也能为类添加新的便捷初始化器，但是不能为类添加指定初始化器或反初始化器。指定初始化器和反初始化器 必须由原来类的实现提供。
struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
}

extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}
