//
//  ClassStructViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/2.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class ClassStructViewController: BaseViewController {

    let dataQueue = OperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem(title:"show",
                                   style:.plain,
                                   target:self,
                                   action:#selector(click2))
        self.navigationItem.rightBarButtonItem = item
    }
// MARK: 修改值是否会影响其他值：Copy后修改值，不会影响原来的值，原地修改，会改变原来的值
    @objc
    func click() {
        var model = StructOneModel() {
            didSet {
                print("didSet: \(model.oneName), \(model.list)")
            }
        }
        model.oneName = "0"
        model.list = []
        
        // 这个case说明不使用copy，直接改写会影响原来的值
        DispatchQueue.global().async {
            model.oneName = "1"
            model.list.append(1)
            print("global-1: \(model.oneName), \(model.list)")
        }
        sleep(2)
        print("main-1: \(model.oneName), \(model.list)")

        // 这个case说明先copy再改写，不会影响原来的值
        DispatchQueue.global().async {
            var a = model
            a.oneName = "2"
            a.list = [1, 2, 3]
            print("global-2: \(model.oneName), \(model.list), \(a.oneName), \(a.list)")
        }
        sleep(2)
        print("main-2: \(model.oneName), \(model.list)")

        //先copy再改变原值，新值不会受影响
        DispatchQueue.global().async {
            var a = model
            model.oneName = "3"
            model.list = [1, 2, 3, 4]
            print("global-3: \(model.oneName), \(model.list), \(a.oneName), \(a.list)")
        }

        sleep(2)
        //使用copy，读的都是原始变量指向的最新值，而不是执行到DispatchQueue.main.async状态时的值
        DispatchQueue.main.async {
            var a = model
            print("main-3: \(model.oneName), \(model.list), \(a.oneName), \(a.list)")
        }

        //不使用copy，读的都是原始变量指向的最新值，，而不是执行到DispatchQueue.main.async状态时的值
        DispatchQueue.main.async {
            print("main-4: \(model.oneName), \(model.list)")
        }
    }
    
// MARK: 修改值是否会影响其他值：Copy后修改值，不会影响原来的值，原地修改，会改变原来的值
    @objc
    func click1() {
        var model = StructOneModel()
        model.oneName = "0"
        model.list = [0]
        
        // 这个case说明不使用copy，直接改写会影响原来的值
        
        DispatchQueue.global().async { [model] in
            sleep(2)
            print("global-1: \(model.oneName), \(model.list)")
        }
        
        DispatchQueue.global().async {
            sleep(2)
            print("global-2: \(model.oneName), \(model.list)")
        }
        
        DispatchQueue.global().async {
            model.oneName = "1"
            model.list.append(1)
            print("global-3: \(model.oneName), \(model.list)")
        }
        
        model.oneName = "2"
        model.list.append(2)
        print("main-5: \(model.oneName), \(model.list)")
        DispatchQueue.global().async { [model] in
            sleep(2)
            print("global-4: \(model.oneName), \(model.list)")
        }
    }
    
// MARK: 修改值是否会影响其他值：Copy后修改值，不会影响原来的值，原地修改，会改变原来的值
    @objc
    func click2() {
        var model = StructOneModel()
        model.oneName = "0"
        model.list = [0]
        
        // 这个case说明不使用copy，直接改写会影响原来的值
        
        dataQueue.maxConcurrentOperationCount = 1
        dataQueue.qualityOfService = .userInteractive
        
        for i in 0..<4  {
            dataQueue.addOperation {
                model.oneName = "\(i)"
                model.list.append(i)
                print("global: \(model.oneName), \(model.list)")
                fire1(i: i)
                fire2(i: i)
                fire3(i: i)
                fire4(model, i: i)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    model.oneName = "10-\(i)"
                }
            }
        }
        
        // ❌
        func fire1(i: Int) {
            executeOnMainThread() {
                print("main1: \(model.oneName), \(model.list)")
            }
        }
        
        // ✅
        func fire2(i: Int) {
            executeOnMainThread() { [model] in
                print("main2: \(model.oneName), \(model.list)")
            }
        }
        
        // ✅，但是都重新写值了，为什么还会错呢
        func fire3(i: Int) {
            var a = model
            executeOnMainThread() {
                print("main3: \(a.oneName), \(a.list)")
            }
        }
        
        // ✅
        func fire4(_ model: StructOneModel, i: Int) {
            executeOnMainThread() {
                print("main4: \(model.oneName), \(model.list)")
            }
        }
        
        func executeOnMainThread(_ task: @escaping (() -> Void)) {
            if Thread.isMainThread {
                task()
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                DispatchQueue.main.async {
                    task()
                }
            }
        }
    }
}
