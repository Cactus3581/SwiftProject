//
//  EnumViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/2.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class EnumViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //用 enum 关键字来定义一个枚举
        //枚举成员在被创建时不会分配一个默认的整数值。下面的枚举成员并不代表 0， 1， 2和 3
        enum CompassPoint {
            case north //枚举的成员值（或成员）
            case south
            case east
            case west
        }

        //多个成员值可以出现在同一行中，要用逗号隔开：
        enum Planet {
            case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
        }

        //MARK: 正常使用
        var directionToHead = CompassPoint.west
        print("\(directionToHead)")

        switch directionToHead {
            case .north:
                print("Lots of planets have a north")
            case .south:
                print("Watch out for penguins")
            case .east:
                print("Where the sun rises")
            case .west:
                print("Where the skies are blue")
            default://如果不能为所有枚举成员都提供一个 case，可以提供一个 default情况来包含那些不能被明确写出的成员：
                print("Not a safe place for humans")
        }

        //MARK: 点语法访问
        // 如果定义的枚举变量被显示指明还是被编译器推断出来，就可以用【点语法】来访问
        directionToHead = .west
        print("\(directionToHead)")
        let directionToHead1: CompassPoint = .west
        print("\(directionToHead1)")


        //MARK: 遍历枚举情况（case）
        //需要在枚举名字后面声明遵循 CaseIterable 协议，会生成一个叫allCases的集合，里面包括了所有的枚举值
        enum Beverage: CaseIterable {
            case coffee, tea, juice
        }
        let numberOfChoices = Beverage.allCases.count
        print("\(numberOfChoices) beverages available")
        for beverage in Beverage.allCases {
            print(beverage)
        }

        //MARK: 关联值
        //可以在枚举值后面关联一个任意的值实现存储，每个枚举值的关联值的类型可以不相同
        enum Barcode {
            case upc(Int, Int, Int, Int)//关联了一个元组值。
            case qrCode(String)
        }

        var productBarcode = Barcode.upc(8, 85909, 51226, 3)
        productBarcode = .qrCode("ABCDEFGHIJKLMNOP")

        switch productBarcode {
            //关联值可以作为常量或者变量
            case .upc(let numberSystem, let manufacturer, let product, let check):
                print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
            case .qrCode(let productCode):
                print("QR code: \(productCode).")
        }

        //如果对于一个枚举成员的所有的相关值都被提取为常量，或如果都被提取为变量，为了简洁，可以用一个单独的 var或 let在成员名称前标注
        switch productBarcode {
        case let .upc(numberSystem, manufacturer, product, check):
            print("UPC : \(numberSystem), \(manufacturer), \(product), \(check).")
        case let .qrCode(productCode):
            print("QR code: \(productCode).")
        }

        //MARK:原始值
        //每个枚举值的类型都是相同的
        enum ASCIIControlCharacter: Character {
            case tab = "\t"
            case lineFeed = "\n"
            case carriageReturn = "\r"
        }

        //MARK:隐式指定的原始值
        // 指定枚举类型为整数或字符串时，不需要显式地给每一个成员都分配一个原始值。因为编译器会自动分配值

        // Int：当指定Int类型时，默认是0，后面会自增。
        enum Planet1: Int {
            case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
        }

        // String：当指定String类型时，每一个成员的隐式原始值则是那个成员的名称
        enum CompassPoint1: String {
            case north, south, east, west
        }

        //使用 rawValue 属性来访问一个枚举成员的原始值
        let earthsOrder = Planet1.earth.rawValue
        // earthsOrder is 3

        let sunsetDirection = CompassPoint1.west.rawValue
        // sunsetDirection is "west"

        //根据原始值找到枚举成员变量
        //因为原始值的初始化器可能会找不到该成员值变量，所以会返回可选值。
        let possiblePlanet = Planet1(rawValue: 7)
        if let planet = possiblePlanet {
            print(planet)
        }

        let positionToFind = 11
        if let somePlanet = Planet1(rawValue: positionToFind) {
            switch somePlanet {
                case .earth:
                    print("Mostly harmless")
                default:
                    print("Not a safe place for humans")
            }
        } else {
            print("There isn't a planet at position \(positionToFind)")
        }

        //MARK:递归枚举
        //递归枚举是拥有另一个枚举作为枚举成员关联值的枚举。在声明枚举成员之前使用 indirect关键字来明确它是递归的
        enum ArithmeticExpression {
            case number(Int)
            indirect case addition(ArithmeticExpression, ArithmeticExpression)
            indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
        }

//        indirect enum ArithmeticExpression {
//            case number(Int)
//            case addition(ArithmeticExpression, ArithmeticExpression)
//            case multiplication(ArithmeticExpression, ArithmeticExpression)
//        }

        let five = ArithmeticExpression.number(5)
        let four = ArithmeticExpression.number(4)
        let sum = ArithmeticExpression.addition(five, four)
        let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))

        //递归函数是一种操作递归结构数据的简单方法。比如说，这里有一个判断数学表达式的函数：
        func evaluate(_ expression: ArithmeticExpression) -> Int {

            switch expression {
                case let .number(value):
                    return value
                case let .addition(left, right):
                    return evaluate(left) + evaluate(right)
                case let .multiplication(left, right):
                    return evaluate(left) * evaluate(right)
            }
        }

        print(evaluate(product))
        // Prints "18"


        test()
        self.test()

        var dict: [CompassPoint: String] = [:]
        dict[.west] = "a"

        print(dict)

        dict[.west] = {() -> (String) in
            return "b"
        }()
//            {}()
//
//        let a = {
//            print("c")
//        }()
//
//        print("\(dict[.west])")
//
//        if let block = dict[.west] {
//            print("\(block)")
//        }
    }

    func test() {

    }

    func test2() {

    }
}
