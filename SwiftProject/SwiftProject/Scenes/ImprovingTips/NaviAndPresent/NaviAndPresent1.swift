//
//  NaviAndPresent1.swift
//  SwiftProject
//
//  Created by Ryan on 2020/11/19.
//  Copyright © 2020 cactus. All rights reserved.
//

import Foundation
import UIKit

class NaviAndPresent1: BaseViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let navi = self.presentingViewController as? UINavigationController {
            self.dismiss(animated: false, completion: nil)
            navi.pushViewController(NaviAndPresent2(), animated: true)
        }
        print("")
    }
}
