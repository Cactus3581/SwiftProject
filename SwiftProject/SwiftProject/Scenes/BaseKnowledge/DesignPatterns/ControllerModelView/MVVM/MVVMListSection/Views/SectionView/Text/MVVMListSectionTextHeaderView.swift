//
//  MVVMListSectionTextHeaderView.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/12.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit



class MVVMListSectionTextHeaderView: UITableViewHeaderFooterView,MVVMListSectionViewProtocol {

    let button: UIButton?

    override init(reuseIdentifier: String?) {

        let button: UIButton = UIButton()
        self.button = button

        super.init(reuseIdentifier: reuseIdentifier)

        self.contentView.backgroundColor = UIColor.green

        self.contentView.addSubview(button)
        button.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        button.setTitleColor(UIColor.white,for: .normal)
        button.addTarget(self, action: #selector(footerClick), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var sessionViewModel: MVVMListSectionViewModelProtocol? {
        didSet {
            guard let sectionViewModel = self.sessionViewModel as? MVVMListSectionTextViewModelProtocol else {
                return
            }
            button?.setTitle(sectionViewModel.headerText, for: .normal)
        }
    }
    
    @objc func footerClick() {
        guard let sectionViewModel1 = self.sessionViewModel as? MVVMListSectionTextViewModelProtocol else {
            return
        }
        sectionViewModel1.footerClick()
    }

    static var identifier: String {
        return String(describing: self)
    }
}
