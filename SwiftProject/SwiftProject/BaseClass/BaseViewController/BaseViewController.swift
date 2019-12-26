//
//  BaseViewController.swift
//  SwiftProject
//
//  Created by Ryan on 2019/12/18.
//  Copyright © 2019 cactus. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK - 动态跳转
    var dynamicJumpDict: NSDictionary?
    var dynamicJumpString: String?
    var needDynamicJump: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }

    func handleDynamicJumpData() {

    }
}
