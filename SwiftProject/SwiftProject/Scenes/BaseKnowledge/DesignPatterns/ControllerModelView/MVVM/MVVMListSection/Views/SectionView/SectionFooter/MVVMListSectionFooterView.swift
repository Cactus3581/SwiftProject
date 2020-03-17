//
//  MVVMListSecFooterView.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/3/12.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class MVVMListSectionFooterView: UITableViewHeaderFooterView {

    let button: UIButton?

    var viewModel: MVVMListSectionViewModelProtocol? {
        didSet {
            guard let sectionViewModel = self.viewModel  else {
                return
            }
            // 赋值
            button?.setTitle(sectionViewModel.footerTitle, for: .normal)
        }
    }

    override init(reuseIdentifier: String?) {

        let button: UIButton = UIButton()
        self.button = button

        super.init(reuseIdentifier: reuseIdentifier)

        self.contentView.backgroundColor = UIColor.green

        self.contentView.addSubview(button)
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        button.setTitleColor(UIColor.white,for: .normal)
        button.addTarget(self, action: #selector(click), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func click(){

    }

    func jump(){

    }
    static var identifier: String {
        return String(describing: self)
    }
}
