//
//  SwiftProjectTests.swift
//  SwiftProjectTests
//
//  Created by Ryan on 2019/12/18.
//  Copyright © 2019 cactus. All rights reserved.
//

import XCTest
@testable import SwiftProject
/*
 因为测试工程和主工程分属不同Module，所以如果我们想在测试项目中调用主工程代码需要导入主工程

这个时候如果报以上错误，会有以下可能：
 1. targetName错误：这个可以去Target->Build Setting->Product Module Name确认。
 2. 主工程和测试模块支持版本号不一致：保证Build Setting->iOS Deployment Target中的版本号在主工程和测试工程中一致。
*/




class SwiftProjectTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testMVVM() {
        let model = MVCModel(firstName: "long", lastName: "hua", birthday: Date())
        let viewModel = MVVMViewModel(model)
        XCTAssertTrue(viewModel.name == "longhua", "name failed")
    }
}
