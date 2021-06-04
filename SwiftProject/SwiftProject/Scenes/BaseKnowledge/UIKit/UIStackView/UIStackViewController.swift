//
//  UIStackViewController.swift
//  SwiftProject
//
//  Created by Ryan on 2021/2/24.
//  Copyright © 2021 cactus. All rights reserved.
//

import UIKit
import SnapKit

class UIStackViewController: BaseViewController {

    private let stackView = UIStackView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }

    func initializeUI() {
        view.addSubview(stackView)
        stackView.backgroundColor = .red
        stackView.snp.makeConstraints { (make) in
            make.height.equalTo(100)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }

        /*
          ContentHuggingPriority：抗拉伸属性，默认250，表示当前的Label的内容不想被拉伸
          ContentCompressionResistancePriority：抗压缩属性，默认750，表示当前的Label的内容不想被收缩
          需要考虑两种情况，
         1. 左右两边数据都不足的时候，谁拉伸？
         2. 左右两边数据都充足的时候，谁收缩？
         */
        let label1 = UILabel()
        label1.backgroundColor = .green
        label1.text = "dasdadadasdadaddsa看见很快就会哭好久开会开会就开会就开会开会看见很快就会哭好久开会开会就开会就开会开会"
//        label1.frame = CGRect(x: 0, y: 0, width: 1000, height: 30)
        stackView.addArrangedSubview(label1)

//        let label2 = UILabel()
//        self.view.addSubview(label2)
//        label2.text = "看见很快就会哭好久开会开会就开会就开会开会"
//        stackView.addArrangedSubview(label2)

        let view1 = UIView()
        view1.backgroundColor = .green
        view1.frame = CGRect(x: 0, y: 0, width: 1000, height: 30)
//        stackView.addArrangedSubview(view1)
    }
}
