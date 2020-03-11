//
//  ARCViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/3.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class ARCViewController: BaseViewController {

    var name:String = "name"

    override func viewDidLoad() {
        super.viewDidLoad()
        /*

         引用计数只应用于类的实例。结构体和枚举是值类型，不是引用类型，没有通过引用存储和传递。

         创建一个指针变量指向刚创建的一个类的实例
         mrc：在函数尾，需要使用release方法，释放内存，指针变量会被编译器自动释放
         arc：不需要手动release
         swift+arc：如果只是将指针变量置为nil，效果是否和release一样。
         */


        //MARK:循环强引用
        /*使用弱引用( weak )或无主引用( unowned )，原理都是允许循环引用中的一个实例引用另外一个实例而不保持强引用
        //弱引用：对于生命周期中会变为 nil 的实例使用弱引用。一定得是可选类型。在 ARC 给弱引用设置 nil 时不会调用属性观察者。
        无主引用：假定是永远有值的。因此，无主引用总是被定义为非可选类型。你可以在声明属性或者变量时，在前面加上关键字 unowned 表示这是一个无主引用。
        */

        //MARK:闭包的循环强引用
        //闭包以无主引用的形式捕获 self，不会强持有self。遵从：如果被捕获的引用永远不会变为 nil ，应该用无主引用而不是弱引用。所以无主引用是正确的解决循环强引用的方法
        var someClosure: (Int, String) -> String = {
            [unowned self] (index: Int, stringToProcess: String) -> String in
            // closure body goes here
            return self.name
        }

        var someClosure1: () -> String = {
            [unowned self] in
            return self.name
        }






    }
}
