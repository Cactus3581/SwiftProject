//
//  ProtocolViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/2.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

/*
类、结构体、枚举都可以遵循协议；
 一旦遵循了某协议，必须实现协议里的方法
 可以为某个协议添加扩展，实现其中的一些方法
 书写形式：若有继承类，则在协议的前面
 协议也是一个类型：比如 String、Enum、Struct
 协议自身并不实现功能

 类型：从不同维度解读
 1. 实例属性或类型（class、struct、enum）属性
 2. 值类型和引用类型（类类型）
 */
class ProtocolViewController: BaseViewController,FullyNamed222 {

    override func viewDidLoad() {
        super.viewDidLoad()
        addProperty()

        ProtocolViewController.isTransactionPending = true
        print(ProtocolViewController.isTransactionPending)

        struct sda:FullyNamed222 {

        }
    }

    //MARK：使用扩展添加属性
    func addProperty() {

        // 让一个自定义的结构体遵循该协议
        struct Person: FullyNamed {
            // 必须实现协议里的方法，因为编译器默认提供了setter/getter
            var fullName: String
        }

        let john = Person(fullName: "John Appleseed")// 默认提供了成员初始化器
        print(john.fullName)

        // 让一个自定义的类遵循该协议
        class Starship: FullyNamed {
            var prefix: String?
            var name: String
            init(name: String, prefix: String? = nil) {
                self.name = name
                self.prefix = prefix
            }
            var fullName: String {
                return (prefix != nil ? prefix! + " " : "") + name
            }
        }

        var ncc1701 = Starship(name: "Enterprise", prefix: "USS")
        print(ncc1701.fullName)
    }

    //MARK：使用扩展添加(异变)方法
    func addMutatingMethod() {
        //想在一个实例方法内部改变其自身或者自身的实例（通常是值类型），必须使用 mutating 关键字。 mutating 关键字只在结构体和枚举类型中起作用，在class中无需使用，当然加上也不会有问题

        // 让一个自定义的枚举遵循该协议
        enum OnOffSwitch: Togglable {

            case off, on

            mutating func toggle() {
                switch self {
                case .off:
                    self = .on
                case .on:
                    self = .off
                }
            }
        }
        var lightSwitch = OnOffSwitch.off
        lightSwitch.toggle()
        print(lightSwitch)
    }

    //MARK:使用扩展添加初始化方法
    func addInitMethod() {
        PlayerSubClass.init(name: 1)
    }


    //MARK:协议作为类型使用
    func asType() {
        /*
        可以在其他类型使用的地方使用协议，包括以下情景：
        1. 作为函数参数的类型或者返回类型；
        2. 作为常量、变量或者属性的类型；
        3. 作为数组、字典或者其他存储器的元素的类型；
         */

        class Dice {
            let generator: RandomNumberGenerator
            init(generator: RandomNumberGenerator) {
                self.generator = generator
            }

            func roll() -> Int {
                return Int(generator.random())
            }
        }

        class LinearCongruentialGenerator: RandomNumberGenerator {
            func random() -> Double {
                return 5
            }
        }

        let generator = LinearCongruentialGenerator()
        let dice = Dice.init(generator: generator)
        print(dice.roll())

        //作为数组、字典或者其他存储器的元素的类型
        let things: [TextRepresentable] = ["a", "a"]
        for thing in things {
            print(thing.textualDescription)
        }
    }

    //MARK:协议用以委托delegate
    func delegate() {
        //定义协议、遵循协议、实现协议方法、遵循协议的匿名实例对象、匿名实例对象调用协议方法
        // oc和swift的区别在于第四步：遵循协议的匿名实例对象，oc中以属性赋值的方式传进去，而swift经常作为函数参数传进去

        class SnakesAndLadders {
            var delegate: DiceGameDelegate?
            func play() {
                delegate?.gameDidStart()
            }
        }

        class DiceGameTracker: DiceGameDelegate {
            func gameDidStart() {

            }
        }

        let tracker = DiceGameTracker()
        let game = SnakesAndLadders()
        game.delegate = tracker
        game.play()
    }

    //MARK:协议组合
    func combination() {

        let birthdayPerson = Person1(name: "Malcolm", age: 21)
        wishHappyBirthday(to: birthdayPerson)

        //MARK:两种方法检查是否遵循了协议
        if let objectWithArea = birthdayPerson as? Named {
        }

        if birthdayPerson is Named {

        }
    }

    //MARK:协议可选方法
    func optional() {
        class DataSource: CounterDataSource {
            func necessary() {

            }
        }

        var dataSource: CounterDataSource?
        var count = 0

        //可选协议里的方法可以使用可选链：调用方法的时候在方法名后边写一个问号来检查它是否被实现
        if let amount = dataSource?.increment?(forCount: 1) {
            count += amount
        } else if let amount = dataSource?.fixedIncrement {
            count += amount
        }
    }
}

//MARK:协议可选方法
/*
1. Swift协议里定义的方法都是必须实现的。 首先在定义 protocol 时加上@objc 进行转换OC，而且只能被class遵循该协议，然后在协议方法之前加上 @objc @optional
2. 注意 @objc 协议只能被继承自 Objective-C 类或其他 @objc 类采纳。它们不能被结构体或者枚举采纳
 */
@objc protocol CounterDataSource {
    @objc optional func increment(forCount count: Int) -> Int // 整个方法变成可选类型
    @objc optional var fixedIncrement: Int { get }
    func necessary() //必须的
}

//MARK:添加属性：必须明确一个属性是可读的还是可读写的
protocol FullyNamed {
    // 添加一个可读实例属性。可读属性使用 { get } 来明确
    var fullName: String { get }
//    // 添加一个可读写实例属性。可读写属性使用 { get set } 来明确
//    var mustBeSettable: Int { get set }
//
//    // 添加一个可读写类型属性
//    static var someTypeProperty: Int { get set }
}

protocol Togglable {
    mutating func toggle()
}

protocol PlayerProtocol {
    init(name: Int)
}

class PlayerClass: PlayerProtocol {
    // 对于类来说，必须使用 required 关键字修饰协议里的初始化方法，而且在该类的子类中，也必须使用required关键字来重写
    required init(name: Int) {

    }
}

class PlayerSubClass: PlayerClass {
    //当子类重写了父类指定的初始化方法，并且遵循协议实现了初始化器要求，需要在初始化方法前添加 required 和 override 两个修饰符
    required init(name: Int) {
        super.init(name: name)
    }
}

protocol RandomNumberGenerator {
    func random() -> Double
}

protocol DiceGameDelegate {
    func gameDidStart()
}

//MARK:使用扩展遵循协议
//extension DiceGameTracker: DiceGameDelegate {
//    func gameDidStart() {
//
//    }
//}

protocol TextRepresentable {
    var textualDescription: String { get }
}

//MARK:使用扩展提供协议方法的默认实现
extension TextRepresentable {
    var textualDescription: String { "" }
}

//MARK:给协议扩展添加限制
// 给 Collection协议 添加扩展，限制里面的元素都必须遵循 TextRepresentable协议
extension Collection where Iterator.Element: TextRepresentable {
    var textualDescription: String {
        let itemsAsText = self.map { $0.textualDescription }
        return "[" + itemsAsText.joined(separator: ", ") + "]"
    }
}

extension String: TextRepresentable  {
    var textualDescription: String { "test" }
}

//MARK:有条件地遵循协议，除了让 Array 类型遵循意外，数组元素也要遵循该协议
extension Array: TextRepresentable where Element: TextRepresentable {
    var textualDescription: String {
        let itemsAsText = self.map { $0.textualDescription }
        return "[" + itemsAsText.joined(separator: ", ") + "]"
    }
}

//MARK:类专用的协议
//通过添加 AnyObject 关键字到协议的继承列表，可以限制协议只能被类类型遵循（不是结构体或者枚举）。
protocol SomeClassOnlyProtocol: AnyObject, TextRepresentable {

}

//MARK:协议组合
//使用协议组合要求一个类型一次遵循多个协议，使用 SomeProtocol & AnotherProtocol 的形式。也可以使用 SomeClass & SomeProtocol，一个Location 的子类并且遵循 SomeProtocol 协议
protocol Named {
    var name: String { get }
}

protocol Aged {
    var age: Int { get }
}

struct Person1: Named, Aged {
    var name: String
    var age: Int
}

func wishHappyBirthday(to celebrator: Named & Aged) {
    print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
}


protocol FullyNamed222 {

//
    // 添加一个可读写类型属性
    static var isTransactionPending: Bool { get set }
}

extension FullyNamed222 {
    static var isTransactionPending: Bool {
        get{
            return isTransactionPending
        }
        set {
            isTransactionPending = newValue
        }
    }
}
