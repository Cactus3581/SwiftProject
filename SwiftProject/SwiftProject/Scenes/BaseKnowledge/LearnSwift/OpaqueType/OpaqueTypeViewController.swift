//
//  OpaqueTypeViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/3.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class OpaqueTypeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        func makeA() -> some Equatable {
            return "A"
        }

        let a = makeA()
        let anotherA = makeA()
        print(a == anotherA)

    }
}
