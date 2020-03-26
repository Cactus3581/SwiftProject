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
        self.navigationController?.navigationBar.isTranslucent = true
        self.extendedLayoutIncludesOpaqueBars = true
    }

    func handleDynamicJumpData() {
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        naviBarHidden(hidden: false, animated: animated)
    }

    func naviBarHidden(hidden: Bool, animated: Bool) {
        self.navigationController?.setNavigationBarHidden(hidden, animated: animated)//无法提供手势滑动pop效果，但是有系统自动的动画效果。
    }
}
