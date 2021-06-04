//
//  ArrayViewController.swift
//  SwiftProject
//
//  Created by Ryan on 2020/11/4.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class ArrayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let array = [1, 2, 3]

        let dict = ["a": 1,
                    "b": 2,
                    "c": 3]

        array.forEach { item in
            print(item)
        }

        // 块遍历
        for (index, item) in array.enumerated() {
            print("\(index): \(item)")
        }

        // for in
        for (key, value) in dict {
            print("\(key): \(value)")
        }

    }
}
