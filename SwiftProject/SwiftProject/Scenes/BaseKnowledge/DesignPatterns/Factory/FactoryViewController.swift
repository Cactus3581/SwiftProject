//
//  FactoryViewController.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/1/4.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class FactoryViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Factory1.factory(type: 0)
        Factory2.factory()
        Factory3.factory()


    }


}
