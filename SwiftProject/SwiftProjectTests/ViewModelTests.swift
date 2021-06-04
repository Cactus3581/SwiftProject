//
//  ViewModelTests.swift
//  SwiftProjectTests
//
//  Created by 夏汝震 on 2020/8/25.
//  Copyright © 2020 cactus. All rights reserved.
//

import XCTest
@testable import SwiftProject

class ViewModelTests: XCTestCase {

    override static func setUp() {
        print("testtest case setUp")

        for i in 2..<10 {
            print(i)
        }
    }

    override func setUp() {
        super.setUp()
        print("testtest setUp")
    }

    func testAssert() {
        print("testtest testExample")
        let vm = TestViewModel()

        // 直接使用XCTAssert
        XCTAssert(vm.var2 == 1)

        // 测试表达式是否为真
        XCTAssertTrue(vm.var2 == 1)

        //测试是否为nil
        XCTAssertNotNil(vm.var3)

        // 测试是否相等
        XCTAssertEqual(vm.var1, "a")

        // 比较大小
        XCTAssertLessThan(vm.var2, 2)
        XCTAssertLessThanOrEqual(vm.var2, 2)

        XCTAssertGreaterThan(vm.var2, 0)
        XCTAssertGreaterThanOrEqual(vm.var2, 0)

        // 测试错误
        XCTAssertNoThrow(try vm.test(number: 1))// 参数为1，不会抛出错误
        XCTAssertThrowsError(try vm.test(number: 0)) // 参数为0，会抛出错误
    }

    func testAsync() {
        print("testtest testAsync")

        let expect = expectation(description: "test async")
        expect.expectedFulfillmentCount = 2
        var a = 1
        asyncInGlobal {
            a += 1
            expect.fulfill()
            expect.fulfill()
        }
        XCTAssertEqual(a, 1)
        wait(for: [expect], timeout: 1)
        XCTAssertEqual(a, 2)
    }

    private func asyncInMain(_ block: @escaping (() -> Void)) {
        DispatchQueue.main.async {
            block()
        }
    }

    private func asyncInGlobal(_ block: @escaping (() -> Void)) {
        DispatchQueue.global().async {
            block()
        }
    }

    override func tearDown() {
        print("testtest tearDown")
        super.tearDown()
    }

    override static func tearDown() {
        print("testtest case tearDown")
    }
}
