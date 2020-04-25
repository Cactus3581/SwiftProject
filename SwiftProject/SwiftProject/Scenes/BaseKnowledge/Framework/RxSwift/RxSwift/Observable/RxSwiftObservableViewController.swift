//
//  RxSwiftObservableViewController.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/4/18.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxSwiftObservableViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let smallModel = SmallModel(text: "1")
        let bigModel = BigModel(smallModel: smallModel)
        if var smallModel = bigModel.list.first {
            smallModel.change(text: "2")
        }
        print(bigModel)
    }
}

struct BigModel {
    var list: [SmallModel] = []
    init(smallModel: SmallModel) {
        list.append(smallModel)
    }
}

struct SmallModel {
    var text: String
    mutating func change(text: String) {
        self.text = text
    }
}
