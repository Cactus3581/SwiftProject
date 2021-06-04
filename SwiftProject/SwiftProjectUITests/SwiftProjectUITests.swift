//
//  SwiftProjectUITests.swift
//  SwiftProjectUITests
//
//  Created by Ryan on 2019/12/18.
//  Copyright © 2019 cactus. All rights reserved.
//

import XCTest

class SwiftProjectUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
                                    measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }

    func testInboxCardsTwoUpdatesOneDelete() throws {

        let app = XCUIApplication()
        //let cellsOriginalCount = 15
        //app.launchArguments = ["InboxCardsTwoUpdatesOneDeleteMockFeedAPI", String(cellsOriginalCount), String(0)]
        app.launch()
        app.wait1()
        //app.restart()
        app.terminate()
    }
}

extension XCUIApplication {
    func restart() {
        self.terminate()

        let defaultTimeout = 5 as TimeInterval
        if !self.wait(for: .notRunning, timeout: defaultTimeout) {
            XCTFail("App didn't terminate within the alloted time.")
        }

        self.launch()

        if !self.wait(for: .runningForeground, timeout: defaultTimeout) {
            XCTFail("App didn't launch within the alloted time.")
        }
    }

    func wait1() {
        let defaultTimeout = 5 as TimeInterval
        if !self.wait(for: .notRunning, timeout: defaultTimeout) {
            XCTFail("App didn't terminate within the alloted time.")
        }
    }
}
