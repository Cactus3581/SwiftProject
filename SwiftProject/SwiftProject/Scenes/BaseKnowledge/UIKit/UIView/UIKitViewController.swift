//
//  UIKitViewController.swift
//  SwiftProject
//
//  Created by Ryan on 2021/1/27.
//  Copyright © 2021 cactus. All rights reserved.
//

import UIKit

class UIKitViewController: BaseViewController {

    let view1 = UIView()
    let view2 = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view1.backgroundColor = .red
        view2.backgroundColor = .green
        view.addSubview(view1)
        //将view2添加在view1后面
        view.insertSubview(view2, belowSubview: view1)

        view1.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.center.equalToSuperview()
        }

        view2.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.top.equalTo(view1).offset(30)
            make.leading.equalTo(view1).offset(30)
        }
    }
}
