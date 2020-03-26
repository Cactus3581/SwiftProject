//
//  MVCView.swift
//  SwiftProject
//
//  Created by ryan on 2019/12/29.
//  Copyright © 2019 cactus. All rights reserved.
//

import UIKit

protocol MVCViewProtocol: NSObjectProtocol {
    func click()
    func push()
}

class MVCView: UIView {

    let titleLabel: UILabel?
    let avatarImageView: UIImageView?
    let button: UIButton?
    weak var delegate: MVCViewProtocol?

    var model: MVCModel? {
        didSet {
            guard let model = model else {
                return
            }
            titleLabel?.text = model.name
            avatarImageView?.image = UIImage(named: model.imageUrl)
        }
    }

    override init(frame: CGRect) {
        let label: UILabel = UILabel()
        self.titleLabel = label
        let avatarImageView:UIImageView  = UIImageView()
        self.avatarImageView = avatarImageView
        let button: UIButton = UIButton()
        self.button = button

        super.init(frame: frame)

        self.backgroundColor = UIColor.white

        self.addSubview(label)
        label.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(10)
        }
        label.textColor = UIColor.red

        self.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(10)
            make.centerX.equalTo(label)
        }

        self.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.top.equalTo(avatarImageView.snp.bottom).offset(10)
            make.bottom.equalTo(self)
            make.centerX.equalTo(label)
        }
        button.backgroundColor = UIColor.blue
        button.setTitle("click", for: .normal)
        button.addTarget(self, action: #selector(push), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func push() {
        delegate?.push()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.click()
    }
}
