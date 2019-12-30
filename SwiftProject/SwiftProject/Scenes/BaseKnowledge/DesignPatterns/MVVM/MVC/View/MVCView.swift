//
//  MVCView.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2019/12/29.
//  Copyright © 2019 cactus. All rights reserved.
//

import UIKit

protocol MVCProtocol: NSObjectProtocol {
    func touchBegin()
}

class MVCView: UIView {

    let nameLabel: UILabel?
    let birthdayLabel: UILabel?
    weak var delegate: MVCProtocol?

    override init(frame: CGRect) {
        let label = UILabel()
        label.textColor = UIColor.red
        self.nameLabel = label

        let birthdayLabel = UILabel()
        birthdayLabel.textColor = UIColor.green
        self.birthdayLabel = birthdayLabel

        super.init(frame: frame)

        self.backgroundColor = UIColor.white
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }

        self.addSubview(birthdayLabel)
        birthdayLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(label)
            make.top.equalTo(label.snp_bottomMargin)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.touchBegin()
    }
}
