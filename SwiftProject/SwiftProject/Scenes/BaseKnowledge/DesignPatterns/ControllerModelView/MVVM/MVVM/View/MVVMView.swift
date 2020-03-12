//
//  MVVMView.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

protocol MVVMViewProtocol: NSObjectProtocol {
    func push()
}

class MVVMView: UIView {

    let titleLabel: UILabel?
    let avatarImageView: UIImageView?
    let button: UIButton?
    weak var delegate: MVVMViewProtocol?

    var viewModel: MVVMViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            titleLabel?.text = viewModel.name
            avatarImageView?.image = UIImage(named: viewModel.imageUrl)
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
            make.top.equalTo(label.snp_bottomMargin).offset(10)
            make.centerX.equalTo(label)
        }

        self.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.top.equalTo(avatarImageView.snp_bottomMargin).offset(10)
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
        self.viewModel?.updateData(result: { [unowned self] viewModel in
            self.titleLabel?.text = viewModel.name
        })
    }
}
