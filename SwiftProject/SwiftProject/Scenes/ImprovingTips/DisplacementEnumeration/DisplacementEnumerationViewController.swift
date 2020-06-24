//
//  DisplacementEnumerationViewController.swift
//  SwiftProject
//
//  Created by Ryan on 2020/6/23.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

//位移枚举
 struct Status : OptionSet {
    let rawValue: Int
    static let normal = Status(rawValue: 1)
    static let searching = Status(rawValue: 2)
    static let filtering = Status(rawValue: 4)
}


class DisplacementEnumerationViewController: BaseViewController {

    var status: Status = [.normal]

    override func viewDidLoad() {
        super.viewDidLoad()


        //        print(status.contains(.normal))
        //        print(status.contains(.searching))
        //        print(status.contains(.filtering))
        //        status = [.normal, .searching]
        //        print(status.contains(.normal))
        //        print(status.contains(.searching))
        //        print(status.contains(.filtering))
        status = [.normal, .searching, .filtering]
        //        print(status.contains(.normal))
        //        print(status.contains(.searching))
        //        print(status.contains(.filtering))


        //  交集
        let commonEvents = status.intersection(.filtering)
        print(commonEvents)

        print(commonEvents.contains(.normal))
        print(commonEvents.contains(.searching))
        print(commonEvents.contains(.filtering))

    }
}
