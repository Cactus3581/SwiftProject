//
//  GCDViewController.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/19.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class GCDViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let queue1 = DispatchQueue(label: "queue1", qos: .utility) // 默认串行
        let queue2 = DispatchQueue(label: "queue1", qos: .utility, attributes: .concurrent)
        let queue3 = DispatchQueue(label: "queue13", qos: .utility,
        attributes: .initiallyInactive) //需要程序员去手动触发

        queue1.async {
            for i in 5..<10 {
                print(i)
            }
        }

        //需要调用activate，激活队列。
        queue3.activate()
    }
}
