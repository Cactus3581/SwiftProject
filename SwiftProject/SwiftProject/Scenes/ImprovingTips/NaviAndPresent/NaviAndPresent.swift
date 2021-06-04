//
//  NaviAndPresent.swift
//  SwiftProject
//
//  Created by Ryan on 2020/11/19.
//  Copyright © 2020 cactus. All rights reserved.
//

import Foundation
import UIKit

class NaviAndPresent: BaseViewController {


    struct TrackSwitchTypeData {
        var initView = TrackSwitchTaskTime()
        var setFilter = TrackSwitchTaskTime()
        var getFeedCards: TimeInterval = 0
        var renderFinish = false
    }

    struct TrackSwitchTaskTime {
        var startTime: Date?
        var cost: TimeInterval?

        mutating func start() {
            startTime = Date()
        }

        mutating func end() {
            cost = 10
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red


        let dict = ["A": "a", "B": "b"]
        let a = dict.compactMap({$0+$1})
        print(a)

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        let vc = NaviAndPresent1()
//        let navi = UINavigationController(rootViewController: vc)
        self.present(vc, animated: true, completion: nil)
    }
}
