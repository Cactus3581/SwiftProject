//
//  CBridgeController.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2021/9/15.
//  Copyright © 2021 cactus. All rights reserved.
//

import UIKit

// MARK: - 被C要调用的函数
func swiftFunImplement(key: UnsafePointer<Int8>?) -> Int32 {
    guard let k = key else {
        return Int32(0)
    }
    let str = String(cString: k)
    print("收到一个c函数的Int值->\(str)")
    return Int32(1)
}

class CBridgeController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        testCRunSwift() // c 调用 swift
        testRunC() // 测试调用c 和 c++
    }

    func testCRunSwift() {
        // Swift 3:
        let str1 = ""
        let result2 = str1.withCString { s1 in
            UnsafeMutablePointer(mutating: s1)
        }

        getFgValueOfSwiftImpl = swiftFunImplement(key:)
        print("开始运行---")
        runSwiftFun()
    }

    func testRunC() -> Void {
        print("\n----------------------------\n\n")
        printHellow()
        let cRandomInt = getRandomInt()
        print("\n")
        print("收到C函数的随机数是：\(cRandomInt)")

        let person = createBy("peter", 14)
        printPersonInfo(person)
        let cName = getPersonName(person)
        let name = String(cString: cName!)
        print("fetch name is：\(name)")

        destoryModel(person)
    }
}



