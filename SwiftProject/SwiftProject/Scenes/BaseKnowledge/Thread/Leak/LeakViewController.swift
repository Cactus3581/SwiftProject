//
//  LeakViewController.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2021/12/29.
//  Copyright © 2021 cactus. All rights reserved.
//

import UIKit

/* 结论
 1. self不会持有栈变量，即使这个栈变量是闭包
2. 闭包的历程一般分为三个阶段：构造闭包前、构造闭包时、执行闭包函数时。对self的引用计数+1来源于构造闭包时，在执行闭包函数时，如果单纯使用self，并不会让self+1。所以在会引起循环引用的前提下，只要给闭包赋值了，就会造成循环引用，即使闭包不执行
 3. 闭包是否是属性变量，是否执行过，这两个因素是否会影响到所持有的self的引用计数？
    1. 如果闭包（本质上是函数）是栈变量，当闭包所在的栈结束时，闭包被释放，所以它对闭包内的变量都会执行-1操作，不管这个闭包是否执行过
    2. 如果闭包（本质上是函数）是属性变量，因为作为属性的存在，所以它对闭包内的变量一直强持有，即使该闭包执行完了，也不会对闭包内的变量进行-1操作
 4. 解决循环引用的两种方案：
    1. 一方对另一方是弱引用，可以使用weak修饰符，weak的作用，让闭包不强持有self，即self的引用技术不会因为闭包持有self而 +1
    2. 在对象释放前，手动释放对对方的引用，比如 将对方置为nil，即泄去引用
 */
class LeakViewController: BaseViewController {

    var task: (() -> Void)?
    var task1: (() -> Void)?

    var aView: UIView = {
        let a = UILabel()
//        self.view.backgroundColor = .red  // 持有self，会引起编译错误：提醒循环引用
//        let a = UIButton()
//        a.addTarget(self, action: #selector(test1), for: .touchUpInside) // 虽然不会引起编译错误，但是 self 会出问题
        return a
    }()

    deinit {
        print("测试循环引用导致的内存泄露")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        test1()
//        test2()
//        test3(vc: self)
//        test4()
        test5()
//        test6()
//        test7()
//        test8()
//        test9()
    }

    // MARK: 测试 1 闭包作为变量，不会导致循环引用
    @objc func test1() {
        // 没有谁持有task，task持有self，没有形成循环引用
        // 相当于执行到这个时候，构造了闭包，闭包内使用了self，对self的引用计数+1
        let task = {
            self.view.backgroundColor = .red
            print("1")
        }
        task()
    }

    // MARK: 测试 2 闭包作为属性，会导致循环引用
    func test2() {
        // self持有task，task持有self，所以形成循环引用
        self.task = {
            self.view.backgroundColor = .red
        }
        self.task?() // 即使注释掉，不调用，也会形成循环引用
    }

    // MARK: 测试 3 闭包作为属性，不直接使用self，而是传递vc，也会导致循环引用
    func test3(vc: UIViewController) {
        // self持有task，task持有self（即使是传递下来的），所以会形成循环引用
        self.task = {
            vc.view.backgroundColor = .red
        }
        self.task?()
    }

    // MARK: 测试 4 多层闭包嵌套，在最外一层只使用增加 [weak self]，这种情况下不会导致循环引用
    func test4() {
        self.task = { [weak self] in
            self?.view.backgroundColor = .red
            // 为什么没有形成循环引用呢：self持有task1，task1持有的是已经被weak修饰的self，即弱引用了self，没有对self的引用计数+1，所以没有形成循环引用
            self?.task1 = {
                self?.view.backgroundColor = .red
            }
            self?.task1?()
        }
        self.task?()
    }

    // MARK: 测试 5 多层闭包嵌套，在最外一层使用增加 [weak self]，内部使用guard let strongSelf = self，会导致循环引用
    func test5() {
        /* 小结：+1 -1 操作 在内部不是闭环｜自洽的，内部最终使self的引用计数 = 1，而不是0，所以造成了循环引用
         1. task对self引用计数的影响：task对self的引用计数是自洽的，创建strongSelf时，对self引用计数+1，task执行完，即task栈结束时，对self引用计数-1
         2. task1对self引用计数的影响：task1只对self进行了+1操作，没有-1操作，这是因为task1被vc持有，task1不会释放，所以task1一直持有self
         */
        self.task = { [weak self] in

            // step1: 对 self 执行 +1 操作，此时self的引用计数 = 1
            guard let strongSelf = self else { return }
            strongSelf.view.backgroundColor = .red

            // step2-1: 构造task1函数，task1捕获了self（强引用），对 self 执行 +1 操作，此时self的引用计数 = 2
//            strongSelf.task1 = {
//                strongSelf.view.backgroundColor = .red
//            }

            // step2-2: 不会引起内存泄露
            strongSelf.task1 = { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.view.backgroundColor = .red
            }

            // step3: 执行task1函数：因为task1是作为属性变量存在于self中的，所以task1一直存在（即使task1执行结束了），又因为它的一直存在，所以不会对self进行-1操作，所以此时self的引用计数 仍然 = 2
            strongSelf.task1?()

            // step4: task栈结束，对strongSelf执行-1操作（因为strongSelf是在task闭包内创建的，task执行完，需要对strongSelf执行-1操作，这是本着谁创建谁负责-1的原则），对 self 执行 -1 操作，此时self = 1

            // 结果：因为task1对self的+1，导致没有释放self
        }

        // 如果不执行这个闭包，就不会引起内存泄露，因为最外层是弱引用的，只有闭包执行时，才会在闭包内强持有self
        self.task?()
    }

    // MARK: 测试 6，这个case很有意思
    func test6() {
        // a持有task，task持有a，所以形成循环引用
        let a = A()
        a.task = {
//            self.view.backgroundColor = .red
            a.name = "a"
        }
        a.task?()
    }

    // MARK: 测试 7 闭包作为lazy函数使用，不要在lazy中使用self
    func test7() {
        self.aView.backgroundColor = .red
    }

    // MARK: 测试 8 使用 闭包 = nil，解除self对闭包的引用，可避免循环引用
    func test8() {
        self.task = {
            self.view.backgroundColor = .red
        }
        self.task?()
        self.task = nil // 解除self对闭包的引用
    }

    // MARK: 测试 9 weakSelf后，又strongSelf
    func test9() {

        // vc pop后，会在5s后打印deinit，因为strongSelf了
        // 小结：+1 -1 操作 在内部是闭环｜自洽的，所以内部对self的引用计数的影响为0
        self.task = { [weak self] in
            // step1: 创建strongSelf栈变量，指向self，即对 self 执行 +1 操作，此时self的引用计数 = 1
            guard let strongSelf = self else { return }
            // step2: 构造闭包，访问了self，对self执行+1操作，此时self的引用计数 = 2
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                strongSelf.view.backgroundColor = .red
                // step4: queue栈结束，【系统函数将闭包置为nil】，strongSelf作为栈变量会释放，对self执行-1操作，此时self的引用计数 = 0，self被释放。题外话，如果这个被queue持有的闭包在执行完时，没有被系统释放，则strongSelf不会被释放，也会造成self的内存泄露
            }
            // step3: task栈结束，对self执行-1操作，，此时self的引用计数 = 1
        }

        // vc pop后，会立即打印deinit，因为pop后没有谁持有vc了
//        self.task = { [weak self] in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                self?.view.backgroundColor = .red
//            }
//        }
        self.task?()
    }
}

class A {
    var task: (() -> Void)?
    var name: String?
    deinit {
        print("测试循环引用导致的内存泄露-A")
    }
}
