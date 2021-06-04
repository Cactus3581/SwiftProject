//
//  NaviAndPresent2.swift
//  SwiftProject
//
//  Created by Ryan on 2020/11/19.
//  Copyright © 2020 cactus. All rights reserved.
//


import Foundation
import UIKit

class NaviAndPresent2: BaseViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.navigationController?.popViewController(animated: true)
    }
}
