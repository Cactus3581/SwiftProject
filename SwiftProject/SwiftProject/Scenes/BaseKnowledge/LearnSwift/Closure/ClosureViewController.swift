//
//  ClosureViewController.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/1/2.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class ClosureViewController: BaseViewController {

    var block1: ((Int, Int) -> Int)?
    var a = 10

    override func viewDidLoad() {
        super.viewDidLoad()


        let block = { (a: Int, b: Int) -> Int in
            return a+b
        }

        let c =  block(1,2)
        print(c)

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
