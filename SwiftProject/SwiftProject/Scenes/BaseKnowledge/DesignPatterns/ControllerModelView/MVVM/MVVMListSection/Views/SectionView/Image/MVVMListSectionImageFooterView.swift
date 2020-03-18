//
//  MVVMListSectionStyleTwoFooterView.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/3/17.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

class MVVMListSectionImageFooterView: UITableViewHeaderFooterView,MVVMListSectionViewProtocol {

    let button: UIButton?

    override init(reuseIdentifier: String?) {

        let button: UIButton = UIButton()
        self.button = button

        super.init(reuseIdentifier: reuseIdentifier)

        self.contentView.backgroundColor = UIColor.yellow

        self.contentView.addSubview(button)
        button.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        button.setTitleColor(UIColor.darkText,for: .normal)
        button.addTarget(self, action: #selector(ShowAlert), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var sessionViewModel: MVVMListSectionViewModelProtocol? {
        didSet {
            guard let sectionViewModel = self.sessionViewModel as? MVVMListSectionImageViewModelProtocol else {
                return
            }
            button?.setTitle(sectionViewModel.footerImageUrl, for: .normal)
        }
    }
    
    @objc func ShowAlert() {
        guard let sectionViewModel1 = self.sessionViewModel as? MVVMListSectionImageViewModelProtocol else {
            return
        }
        sectionViewModel1.footerShowAlert()
    }

    static var identifier: String {
        return String(describing: self)
    }
}
