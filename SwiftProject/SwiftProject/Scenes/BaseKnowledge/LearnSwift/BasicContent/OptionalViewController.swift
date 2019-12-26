//
//  OptionalViewController.swift
//  SwiftProject
//
//  Created by ryan on 2019/12/26.
//  Copyright © 2019 cactus. All rights reserved.
//

import UIKit

class OptionalViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        test()
    }

    func test() {
    //MARK：可选项
          /*

           可选项可以有值，也可以没有值，当它没有值时，就是nil。

      1.因为swift中，常量/变量的值不能为nil，一旦值为nil，在取值的时候会crash，而且也不能拿变量直接跟nil做比较，所以有了可选项。
      2.可选项可以包含值也可以是nil，所以当不确定值是否为nil时，必须使用可选项，当确定有值时可以直接使用变量或者自动解包的可选项
      3.当对可选项取值时：必须解包；给可选项赋值时：跟普通变量一样。而且解包的时候必须做判断，判断方法有两个

           4. 判断可选项中是否包含值方法一：if + !
              4.1 使用 if 语句通过比较 nil 来判断一个可选项是否包含值（但是只针对可选项，直接使用变量总是返回true）
              4.2 强制解包：使用 ! 来获取一个不存在的可选值会导致运行错误，在使用!强制展开之前必须确保可选项中包含一个非 nil 的值；
           5. 判断可选项中是否包含值方法二:可选项绑定,如果包含就把值赋给一个临时的常量或者变量,与 if 和 while使用

           nil：
           1. nil为可选项的默认值：如果定义的可选变量没有提供一个默认值，变量会被自动设置成 nil；
           2. nil只能赋值给可选项：可以通过给可选变量赋值一个 nil 来将之设置为没有值；
           3. nil 不能用于非可选的常量或者变量，如果你的代码中变量或常量需要作用于特定条件下的值缺失，可以给他声明为相应类型的可选项；
           4. nil可以是任何数据类型：Objective-C 中 nil 是一个空指针。Swift中的nil 不是指针，他是值缺失的一种特殊类型，任何类型的可选项都可以设置成 nil， 而不仅仅是对象类型

           7. guard：

           */

          // 可选类型的声明
          var serverResponseCode: Int? = 404
          // var serverResponseCode: Int? //也可以这样，默认值是nil
          serverResponseCode = nil
          serverResponseCode = 303

          let possibleNumber = "123"
          let convertedNumber = Int(possibleNumber)// 因为不是所有的字符串都可以转换成整数，所以转化可能会失败，所以它会返回一个可选的 Int ，而不是 Int 。可选的 Int 写做 Int? ，而不是 Int 。问号明确了它储存的值是一个可选项，意思就是说它可能包含某些 Int  值，或者可能根本不包含值。

          // 拆包判断方法一
          if convertedNumber != nil {
              print("\(convertedNumber!)") // 取值时强制解包
          }

          // 拆包判断方法二
          if let constantName = convertedNumber {
              print("\(constantName)") // 不需要解包
          }

          //拆包判断方法三：guard let
          //如果 convertedNumber 有值，那么 convertedNumber 的值也会被保存在 ’number‘ 中
          guard let number = convertedNumber else {
              // 终止方法
              print("nil")
              return
          }

          print("\(number)")// 已经解包

          let possibleString: String? = "An optional string."
          let forcedString: String = possibleString! // 取值时强制解包

          // 自动强制解包（隐式展开可选字符串），前提是必须确认其中有值，那为什么不直接使用变量（非可选值）呢？
          let assumedString: String! = "An implicitly unwrapped optional string."
          let implicitString: String = assumedString // 取值时不需要解包

          //可以像对待普通可选一样对待隐式展开可选项来检查里边是否包含一个值
          if assumedString != nil {
              print(assumedString)
          }
          // 也可以使用隐式展开可选项通过可选项绑定在一句话中检查和展开值
          if let definiteString = assumedString {
              print(definiteString)
          }

          //空合运算符：可选型 ?? 非可选型值。 判断可选型是否为nil，若可选型不为nil对a自动解包，否则返回非可选型的值。

          print("\(possibleString ?? "??")")
          // ?? 即为以下if else的缩写
          func testOption() -> String {
              if possibleString == nil {
                  return "??"
              } else {
                  return possibleString!
              }
          }

          //Optional Chaining
          /*
           当一个Optional值调用它的另一个Optional值的时候，Optional Chaining就形成了，会返回一个Optional的值，只要这个Chaining中有一个值为nil，整条Chaining就为nil.
           */
          // 使用可选链来判断。前提：pet和favoriteToy都是可选属性
          if let age = example(code: "xm")?.age {
              print(age)
          }


          //可选类型的使用场景
          //1. 方法的返回类型为可选类型

          func returnOptionValue(value: Bool) -> String? {
              if value {
                  return "返回类型是可选类型值"
              } else {
                  return nil //返回nil
              }
          }

          let optionValue = returnOptionValue(value: true) // 要用可选绑定判断再使用，因为returnOptionValue为String？可选类型
          if let value = optionValue {
              print(value)
          } else {
              print("none value")
          }


          //返回类型为闭包可选
          func returnOptionalFunc(value: Bool) -> (() -> (Void))? { // 返回类型为可选类型的闭包
              if value {
                  return { () in
                      print("返回类型是可选类型闭包")
                  }
              } else {
                  return nil
              }
          }

          let possibleFunc = returnOptionalFunc(value: true) // 要用可选绑定判断再使用，因为possibleFunc 为可选类型的闭包，类型为() -> (Void)
          if let aFunc = possibleFunc {
              print(aFunc())  // 注意增加()调用闭包，因为没有参数则是空括号
          } else {
              print("none func")
          }

          //可选类型在错误处理中使用（try!与try?）
          func someThrowingFunction() throws -> Int {
              return 1
          }

          let x = try? someThrowingFunction() // x可能正常返回一个Int类型的值也有可能抛出一个错误异常，使用时对x用if let可选绑定判断
          if let x1 = x {
              print("\(x1)")
          } else {

          }

          //as! 与 as? 的类型转换
          let animal:Animal = Cat(name: "cat")
          if let cat = animal as? Cat {
              // 成功会返回可选值，需要拆包使用
              print("\(cat.name)")
          } else {
              //如果转换不成功会返回 nil
              print("cat is nil")
          }
          let cat = animal as! Cat //如果确保肯定会转换成功，则可使用 as!，否则使用 as?

          //Optional可以将方法的返回值强制变为Optional，哪怕这个方法没有返回值，但是Void也算是一个类型：
          if let p: Void = run() {
              p
          }

          let xm = Student()
          xm.age = 3
          xm.name = "XiaoMing"

          //map 也可以是可选类型的一个函数
          print(isAdult(stu: xm) ?? -1)// false

          //由于在 map 方法体中的方法 isAdult 返回值也是可选型的，所以 result 的类型是 Bool??，在使用时我们被迫需要做两次空值判断，而这些操作并没有意义，我们关心的只是结果。
          let result = example(code: "xm").flatMap {
              isAdult(stu: $0)
          }
    }

    func run() {
        print("run")
    }

    // 可选类型作为属性变量（在类或结构体中）
    var someValue1: Int // 必须在构造方法中对其进行初始化

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
       self.someValue1 = 1
       super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }

    class Student {
       var name: String?
       var age: Int?
    }

    func isAdult(stu: Student) -> Bool? {
       //如果一个可选类型有值，map会获取这个值，经过map的闭包处理变为另外一个值，如果这个可选类型的值为nil，那么不会执行map闭包，而是直接返回nil
       let result = stu.age.map {
           $0 >= 18 ? true : false
       }
       return result
    }

    func example(code: String) -> Student? {
       if code == "xm" {
           let xiaoming: Student = Student()
           xiaoming.name = "XiaoMing"
           xiaoming.age = 12
           return xiaoming
       } else if code == "xg" {
           let xiaogang: Student = Student()
           xiaogang.name = "XiaoGang"
           xiaogang.age = 13
           return xiaogang
       }
       return nil
    }

}
