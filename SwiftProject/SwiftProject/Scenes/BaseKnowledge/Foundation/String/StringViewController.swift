//
//  StringViewController.swift
//  SwiftProject
//
//  Created by Ryan on 2020/9/16.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class StringViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let descObj = PrintDesc()
        print(descObj.description)
    }
}

// Mark: 结构体转json
struct TestJson {
    let name = "name1"
    let testJsonInObjc = TestJsonIn()
    struct TestJsonIn {
        let name = "name2"
    }
}


// Mark: 结构体转json
struct PrintDesc {
    let name = "name1"
    let isShow = true

    public var description: String {
        dictDescription.description
    }

    public var dictDescription: [String: String] {
        return [
            "keyName": name,
            "keyName": "name",
            "keyName": "\(name)",
            "isShow": "\(isShow)"]
    }
}
