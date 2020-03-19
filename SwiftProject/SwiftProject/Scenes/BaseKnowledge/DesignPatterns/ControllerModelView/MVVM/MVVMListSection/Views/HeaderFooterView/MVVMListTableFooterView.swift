//
//  MVVMListTableFooterView.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/12.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit


class MVVMListTableFooterView: UIView {

    let button: UIButton?

    override init(frame: CGRect) {

        let button: UIButton = UIButton()
        self.button = button

        super.init(frame: frame)

        self.backgroundColor = UIColor.lightGray

        self.addSubview(button)
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        button.setTitleColor(UIColor.white,for: .normal)
        button.addTarget(self, action: #selector(jump), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var viewModel: MVVMListSecViewModel? {
        didSet {
            button?.setTitle(viewModel?.model?.footer?.title, for: .normal)
        }
    }
    
    @objc func jump(){
        self.viewModel?.footerJump()
    }
}
