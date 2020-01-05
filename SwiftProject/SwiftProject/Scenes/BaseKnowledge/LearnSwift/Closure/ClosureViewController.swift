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

        let names = ["Chris","Alex","Ewa","Barry","Daniella"]
        func backward(_ s1: String, _ s2: String) -> Bool {
            return s1 > s2
        }
        var reversedNames = names.sorted(by: backward)
        print("\(reversedNames)")

        var closure = { (s1: String, s2: String) -> Bool in
            return s1 > s2
        }

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

        reversedNames = names.sorted(by: closure)
        print("\(reversedNames)")

        let block = { (a: Int, b: Int) -> Int in
            return a+b
        }

        let c =  closure("a","b")
        print(c)

        //MARK:尾随闭包

        func loadData(finished: @escaping (Int,Int) -> Int) {
            // 记录闭包
            self.block1 = finished
        }

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

    }
}
